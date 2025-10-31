//
//  QuestionViewViewController.swift
//  Fsocial
//
//  Created by Huy Tran on 31/10/25.
//  Copyright (c) 2025 huyduc.dev. All rights reserved.


import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SwiftUI

// MARK: - Main View Controller
final class QuestionViewViewController: BaseViewController<QuestionViewViewModel> {
    // Data
    
    override var setting: NavigationSetting {
        defaultNav("Ôn tập 600 câu hỏi")
    }
    
    private var items: [QAItem] = []
    /// questionNumber -> selected option index
    private var selections: [Int: Int] = [:]
    
    // UI
    private let tabStrip = TabStripView()
    private var collectionView: UICollectionView!
    private let bottomBar = UIView()
    private let prevButton = UIButton(type: .system)
    private let bookButton = UIButton(type: .system)
    private let noteButton = UIButton(type: .system)
    private let nextButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        items = QALoader.loadFromBundle()
        setupTabStrip(); setupCollectionView(); setupBottomBar(); reloadUI()
    }
    
    private func setupTabStrip() {
        tabStrip.translatesAutoresizingMaskIntoConstraints = false
        tabStrip.delegate = self
        view.addSubview(tabStrip)
        NSLayoutConstraint.activate([
            tabStrip.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tabStrip.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabStrip.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabStrip.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(QuestionCell.self, forCellWithReuseIdentifier: QuestionCell.reuseID)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.decelerationRate = .fast
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: tabStrip.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60)
        ])
    }
    
    private func setupBottomBar() {
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        bottomBar.backgroundColor = .systemBlue
        view.addSubview(bottomBar)
        
        prevButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        nextButton.setImage(UIImage(systemName: "chevron.forward"), for: .normal)
        bookButton.setImage(UIImage(systemName: "book"), for: .normal)
        noteButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        [prevButton, bookButton, noteButton, nextButton].forEach { $0.tintColor = .white }
        
        let stack = UIStackView(arrangedSubviews: [prevButton, UIView(), bookButton, noteButton, UIView(), nextButton])
        stack.axis = .horizontal; stack.alignment = .center; stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        bottomBar.addSubview(stack)
        
        NSLayoutConstraint.activate([
            bottomBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomBar.heightAnchor.constraint(equalToConstant: 60),
            stack.leadingAnchor.constraint(equalTo: bottomBar.leadingAnchor, constant: 8),
            stack.trailingAnchor.constraint(equalTo: bottomBar.trailingAnchor, constant: -8),
            stack.topAnchor.constraint(equalTo: bottomBar.topAnchor, constant: 8),
            stack.bottomAnchor.constraint(equalTo: bottomBar.bottomAnchor, constant: -8)
        ])
        
        prevButton.addTarget(self, action: #selector(goPrev), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(goNext), for: .touchUpInside)
    }
    
    private func reloadUI() { tabStrip.configure(total: items.count, selected: 0); collectionView.reloadData() }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize = collectionView.bounds.size
    }
    
    private func scrollTo(index: Int, animated: Bool) {
        guard index >= 0, index < items.count else { return }
        collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: animated)
        tabStrip.select(index: index, animated: animated)
    }
    
    private func currentIndex() -> Int {
        let w = max(collectionView.bounds.width, 1)
        return max(0, min(items.count - 1, Int(round(collectionView.contentOffset.x / w))))
    }
    
    @objc private func goPrev() { scrollTo(index: currentIndex() - 1, animated: true) }
    @objc private func goNext() { scrollTo(index: currentIndex() + 1, animated: true) }
}

// MARK: - UICollectionView
extension QuestionViewViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { items.count }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: QuestionCell.reuseID, for: indexPath
        ) as! QuestionCell
        cell.parentViewController = self  // rất quan trọng cho iOS 13–15
        let item = items[indexPath.item]
        let selected = selections[item.number]
        cell.configure(.init(item: item, selectedIndex: selected))
        cell.onOptionSelected = { [weak self] idx in
            self?.selections[item.number] = idx
            collectionView.reloadItems(at: [indexPath])
        }
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) { guard scrollView === collectionView else { return }; tabStrip.select(index: currentIndex(), animated: true) }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) { guard scrollView === collectionView else { return }; tabStrip.select(index: currentIndex(), animated: true) }
}

// MARK: - TabStrip delegate
extension QuestionViewViewController: TabStripViewDelegate { func tabStrip(_ strip: TabStripView, didSelect index: Int) { scrollTo(index: index, animated: true) } }
