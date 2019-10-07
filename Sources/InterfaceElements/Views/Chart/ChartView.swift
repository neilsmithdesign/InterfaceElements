//
//  ChartView.swift
//  
//
//  Created by Neil Smith on 26/08/2019.
//

import UIKit
import Extensions

public final class ChartView: UIView {
    
    
    // MARK: Interface
    public weak var dataSource: ChartViewDataSource?
    
    public weak var delegate: ChartViewDelegate?
    
    public var mode: Mode = .interactive {
        didSet {
            collectionView.reloadData()
            configureGestures()
        }
    }
    
    public func update(cellAt index: Int, state: CellState) {
        guard let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? ChartBarCollectionViewCell else { return }
        cell.state = state
    }
    
    public func reload() {
        collectionView.reloadData()
    }
    
    public func invalidateLayout() {
        collectionView.collectionViewLayout.invalidateLayout()
        for cell in collectionView.visibleCells {
            guard let c = cell as? ChartBarCollectionViewCell else { continue }
            c.refreshBarFrame()
        }
    }
    
    
    // MARK: Public types
    public enum Mode {
        case interactive
        case progress
    }
    
    public enum CellState {
        case active(Double)
        case dimmed
    }


    // MARK: Private
    private var bars: [ChartBar] {
        return dataSource?.bars(for: self) ?? []
    }
    
    
    // MARK: Subviews
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(ChartBarCollectionViewCell.self, forCellWithReuseIdentifier: ChartBarCollectionViewCell.reuseID)
        cv.dataSource = self
        cv.delegate = self
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.isScrollEnabled = false
        cv.backgroundColor = .clear
        return cv
    }()
    
    
    private lazy var panGesture: UIPanGestureRecognizer = {
        let g = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        g.delegate = self
        return g
    }()
    
    private lazy var tapGesture: UILongPressGestureRecognizer = {
        let g = UILongPressGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        g.minimumPressDuration = 0.05
        g.delegate = self
        return g
    }()
    
    private var currentlyActiveIndexPath: IndexPath? {
        didSet {
            delegate?.chartView(self, didUpdateCurrentlyActiveBarAt: currentlyActiveIndexPath)
        }
    }
    

    // MARK: Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        buildViewHierarchy()
        configureGestures()
    }
    
    private func buildViewHierarchy() {
        constrain(collectionView, to: self)
    }
    
    private func configureGestures() {
        if mode == .interactive {
            collectionView.addGestureRecognizer(panGesture)
            collectionView.addGestureRecognizer(tapGesture)
        } else {
            collectionView.removeGestureRecognizer(panGesture)
            collectionView.removeGestureRecognizer(tapGesture)
        }
    }

}


// MARK: - DataSource
extension ChartView: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bars.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChartBarCollectionViewCell.reuseID, for: indexPath) as! ChartBarCollectionViewCell
        let bar = bars[indexPath.item]
        cell.yValue = normalizedY(for: bar)
        cell.color = bar.color
        if mode == .progress, let state = dataSource?.state(forBarAt: indexPath.item) {
            cell.state = state
        }
        return cell
    }
    
}


// MARK: - Delegate
extension ChartView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bar = bars[indexPath.item]
        return .init(width: self.width(for: bar), height: collectionView.bounds.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    
    // MARK: Layout helpers
    private var availableWidth: CGFloat {
        let allSpacing = spacing * CGFloat(bars.count - 1)
        return collectionView.bounds.width - allSpacing
    }
    
    private func width(for bar: ChartBar) -> CGFloat {
        let totalWidth = availableWidth
        let totalBarsWidth = CGFloat(self.bars.totalX)
        let scalingFactor = totalBarsWidth / totalWidth
        return CGFloat(bar.x) / scalingFactor
    }
    
    private var maxY: Double {
        return bars.maxY?.y ?? 0
    }
    
    private func normalizedY(for bar: ChartBar) -> Double {
        guard self.maxY > 0 else { return 0 }
        return 1 - (bar.y / maxY)
    }

    private var spacing: CGFloat {
        return 1
    }
    
}

// MARK: - Interactive mode
extension ChartView: UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc private func handleTap(_ gesture: UILongPressGestureRecognizer) {
        guard let indexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else { return }
        switch gesture.state {
        case .began: didBeginGesture(at: indexPath)
        case .cancelled, .failed, .ended: didEndGesture(at: indexPath)
        default: return
        }
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let indexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else { return }
        switch gesture.state {
        case .began: didBeginGesture(at: indexPath)
        case .changed: didPan(at: indexPath)
        case .cancelled, .failed, .ended: didEndGesture(at: indexPath)
        default: return
        }
    }
    
    private func didBeginGesture(at indexPath: IndexPath) {
        currentlyActiveIndexPath = indexPath
        setAllCells(.dimmed)
        set(cellAt: indexPath, state: .active(1))
    }
    
    private func didPan(at indexPath: IndexPath) {
        guard indexPath != currentlyActiveIndexPath else { return }
        currentlyActiveIndexPath = indexPath
        setAllCells(.dimmed)
        set(cellAt: indexPath, state: .active(1))
    }
    
    private func didEndGesture(at indexPath: IndexPath) {
        currentlyActiveIndexPath = nil
        setAllCells(.active(1))
    }
    
    private func setAllCells(_ state: CellState) {
        for cell in collectionView.visibleCells {
            guard let cell = cell as? ChartBarCollectionViewCell else { continue }
            cell.state = state
        }
    }
    
    private func set(cellAt indexPath: IndexPath, state: CellState) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ChartBarCollectionViewCell else { return }
        cell.state = state
    }
    
}
