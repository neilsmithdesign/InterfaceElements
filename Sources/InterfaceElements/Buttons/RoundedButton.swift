//
//  RoundedButton.swift
//  
//
//  Created by Neil Smith on 26/08/2019.
//

import UIKit
import Extensions

public final class RoundedButton: UIButton {
    
    
    // MARK: Interface
    public var shape: Shape = .roundedRect(12.0) {
        didSet {
            didUpdateShape()
        }
    }
    
    public var style: Style = .filled(button: .label, text: .systemBackground) {
        didSet {
            didUpdateStyle()
        }
    }
    
    public var title: String = "" {
        didSet {
            self.setTitle(title, for: .normal)
        }
    }
    
    override public var isHighlighted: Bool {
        didSet {
            self.alpha = isHighlighted ? 0.5 : 1.0
        }
    }
    
    override public var isEnabled: Bool {
        didSet {
            self.alpha = isEnabled ? 1.0 : 0.2
        }
    }
    
    public func setLoading() {
        isLoading = true
        loadingContainerView.frame = self.bounds
        self.addSubview(loadingContainerView)
        self.bringSubviewToFront(loadingContainerView)
        self.setTitle(nil, for: .normal)
        configureLoadingIndicator()
    }
    
    public func stopLoading() {
        isLoading = false
        self.setTitle(title, for: .normal)
        loadingContainerView.subviews.forEach { $0.removeFromSuperview() }
        loadingContainerView.removeFromSuperview()
    }
    
    public private (set) var isLoading: Bool = false
    
    
    // MARK: Subviews
    private var loadingContainerView: UIView = {
        let v = UIView()
        return v
    }()

    private func configureLoadingIndicator() {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.color = self.style.textColor
        spinner.translatesAutoresizingMaskIntoConstraints = false
        loadingContainerView.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
    }
    
    
    // MARK: Life cycle
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = cornerRadius(for: shape)
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        didUpdateStyle()
    }
    
    private func setup() {
        self.setTitle(title, for: .normal)
        self.layer.masksToBounds = true
        self.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        self.didUpdateShape()
        self.didUpdateStyle()
    }
    
}

// MARK: - Supporting types
public extension RoundedButton {
    
    enum Shape {
        case roundedRect(CGFloat)
        case pill
    }
    
    enum Style {
        
        case filled(button: UIColor, text: UIColor)
        case outlined(UIColor)
        
        var textColor: UIColor {
            switch self {
            case .filled(_, let color): return color
            case .outlined(let color): return color
            }
        }

        var buttonColor: UIColor? {
            switch self {
            case .filled(let color, _): return color
            case .outlined: return nil
            }
        }
        
        var backgroundImage: UIImage? {
            guard let color = buttonColor else { return nil }
            return UIImage.with(color: color)
        }
        
        var borderColor: CGColor? {
            switch self {
            case .filled: return nil
            case .outlined(let color): return color.cgColor
            }
        }
        
        var borderWidth: CGFloat {
            switch self {
            case .filled: return 0.0
            case .outlined: return 2.0
            }
        }
        
    }
    
}


// MARK: - Helpers
private extension RoundedButton {
    
    
    // MARK: Shape change
    func didUpdateShape() {
        layoutIfNeeded()
    }
    
    func cornerRadius(for shape: Shape) -> CGFloat {
        switch shape {
        case .pill: return self.bounds.height / 2
        case .roundedRect(let r): return r
        }
    }
    
    // MARK: Style change
    func didUpdateStyle() {
        self.setTitleColor(style.textColor, for: .normal)
        self.setBackgroundImage(style.backgroundImage, for: .normal)
        self.layer.borderColor = style.borderColor
        self.layer.borderWidth = style.borderWidth
        self.layer.cornerCurve = .continuous
    }
    
}
