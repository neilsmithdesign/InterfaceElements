//
//  File.swift
//  
//
//  Created by Neil Smith on 06/09/2019.
//

import UIKit
import Extensions

public final class IncrementControl: NibView {
    
    
    // MARK: Interface
    public var viewModel: ViewModel? {
        didSet {
            guard let vm = viewModel else { return }
            minusButton?.color = vm.tint
            plusButton?.color = vm.tint
            self.text = vm.text
        }
    }
    
    public var text: String = "" {
        didSet {
            label?.text = text
        }
    }

    public var onSelection: ((Direction) -> Void)?
    
    
    // MARK: Outlets
    @IBOutlet private weak var minusButton: CircleButton! {
        didSet {
            configure(minusButton, for: .minus)
        }
    }
    
    @IBOutlet private weak var label: UILabel! {
        didSet {
            label.textColor = .label
            label.text = text
        }
    }
    
    @IBOutlet private weak var plusButton: CircleButton! {
        didSet {
            configure(plusButton, for: .plus)
        }
    }
    
    
    // MARK: Target-action
    @objc private func didSelect(_ button: CircleButton) {
        guard let direction = Direction(rawValue: button.tag) else { return }
        onSelection?(direction)
    }
    
}


// MARK: - Helpers
public extension IncrementControl {
    
    private func configure(_ button: CircleButton, for direction: Direction) {
        button.tag = direction.rawValue
        button.iconImage = direction.iconImage
        button.addTarget(self, action: #selector(didSelect(_:)), for: .touchUpInside)
        guard let vm = viewModel else { return }
        button.color = vm.tint
    }
    
    
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
    }
    
}

