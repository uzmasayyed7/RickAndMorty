//
//  PickerTextField.swift
//  RickAndMorty
//
//  Created by Uzma Sayyed on 2/7/24.
//

import UIKit

class PickerTextField: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}
