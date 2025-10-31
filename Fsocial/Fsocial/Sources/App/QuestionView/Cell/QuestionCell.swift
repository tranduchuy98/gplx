//
//  File.swift
//  Fsocial
//
//  Created by Huy Tran on 31/10/25.
//

import Foundation
import SwiftUI


final class QuestionCell: UICollectionViewCell {
    static let reuseID = "QuestionCell"

    // iOS 13–15 fallback
    private var hostingController: UIHostingController<QuestionContentView>?
    weak var parentViewController: UIViewController?   // set từ VC chứa collectionView

    var onOptionSelected: ((Int) -> Void)?

    override init(frame: CGRect) { super.init(frame: frame); setup() }
    required init?(coder: NSCoder) { super.init(coder: coder); setup() }

    private func setup() {
        contentView.backgroundColor = .white
        contentView.clipsToBounds = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        onOptionSelected = nil

        // iOS 16+: clear configuration
        if #available(iOS 16.0, *) {
            contentConfiguration = nil
        } else {
            // iOS 13–15: remove hostingController view cleanly
            if let hc = hostingController {
                hc.willMove(toParent: nil)
                hc.view.removeFromSuperview()
                hc.removeFromParent()
                hostingController = nil
            }
        }
    }

    struct Config {
        let item: QAItem
        let selectedIndex: Int?
    }

    func configure(_ config: Config) {
        let view = QuestionContentView(item: config.item)

        if #available(iOS 16.0, *) {
            // Easiest way on iOS 16+
            contentConfiguration = UIHostingConfiguration {
                view
            }
            .margins(.all, 0)
        } else {
            // iOS 13–15: host manually
            if let hc = hostingController {
                hc.rootView = view
            } else {
                let hc = UIHostingController(rootView: view)
                hostingController = hc

                hc.view.backgroundColor = UIColor.clear
                hc.view.translatesAutoresizingMaskIntoConstraints = false
                contentView.addSubview(hc.view)
                NSLayoutConstraint.activate([
                    hc.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                    hc.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                    hc.view.topAnchor.constraint(equalTo: contentView.topAnchor),
                    hc.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
                ])

                // add as child to the parent VC
                if let parent = parentViewController {
                    parent.addChild(hc)
                    hc.didMove(toParent: parent)
                }
            }
        }
    }
}
