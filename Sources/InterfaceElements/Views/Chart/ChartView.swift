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
    public func update(with bars: [ChartBar]) {
        self.bars = bars
        self.collectionView.reloadData()
    }


    // MARK: Private
    private var bars: [ChartBar] = []
    
    
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


    // MARK: Init
    public init(bars: [ChartBar], frame: CGRect) {
        super.init(frame: frame)
        self.update(with: bars)
        setup()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        constrain(collectionView, to: self)
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
        cell.value = normalizedY(for: bar)
        cell.color = bar.color
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