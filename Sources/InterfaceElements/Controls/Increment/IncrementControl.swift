//
//  File.swift
//  
//
//  Created by Neil Smith on 06/09/2019.
//

import UIKit
import Extensions

public final class IncrementControl: UIView {
    
    
    // MARK: Interface
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    public var viewModel: ViewModel? {
        didSet {
            guard let vm = viewModel else { return }
            minusButton.color = vm.tint
            plusButton.color = vm.tint
            self.text = vm.text
        }
    }
    
    public var text: String = "" {
        didSet {
            label.text = text
        }
    }

    public var onSelection: ((Direction) -> Void)?
    
    
    // MARK: Subviews
    private lazy var minusButton: CircleButton = self.configured(for: .minus)
    
    private lazy var plusButton: CircleButton = self.configured(for: .plus)
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .label
        label.text = text
        label.textAlignment = .center
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let sv = UIStackView(
            arrangedSubviews: [
                self.minusButton,
                self.label,
                self.plusButton
            ]
        )
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.alignment = .center
        sv.distribution = .fill
        sv.spacing = 8
        return sv
    }()
    
    
    private func setup() {
        constrain(stackView, to: self)
        constrainButton(minusButton)
        label.widthAnchor.constraint(equalToConstant: 64.0).isActive = true
        constrainButton(plusButton)
    }
    
    private func configured(for direction: Direction) -> CircleButton {
        let button = CircleButton(
            dimension: 32.0,
            iconImage: direction.iconImage,
            color: self.viewModel?.tint ?? .label
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = direction.rawValue
        button.addTarget(self, action: #selector(didSelect(_:)), for: .touchUpInside)
        return button
    }
    
    private func constrainButton(_ button: CircleButton) {
        button.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
        button.heightAnchor.constraint(equalTo: button.widthAnchor, multiplier: 1).isActive = true
    }
    
}


// MARK: - Target-action
extension IncrementControl {
    
    @objc private func didSelect(_ button: CircleButton) {
        guard let direction = Direction(rawValue: button.tag) else { return }
        onSelection?(direction)
    }
    
}


// MARK: - Supporting types
public extension IncrementControl {
    
    enum Direction: Int {
        case minus = 0
        case plus
        var iconImage: UIImage? {
            switch self {
            case .minus: return UIImage(systemName: "minus")
            case .plus: return UIImage(systemName: "plus")
            }
        }
    }
    
    struct ViewModel {
        let text: String
        let tint: UIColor
        public init(text: String, tint: UIColor) {
            self.text = text
            self.tint = tint
        }
    }
    
}

