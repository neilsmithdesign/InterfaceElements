//
//  ChartBarCollectionViewCell.swift
//  
//
//  Created by Neil Smith on 26/08/2019.
//

import UIKit

final class ChartBarCollectionViewCell: UICollectionViewCell {
    
    
    // MARK: Interface
    var value: Double = 0 {
        didSet {
            updateFrame()
        }
    }
    
    var color: UIColor = .clear {
        didSet {
            barView.backgroundColor = color
        }
    }
    
    var state: ChartView.CellState = .active {
        didSet {
            barView.alpha = state == .active ? 1.0 : 0.2
        }
    }
        
    
    // MARK: Overrides
    override var reuseIdentifier: String? {
        return ChartBarCollectionViewCell.reuseID
    }
    
    
    // MARK: Subviews
    private lazy var barView: UIView = {
        let v = UIView()
        v.backgroundColor = self.color
        v.layer.cornerRadius = 2
        v.layer.maskedCorners = [
            .layerMaxXMinYCorner,
            .layerMinXMinYCorner
        ]
        return v
    }()
    

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
        barView.frame = barViewFrame
    }
    
    
    // MARK: Helpers
    private func setup() {
        self.backgroundColor = .clear
        self.addSubview(barView)
    }

    private var barViewFrame: CGRect {
        let y = self.bounds.height * CGFloat(value)
        return .init(x: 0, y: y, width: self.bounds.width, height: self.bounds.height - y)
    }
    
    private func updateFrame() {
        barView.frame = barViewFrame
    }
    
    
}


