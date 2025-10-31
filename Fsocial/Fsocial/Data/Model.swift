//
//  Model.swift
//  Fsocial
//
//  Created by Huy Tran on 31/10/25.
//

import Foundation

import UIKit
import SwiftUI

struct QAOption: Codable { let index: Int; let text: String }
struct QAItem: Codable {
    let number: Int
    let chapter: String
    let question: String
    let options: [QAOption]
    let correctIndexes: [Int]
    let image: String?
    let correctOptionIndex: Int?
    let correctOptionText: String?
    enum CodingKeys: String, CodingKey {
        case number, chapter, question, options, image
        case correctIndexes = "correct_indexes"
        case correctOptionIndex = "correct_option_index"
        case correctOptionText = "correct_option_text"
    }
}


enum QALoader {
    /// Loads questions from bundle JSON ("250_questions.json").
    static func loadFromBundle(filename: String = "bo_600_questions", ext: String = "json") -> [QAItem] {
        if let url = Bundle.main.url(forResource: filename, withExtension: ext) {
            do { return try JSONDecoder().decode([QAItem].self, from: Data(contentsOf: url)) } catch { print("⚠️ JSON decode:", error) }
        }
        // Fallback: 1-item sample (matches your schema)
        let sample = """
[{
"number":1,
"chapter":"CHƯƠNG I. QUY ĐỊNH CHUNG VÀ QUY TẮC
GIAO THÔNG ĐƯỜNG BỘ",
"question":"Phần của đường bộ được sử dụng cho phương tiện giao thông đường bộ đi lại là gì?",
"options":[{"index":1,"text":"Phần mặt đường và lề đường."},{"index":2,"text":"Phần đường xe chạy."},{"index":3,"text":"Phần đường xe cơ giới."}],
"correct_indexes":[2],"image":"","correct_option_index":2,"correct_option_text":"Phần đường xe chạy."}]
""".data(using: .utf8)!
        do { return try JSONDecoder().decode([QAItem].self, from: sample) } catch { return [] }
    }
}

enum LicenseCategory: String, CaseIterable, Codable {
    case A = "A"
    case A1 = "A1"
    case B1 = "B1"
    case B = "B"
    case C1 = "C1"
    case C = "C"
    case D1 = "D1"
    case D2 = "D2"
    case D = "D"
    case BE = "BE"
    case C1E = "C1E"
    case CE = "CE"
    case D1E = "D1E"
    case D2E = "D2E"
    case DE = "DE"
    
    var description: String {
        switch self {
        case .A1:
            return """
              Người lái xe mô tô hai bánh có dung tích xi-lanh đến 125 cm3 hoặc có công suất động cơ điện đến 11 kW.
              """
            
        case .A:
            return """
              - Người lái xe mô tô hai bánh có dung tích xi-lanh trên 125 cm3 hoặc có công suất động cơ điện trên 11 kW.
              - Các loại xe quy định cho giấy phép lái xe hạng A1.
              """
            
        case .B1:
            return """
              - Người lái xe mô tô ba bánh.
              - Các loại xe quy định cho giấy phép lái xe hạng A1.
              """
            
        case .B:
            return """
              - Người lái xe ô tô chở người đến 08 chỗ (không kể chỗ của người lái xe).
              - Xe ô tô tải và ô tô chuyên dùng có khối lượng toàn bộ theo thiết kế đến 3.500 kg.
              - Các loại xe ô tô quy định cho giấy phép lái xe hạng B kéo rơ moóc có khối lượng toàn bộ theo thiết kế đến 750 kg.
              """
            
        case .C1:
            return """
              - Người lái xe ô tô tải và ô tô chuyên dùng có khối lượng toàn bộ theo thiết kế trên 3.500 kg đến 7.500 kg.
              - Các loại xe ô tô tải quy định cho giấy phép lái xe hạng C1 kéo rơ moóc có khối lượng toàn bộ theo thiết kế đến 750 kg.
              """
            
        case .C:
            return """
              - Người lái xe ô tô tải và ô tô chuyên dùng có khối lượng toàn bộ theo thiết kế trên 7.500 kg.
              - Các loại xe ô tô tải quy định cho giấy phép lái xe hạng C kéo rơ moóc có khối lượng toàn bộ theo thiết kế đến 750 kg.
              - Các loại xe quy định cho giấy phép lái xe hạng B và hạng C1.
              """
            
        case .D1:
            return """
              - Người lái xe ô tô chở người trên 08 chỗ (không kể chỗ của người lái xe) đến 16 chỗ (không kể chỗ của người lái xe).
              - Các loại xe ô tô chở người quy định cho giấy phép lái xe hạng D1 kéo rơ moóc có khối lượng toàn bộ theo thiết kế đến 750 kg.
              - Các loại xe quy định cho giấy phép lái xe các hạng B, C1, C.
              """
            
        case .D2:
            return """
              - Người lái xe ô tô chở người (kể cả xe buýt) trên 16 chỗ (không kể chỗ của người lái xe) đến 29 chỗ (không kể chỗ của người lái xe).
              - Các loại xe ô tô chở người quy định cho giấy phép lái xe hạng D2 kéo rơ moóc có khối lượng toàn bộ theo thiết kế đến 750 kg.
              - Các loại xe quy định cho giấy phép lái xe các hạng B, C1, C, D1.
              """
            
        case .D:
            return """
              - Người lái xe ô tô chở người (kể cả xe buýt) trên 29 chỗ (không kể chỗ của người lái xe).
              - Xe ô tô chở người giường nằm.
              - Các loại xe ô tô chở người quy định cho giấy phép lái xe hạng D kéo rơ moóc có khối lượng toàn bộ theo thiết kế đến 750 kg.
              - Các loại xe quy định cho giấy phép lái xe các hạng B, C1, C, D1, D2.
              """
            
        case .BE:
            return """
              Người lái các loại xe ô tô quy định cho giấy phép lái xe hạng B kéo rơ moóc có khối lượng toàn bộ theo thiết kế trên 750 kg.
              """
            
        case .C1E:
            return """
              Người lái các loại xe ô tô quy định cho giấy phép lái xe hạng C1 kéo rơ moóc có khối lượng toàn bộ theo thiết kế trên 750 kg.
              """
            
        case .CE:
            return """
              - Người lái các loại xe ô tô quy định cho giấy phép lái xe hạng C kéo rơ moóc có khối lượng toàn bộ theo thiết kế trên 750 kg.
              - Xe ô tô đầu kéo kéo sơ mi rơ moóc.
              """
            
        case .D1E:
            return """
              Người lái các loại xe ô tô quy định cho giấy phép lái xe hạng D1 kéo rơ moóc có khối lượng toàn bộ theo thiết kế trên 750 kg.
              """
            
        case .D2E:
            return """
              Người lái các loại xe ô tô quy định cho giấy phép lái xe hạng D2 kéo rơ moóc có khối lượng toàn bộ theo thiết kế trên 750 kg.
              """
            
        case .DE:
            return """
              Người lái các loại xe ô tô quy định cho giấy phép lái xe hạng D kéo rơ moóc có khối lượng toàn bộ theo thiết kế trên 750 kg; xe ô tô chở khách nối toa.
              """
        }
    }
}

enum ExamCategory: String, CaseIterable, Codable, Identifiable {
    case question600 = "Toàn bộ 600 câu hỏi"
    case question250 = "250 câu sát hạch xe máy"
    case question60DiemLiet = "60 câu điểm liệt"
    case bienBao = "Các biển báo giao thông"
    case meoGhiNho = "Mẹo ghi nhớ"
    case cauBiSai = "Các câu bị sai"
    case cauHoiKho = "Các câu hỏi khó"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .question600:       return "book.closed"
        case .question250:       return "bicycle"          // xe máy: bike icon
        case .question60DiemLiet:return "exclamationmark.shield"
        case .bienBao:           return "signpost.right"
        case .meoGhiNho:         return "lightbulb"
        case .cauBiSai:          return "xmark.octagon"
        case .cauHoiKho:         return "questionmark.circle"
        }
    }
    
    var tint: Color {
        switch self {
        case .question600:       return .blue
        case .question250:       return .teal
        case .question60DiemLiet:return .red
        case .bienBao:           return .orange
        case .meoGhiNho:         return .yellow
        case .cauBiSai:          return .pink
        case .cauHoiKho:         return .purple
        }
    }
}
