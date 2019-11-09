//
//  FloatingActionButton.swift
//  
//
//  Created by Neil Smith on 09/11/2019.
//

import UIKit

public final class FloatingActionButton: UIControl {
    
    
    // MARK: Interface
    public func set(circleTint color: UIColor, for state: UIControl.State) {
        if state == .normal {
            self.circleTintColor = color
        } else if state == .highlighted {
            self.highlightedCircleTintColor = color
        }
        setColors(isHighlighted: isHighlighted)
    }
    
    public var plusImageTintColor: UIColor = .label {
        didSet {
            setColors(isHighlighted: isHighlighted)
        }
    }
    
    public private (set) var circleTintColor: UIColor = .secondarySystemBackground
    public private (set) var highlightedCircleTintColor: UIColor = .systemBackground
    
    
    // MARK: Subviews
    private lazy var plusImageView: UIImageView = {
        let image = UIImage(systemName: "plus")
        let iv = UIImageView(image: image)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = .label
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private lazy var circleView: UIView = {
        let v = UIView()
        v.isUserInteractionEnabled = false
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = self.circleTintColor
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowRadius = 8
        v.layer.shadowOpacity = 0.8
        v.layer.shadowOffset = .init(width: 0, height: 2)
        return v
    }()
    
    
    // MARK: Properties
    override public var isHighlighted: Bool {
        didSet {
            self.setColors(isHighlighted: isHighlighted)
        }
    }
    
    private var selectionFeedback: UISelectionFeedbackGenerator = .init()
    
    
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
        self.circleView.layer.cornerRadius = self.circleView.bounds.height / 2
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        selectionFeedback.selectionChanged()
        selectionFeedback.prepare()
    }
    
    
    // MARK: Helpers
    private func setup() {
        selectionFeedback.prepare()
        setColors(isHighlighted: isHighlighted)
        constrainCircleView()
        constrainImageView()
    }
    
    private func constrainCircleView() {
        self.addSubview(circleView)
        circleView.heightAnchor.constraint(equalToConstant: 64.0).isActive = true
        circleView.widthAnchor.constraint(equalToConstant: 64.0).isActive = true
        circleView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        circleView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    private func constrainImageView() {
        self.addSubview(plusImageView)
        plusImageView.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
        plusImageView.widthAnchor.constraint(equalToConstant: 32.0).isActive = true
        plusImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        plusImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }

    private func setColors(isHighlighted: Bool) {
        self.circleView.backgroundColor = isHighlighted ? highlightedCircleTintColor : circleTintColor
        self.plusImageView.alpha = isHighlighted ? 0.6 : 1.0
    }
    
}
