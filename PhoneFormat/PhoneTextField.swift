//
//  PhoneTextField.swift
//  PhoneFormat
//
//  Created by ANDREY VORONTSOV on 12.11.2020.
//

import UIKit

class PhoneTextField: UITextField {

    private let textPadding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8);
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
    private func configure() {
        layer.cornerRadius = 8
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray4.cgColor
        textColor = .label
        tintColor = .label
        font = UIFont.preferredFont(forTextStyle: .title2)
        adjustsFontSizeToFitWidth = true
        backgroundColor = .tertiarySystemBackground
        translatesAutoresizingMaskIntoConstraints = false
    }

}
