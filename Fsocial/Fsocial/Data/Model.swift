//
//  Model.swift
//  Fsocial
//
//  Created by Huy Tran on 31/10/25.
//

import Foundation

import UIKit

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
