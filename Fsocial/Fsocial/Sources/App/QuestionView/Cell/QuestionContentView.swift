//
//  QuestionContentView.swift
//  Fsocial
//
//  Created by Huy Tran on 31/10/25.
//

import SwiftUI


// MARK: - Main View (đÃ CẬP NHẬT)
struct QuestionContentView: View {
    let item: QAItem
    @State private var selected: Int? = nil        // Lựa chọn tạm (chưa xác nhận)
    @State private var selectedIndex: Int? = nil   // Lựa chọn đã xác nhận (để chấm)

    private var correctSet: Set<Int> { Set(item.correctIndexes) }
    private var showExplanation: Bool { selectedIndex != nil }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text("\(item.question)")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.primary)
                        .padding(.top, 4)

                    if let image = UIImage(named: "image-\(item.number)") {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: UIScreen.main.bounds.size.width - 32,
                                   maxHeight: UIScreen.main.bounds.size.width / 2)
                            .clipped()
                            .allowsHitTesting(false)
                    }

                    // OPTIONS
                    VStack(spacing: 12) {
                        ForEach(item.options, id: \.self.index) { opt in
                            OptionRow(
                                index: opt.index,
                                text: opt.text,
                                state: state(for: opt.index),
                                isEnabled: selectedIndex == nil // sau khi xác nhận thì khoá
                            ) {
                                withAnimation(.spring(response: 0.25)) {
                                    selected = opt.index
                                }
                            }
                        }
                    }
                    .padding(.top, 6)
                    if showExplanation {
                        ExplanationCard(
                            title: "Đáp án đúng:",
                            text: explanationText()
                        )
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                        .padding(.top, 8)
                    }

                    Spacer(minLength: 20)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
        }
        if selected != nil && selectedIndex == nil {
            Button {
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
                withAnimation(.easeInOut(duration: 0.2)) {
                    selectedIndex = selected
                }
            } label: {
                Text("Xác nhận")
                    .font(.semibold(size: 14))
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
             
            }
            .padding()
            .background(Color(.primary))
            .cornerRadius(10)
            .padding(.horizontal)
            .padding(.vertical, 10)
        }
    }

    // MARK: Helpers
    private func explanationText() -> String {
        if let t = item.correctOptionText, !t.isEmpty { return t }
        if let idx = item.correctOptionIndex,
           let text = item.options.first(where: {$0.index == idx})?.text {
            return "Đáp án đúng: \(text)"
        }
        let labels = item.options
            .filter { correctSet.contains($0.index) }
            .map { "\($0.index). \($0.text)" }
            .joined(separator: "\n")
        return labels.isEmpty ? "Đáp án đang cập nhật." : "Đáp án đúng:\n\(labels)"
    }

    private func state(for optionIndex: Int) -> OptionRow.State {
        // Chưa xác nhận: chỉ highlight vàng đáp án đang chọn
        if selectedIndex == nil {
            return (selected == optionIndex) ? .pendingSelected : .normal
        }

        // Đã xác nhận: chấm đúng/sai + lộ đáp án đúng nếu chọn sai
        guard let picked = selectedIndex else { return .normal }
        if picked == optionIndex {
            return correctSet.contains(optionIndex) ? .selectedCorrect : .selectedWrong
        } else if !correctSet.contains(picked) && correctSet.contains(optionIndex) {
            return .correctReveal
        } else {
            return .normal
        }
    }
}

// MARK: - Option Row (có thêm trạng thái pendingSelected/vàng)
struct OptionRow: View {
    enum State: Equatable { case normal, pendingSelected, selectedCorrect, selectedWrong, correctReveal }

    let index: Int
    let text: String
    let state: State
    var isEnabled: Bool = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: iconName)
                    .imageScale(.large)
                    .font(.system(size: 22, weight: .regular))
                    .foregroundColor(iconColor)
                    .padding(.top, 2)

                Text("\(index). \(text)")
                    .font(.system(size: 20, weight: .regular))
                    .foregroundColor(textColor)
                    .multilineTextAlignment(.leading)

                Spacer(minLength: 0)
            }
            .padding(14)
            .background(backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(borderColor, lineWidth: 2)
            )
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(index). \(text)")
    }

    // MARK: Style mapping
    private var iconName: String {
        switch state {
        case .normal: return "circle"
        case .pendingSelected: return "circle"                // vẫn icon tròn, chỉ đổi vàng
        case .selectedCorrect: return "checkmark.circle.fill"
        case .selectedWrong: return "xmark.circle.fill"
        case .correctReveal: return "checkmark.circle"
        }
    }

    private var iconColor: Color {
        switch state {
        case .pendingSelected: return .yellow
        case .selectedCorrect, .correctReveal: return .green
        case .selectedWrong: return .red
        case .normal: return .secondary
        }
    }

    private var textColor: Color {
        switch state {
        case .selectedWrong: return .red
        case .selectedCorrect, .correctReveal: return .green
        case .pendingSelected: return .primary
        case .normal: return .primary
        }
    }

    private var borderColor: Color {
        switch state {
        case .pendingSelected: return .yellow
        case .selectedWrong: return .red
        case .selectedCorrect, .correctReveal: return .green
        case .normal: return Color.gray.opacity(0.35)
        }
    }

    private var backgroundColor: Color {
        switch state {
        case .pendingSelected: return Color.yellow.opacity(0.18)
        case .selectedWrong:   return Color.red.opacity(0.10)
        case .selectedCorrect: return Color.green.opacity(0.10)
        case .correctReveal:   return Color.green.opacity(0.06)
        case .normal:          return Color(.systemBackground)
        }
    }
}

// MARK: - Explanation Card
struct ExplanationCard: View {
    let title: String
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {

            VStack(alignment: .leading, spacing: 6) {
                Text(title).font(.system(size: 18, weight: .semibold))
                Text(text).font(.system(size: 18)).fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 0)
        }
        .padding(14)
        .background(Color.green.opacity(0.18))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
