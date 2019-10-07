//
//  ChartBarCollectionViewCell.swift
//  
//
//  Created by Neil Smith on 26/08/2019.
//

import UIKit

final class ChartBarCollectionViewCell: UICollectionViewCell {
    
    
    // MARK: Interface
    
    /// The proportion of the cell height which is to be occupied by the bar.
    var yValue: Double = 0 {
        didSet {
            updateFrame()
        }
    }
    
    var color: UIColor = .clear {
        didSet {
            barView.backgroundColor = color
            backingBarView.backgroundColor = color
        }
    }
    
    var state: ChartView.CellState = .active(1) {
        didSet {
            switch state {
            case .active:
                barView.isHidden = false
                barView.frame = barViewFrame
            case .dimmed:
                barView.isHidden = true
            }
        }
    }
    
    func refreshBarFrame() {
        updateFrame()
    }
        
    
    // MARK: Overrides
    override var reuseIdentifier: String? {
        return ChartBarCollectionViewCell.reuseID
    }
    
    
    // MARK: Subviews
    private lazy var barView: UIView = {
        let v = makeRoundedView()
        v.backgroundColor = self.color
        return v
    }()
    
    private lazy var backingBarView: UIView = {
        let v = makeRoundedView()
        v.backgroundColor = self.color
        v.alpha = 0.2
        return v
    }()
    
//    private lazy var barMaskView: UIView = {
//        let v = makeRoundedView()
//        v.backgroundColor = .black
//        return v
//    }()
    
    
    private func makeRoundedView() -> UIView {
        let v = UIView()
        v.layer.cornerRadius = 2
        v.layer.masksToBounds = true
        v.layer.maskedCorners = [
            .layerMaxXMinYCorner,
            .layerMinXMinYCorner
        ]
        return v
    }
    
    // MARK: Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateFrame()
    }
    
    
    // MARK: Helpers
    private func setup() {
        self.backgroundColor = .clear
        self.addSubview(backingBarView)
        self.addSubview(barView)
//        barView.mask = barMaskView
    }

    private var backingBarViewFrame: CGRect {
        let y = self.bounds.height * CGFloat(yValue)
        return .init(x: 0, y: y, width: self.bounds.width, height: self.bounds.height - y)
    }
    
    private func updateFrame() {
        backingBarView.frame = backingBarViewFrame
//        barMaskView.frame = backingBarViewFrame
        barView.frame = barViewFrame
    }
    
    private var barViewFrame: CGRect {
        switch state {
        case .dimmed: return .zero
        case .active(let xValue):
            let x = backingBarViewFrame.minX
            let y = backingBarViewFrame.minY
            let width = self.bounds.width * CGFloat(xValue)
            let height = backingBarViewFrame.height
            return .init(x: x, y: y, width: width, height: height)
        }
    }
    
}


