//
//  ViewController.swift
//  PhoneFormat
//
//  Created by ANDREY VORONTSOV on 11.11.2020.
//

import UIKit

class ViewController: UIViewController {
    
    private let maxNumberCount = 11
    private let regex = try! NSRegularExpression(pattern: "[\\+\\s-\\(\\)]", options: .caseInsensitive)
    
    private lazy var phoneTextField: PhoneTextField = {
        let textField = PhoneTextField()
        textField.autocorrectionType = .no
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    private lazy var phoneLabel: UILabel = {
        let label = UILabel()
        label.text = "Phone number"
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureUI()
    }

    private func configureUI() {
        view.addSubview(phoneLabel)
        view.addSubview(phoneTextField)
        
        let padding: CGFloat = 16
        
        NSLayoutConstraint.activate([
            phoneLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            phoneLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            phoneLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            phoneLabel.heightAnchor.constraint(equalToConstant: 20),
            
            phoneTextField.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 8),
            phoneTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            phoneTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            phoneTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        phoneTextField.delegate = self
        phoneTextField.keyboardType = .numberPad
    }
    
    private func format(phoneNumber: String, shouldRemoveLastDigit: Bool) -> String {
        guard !(shouldRemoveLastDigit && phoneNumber.count <= 2) else { return "+" }
        
        let range = NSString(string: phoneNumber).range(of: phoneNumber)
        var number = regex.stringByReplacingMatches(in: phoneNumber, options: [], range: range, withTemplate: "")
        
        if number.count > maxNumberCount {
            let maxIndex = number.index(number.startIndex, offsetBy: maxNumberCount)
            number = String(number[number.startIndex..<maxIndex])
        }
        
        if shouldRemoveLastDigit {
            let maxIndex = number.index(number.startIndex, offsetBy: number.count - 1)
            number = String(number[number.startIndex..<maxIndex])
        }
        
        let maxIndex = number.index(number.startIndex, offsetBy: number.count)
        let regRange = number.startIndex..<maxIndex
        
        if number.count < 7 {
            let pattern = "(\\d)(\\d{3})(\\d+)"
            number = number.replacingOccurrences(of: pattern, with: "$1 ($2) $3", options: .regularExpression, range: regRange)
        } else {
            let pattern = "(\\d)(\\d{3})(\\d{3})(\\d{2})(\\d+)"
            number = number.replacingOccurrences(of: pattern, with: "$1 ($2) $3-$4-$5", options: .regularExpression, range: regRange)
        }
        
        return "+" + number
    }

}

extension ViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
        if (string.rangeOfCharacter(from: invalidCharacters) == nil) {
            let mergedString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            textField.text = format(phoneNumber: mergedString, shouldRemoveLastDigit: range.length == 1)
        }
        return false
    }
    
}

