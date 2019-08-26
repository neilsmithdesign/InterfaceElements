//
//  NavigationControl.swift
//  
//
//  Created by Neil Smith on 26/08/2019.
//

import UIKit
import Extensions

public final class NavigationControl: UIView {
    
    public weak var delegate: NavigationControlDelegate?
    
    public func refresh() {
        refresh(leftButton, position: .left)
        refresh(rightButton, position: .right)
    }
    
    private lazy var leftButton: RoundedButton = {
        let btn = RoundedButton(frame: .zero)
        btn.shape = .pill
        btn.style = .outlined(.label)
        btn.addTarget(self, action: #selector(didTapLeft), for: .touchUpInside)
        return btn
    }()
    
    private lazy var rightButton: RoundedButton = {
        let btn = RoundedButton(frame: .zero)
        btn.shape = .pill
        btn.style = .outlined(.label)
        btn.addTarget(self, action: #selector(didTapRight), for: .touchUpInside)
        return btn
    }()
    
    private lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [self.leftButton, self.rightButton])
        sv.spacing = 16
        sv.alignment = .fill
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.backgroundColor = .clear
        constrain(stackView, to: self)
        refresh()
    }
    
    
}


// MARK: - Target-action
extension NavigationControl {
    
    @objc private func didTapLeft() {
        delegate?.navigationControl(self, didTapButtonAt: .left)
        refresh()
    }
    
    @objc private func didTapRight() {
        delegate?.navigationControl(self, didTapButtonAt: .right)
        refresh()
    }
    
}


// MARK: - Helpers
extension NavigationControl {
    
    private func refresh(_ button: RoundedButton, position: ButtonPosition) {
        button.title = delegate?.navigationControl(self, titleForButtonAt: position) ?? ""
        if let state = delegate?.navigationControl(self, stateForButtonAt: position) {
            button.isHidden = false
            switch state {
            case .hidden: button.isHidden = true
            case .disabled: button.isEnabled = false
            case .enabled: button.isEnabled = true
            }
        }
    }
    
}

public extension NavigationControl {
    
    enum ButtonPosition: String {
        case left
        case right
    }
    
    enum ButtonState {
        case hidden
        case disabled
        case enabled
    }
    
}

