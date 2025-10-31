//
//  Untitled.swift
//  Fsocial
//
//  Created by Huy Tran on 31/10/25.
//

import UIKit


protocol TabStripViewDelegate: AnyObject { func tabStrip(_ strip: TabStripView, didSelect index: Int) }
final class TabStripView: UIView {
    weak var delegate: TabStripViewDelegate?
    private let scroll = UIScrollView()
    private let stack = UIStackView()
    private var buttons: [UIButton] = []
    private var selectedIndex: Int = 0

    override init(frame: CGRect) { super.init(frame: frame); setup() }
    required init?(coder: NSCoder) { super.init(coder: coder); setup() }

    private func setup() {
        backgroundColor = .systemBackground
        scroll.showsHorizontalScrollIndicator = false
        scroll.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scroll)

        stack.axis = .horizontal
        stack.spacing = 24
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        scroll.addSubview(stack)

        NSLayoutConstraint.activate([
            // khung hiển thị
            scroll.topAnchor.constraint(equalTo: topAnchor),
            scroll.leadingAnchor.constraint(equalTo: leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: bottomAnchor),

            // >>> nội dung ràng buộc vào contentLayoutGuide (THAY CHO scroll.*)
            stack.leadingAnchor.constraint(equalTo: scroll.contentLayoutGuide.leadingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: scroll.contentLayoutGuide.trailingAnchor, constant: -12),
            stack.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor),
            stack.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor),

            // chiều cao nội dung khớp chiều cao khung
            stack.heightAnchor.constraint(equalTo: scroll.frameLayoutGuide.heightAnchor)
        ])
    }

    func configure(total: Int, selected: Int) {
        buttons.forEach { $0.removeFromSuperview() }
        buttons.removeAll()

        for i in 0..<total {
            let btn = UIButton(type: .system)
            btn.setTitle("Câu \(i+1)", for: .normal)
            btn.titleLabel?.font = .systemFont(ofSize: 20, weight: (i == selected ? .semibold : .regular))
            btn.setTitleColor(i == selected ? .systemBlue : .label, for: .normal)
            btn.tag = i
            btn.addTarget(self, action: #selector(tapTab(_:)), for: .touchUpInside)
            buttons.append(btn)
            stack.addArrangedSubview(btn)
        }

        layoutIfNeeded()
        scroll.setNeedsLayout()
        scroll.layoutIfNeeded()

        selectedIndex = min(max(0, selected), max(0, total - 1))

        // Đợi 1 nhịp runloop để Auto Layout hoàn tất -> rồi center
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.updateFontsColors(for: self.selectedIndex)
            self.centerButton(at: self.selectedIndex, animated: false)
        }
    }

    @objc private func tapTab(_ sender: UIButton) {
        select(index: sender.tag, animated: true)
        delegate?.tabStrip(self, didSelect: sender.tag)
    }

    func select(index: Int, animated: Bool) {
        guard index >= 0, index < buttons.count else { return }
        selectedIndex = index
        updateFontsColors(for: index)
        centerButton(at: index, animated: animated)
    }

    private func updateFontsColors(for index: Int) {
        for (i, btn) in buttons.enumerated() {
            btn.titleLabel?.font = .systemFont(ofSize: 20, weight: (i == index ? .semibold : .regular))
            btn.setTitleColor(i == index ? .systemBlue : .label, for: .normal)
        }
    }

    /// Cuộn để button được chọn nằm giữa scroll
    private func centerButton(at index: Int, animated: Bool) {
        guard index >= 0, index < buttons.count else { return }

        layoutIfNeeded()
        scroll.layoutIfNeeded()

        // Nếu nội dung nhỏ hơn khung ⇒ không cần cuộn
        let contentW = scroll.contentSize.width
        let boundsW  = scroll.bounds.width
        guard contentW > boundsW else {
            scroll.setContentOffset(.zero, animated: animated)
            return
        }

        let btn = buttons[index]
        let centerInScroll = scroll.convert(btn.center, from: btn.superview)
        var targetX = centerInScroll.x - boundsW / 2
        targetX = max(0, min(targetX, contentW - boundsW)) // clamp
        scroll.setContentOffset(CGPoint(x: targetX, y: 0), animated: animated)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // Giữ nút đang chọn ở giữa khi frame thay đổi (xoay màn hình, SplitView...)
        centerButton(at: selectedIndex, animated: false)
    }
}
