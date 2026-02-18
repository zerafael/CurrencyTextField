//
//  CurrencyUITextField.swift
//  ControleFinanceiro
//
//  Created by José Rafael Ferraz Pacheco on 16/10/25.
//

import UIKit
import SwiftUI

public class CurrencyUITextField: UITextField {
    @Binding private var value: Double?
    private let formatter: NumberFormatter
    
    private var textValue: String? {
        return text
    }
    
    private var doubleValue: Double? {
        guard let decimal = decimal else {
            return nil
        }
        return (decimal as NSDecimalNumber).doubleValue
    }
    
    private var decimal: Decimal? {
        guard let decimal = textValue?.decimal else {
            return nil
        }

        return decimal / pow(10, formatter.maximumFractionDigits)
    }
    
    init(value: Binding<Double?>, formatter: NumberFormatter, placeholder: String? = nil) {
        self._value = value
        self.formatter = formatter
        super.init(frame: .zero)
        self.placeholder = placeholder
        setupViews()
        self.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func willMove(toSuperview newSuperview: UIView?) {
        addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        addTarget(self, action: #selector(resetSelection), for: .allTouchEvents)
        keyboardType = .numberPad

        if text == nil || text?.isEmpty == true, let initialValue = value {
            text = formatter.string(from: NSNumber(value: initialValue))
        }
        
        sendActions(for: .editingChanged)
    }
    
    public override func deleteBackward() {
        text = textValue?.digits.dropLast().string
        sendActions(for: .editingChanged)
    }
    
    private func setupViews() {
        font = .systemFont(ofSize: 16, weight: .regular)
    }
    
    @objc private func editingChanged() {
        if let currency = currency(from: decimal) {
            text = currency
        }
        
        resetSelection()
        value = doubleValue
    }
    
    @objc private func resetSelection() {
        selectedTextRange = textRange(from: endOfDocument, to: endOfDocument)
    }
    
    private func currency(from decimal: Decimal?) -> String? {
        guard let decimal else {
            return nil
        }
        return formatter.string(for: decimal)
    }
}

extension StringProtocol where Self: RangeReplaceableCollection {
    var digits: Self { filter (\.isWholeNumber) }
}

extension String {
    var decimal: Decimal? {
        Decimal(string: digits)
    }
}

extension LosslessStringConvertible {
    var string: String {
        .init(self)
    }
}

extension CurrencyUITextField: UITextFieldDelegate {
    public func textFieldDidChangeSelection(_ textField: UITextField) {
        resetSelection()
    }
}
