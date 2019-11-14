//
//  File.swift
//  
//
//  Created by Neil Smith on 06/09/2019.
//

import UIKit

public final class CircleButton: UIControl {
    
    
    // MARK: Interface
    public init(dimension: CGFloat = 0,
                origin: CGPoint = .zero,
                iconImage: UIImage? = nil,
                color: UIColor = .label,
                borderWidth: CGFloat = 1.0) {
        let frame = CGRect(origin: origin, size: CGSize(width: dimension, height: dimension))
        super.init(frame: frame)
        self.iconImage = iconImage
        self.color = color
        self.borderWidth = borderWidth
        setup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    
    public var iconImage: UIImage? {
        didSet {
            guard let image = iconImage else { return }
            self.iconImageView.image = image
        }
    }
    
    public var color: UIColor = .label {
        didSet {
            setColors()
        }
    }
    
    public var borderWidth: CGFloat = 1.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    public override var isHighlighted: Bool {
        didSet {
            self.alpha = isHighlighted ? 0.5 : 1.0
        }
    }
    
    
    // MARK: Subviews
    private lazy var iconImageView: UIImageView = {
        let iv = UIImageView(image: self.iconImage)
        iv.contentMode = .center
        iv.tintColor = self.color
        return iv
    }()
    
    
    // MARK: Life cycle
    public override func layoutSubviews() {
        super.layoutSubviews()
        iconImageView.frame = iconImageViewFrame
        self.layer.cornerRadius = self.bounds.height / 2
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.layer.borderColor = color.cgColor
    }
    
    
    // MARK: Helpers
    private func setup() {
        self.layer.borderWidth = borderWidth
        self.addSubview(iconImageView)
        setColors()
    }
    
    private func setColors() {
        self.backgroundColor = color.withAlphaComponent(0.2)
        self.iconImageView.tintColor = color
        self.layer.borderColor = color.cgColor
    }
    
    private var iconImageViewFrame: CGRect {
        let inset = self.bounds.width / 4
        return self.bounds.inset(by: .init(top: inset, left: inset, bottom: inset, right: inset))
    }
    
}

