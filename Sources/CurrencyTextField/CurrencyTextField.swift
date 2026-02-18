//
//  CurrencyTextField.swift
//  ControleFinanceiro
//
//  Created by José Rafael Ferraz Pacheco on 19/10/25.
//

import SwiftUI

public struct CurrencyTextField: UIViewRepresentable {
    public typealias UIViewType = CurrencyUITextField
    
    let numberFormatter: NumberFormatter
    let currencyField: CurrencyUITextField
    
    public init(numberFormatter: NumberFormatter, value: Binding<Double?>, placeholder: String? = nil) {
        self.numberFormatter = numberFormatter
        currencyField = CurrencyUITextField(value: value, formatter: numberFormatter, placeholder: placeholder)
    }
    
    public func makeUIView(context: Context) -> CurrencyUITextField {
        return currencyField
    }
    
    public func updateUIView(_ uiView: CurrencyUITextField, context: Context) {}
}
