//
//  MultipartFormData.swift
//  Networking
//
//  Created by ChungTV on 21/02/2022.
//

import Foundation
#if !os(macOS)
import MobileCoreServices
#else
import CoreServices
#endif

public struct MMultipartFormDataChars {
    static let crlf = "\r\n"
}

public struct MMultipartFormDataMimeType {
    static let octetStream = "application/octet-stream"
}

public protocol MMultipartFormDataType {
    func getData(boundary: String) -> Data
}

public struct MMultipartFormData: MMultipartFormDataType {

    public enum Provider {
        case string(String)
        case data(Data)
        case file(URL)
    }

    let provider: Provider

    let name: String

    private let fileName: String?
    private let mimeType: String?

    public init(provider: Provider,
                name: String,
                fileName: String? = nil,
                mimeType: String? = nil) {

        self.name = name
        self.provider = provider
        self.fileName = fileName
        self.mimeType = mimeType
    }

    public func getData(boundary: String) -> Data {
        switch provider {
        case .string(let string):
            var formData = Data()
            formData.append("--\(boundary)\(MMultipartFormDataChars.crlf)".data())
            formData.append("Content-Disposition: form-data; name=\"\(name)\"\(MMultipartFormDataChars.crlf)\(MMultipartFormDataChars.crlf)".data())
            formData.append("\(string)\(MMultipartFormDataChars.crlf)".data())
            return formData

        case .data(let data):
            let fileName = self.fileName ?? "file"
            let mimeType = self.mimeType ?? MMultipartFormDataMimeType.octetStream

            return formData(with: data, boundary: boundary, fileName: fileName, mimeType: mimeType)

        case .file(let url):
            guard let data = try? Data(contentsOf: url) else {
                return Data()
            }

            let fileName = url.lastPathComponent
            let mimeType = contentType(for: url.pathExtension)

            return formData(with: data, boundary: boundary, fileName: fileName, mimeType: mimeType)
        }
    }

    private func formData(with data: Data, boundary: String, fileName: String, mimeType: String) -> Data {
        var formData = Data()

        formData.append("--\(boundary)\(MMultipartFormDataChars.crlf)".data())
        formData.append("Content-Disposition: form-data; name=\"\(name)\"; ".data()) // last space is required
        formData.append("filename=\"\(fileName)\"\(MMultipartFormDataChars.crlf)".data())
        formData.append("Content-Type: \(mimeType)\(MMultipartFormDataChars.crlf)\(MMultipartFormDataChars.crlf)".data())
        formData.append(data)
        formData.append(MMultipartFormDataChars.crlf.data())

        return formData
    }

}

public protocol MultipartFormDataBuilderType {
    var boundary: String { get }
    func build() -> Data
}

public class MultipartFormDataBuilder: MultipartFormDataBuilderType {

    lazy public var boundary = String(format: "networking.boundary.%08x%08x", arc4random(), arc4random())

    private var httpBody = Data()
    public var forms = [MMultipartFormDataType]()
    
    public init() {}

    @discardableResult
    public func append(_ formData: MMultipartFormDataType) -> MultipartFormDataBuilder {
        forms.append(formData)
        return self
    }

    public func build() -> Data {
        forms.forEach {
            httpBody.append($0.getData(boundary: boundary))
        }

        httpBody.append("--\(boundary)--\(MMultipartFormDataChars.crlf)".data())
        return httpBody
    }
}

private func contentType(for pathExtension: String) -> String {
    guard let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as CFString, nil)?.takeRetainedValue() else {
        return MMultipartFormDataMimeType.octetStream
    }

    let contentTypeCString = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue()

    guard let contentType = contentTypeCString as String? else {
        return MMultipartFormDataMimeType.octetStream
    }

    return contentType
}

private extension String {
    func data() -> Data {
        return self.data(using: .utf8) ?? Data()
    }
}
