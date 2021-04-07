//
//  Formatter+Ext.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

extension Formatter {
    
    static let withCurrency: NumberFormatter = {
        var numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale.current
        //numberFormatter.groupingSeparator = "."
        numberFormatter.groupingSeparator = "," //Dollar
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        return numberFormatter
    }()
    
    static let withDecimal: NumberFormatter = {
        var numberFormatter = NumberFormatter()
        //numberFormatter.groupingSeparator = "."
        numberFormatter.groupingSeparator = "," //Dollar
        numberFormatter.numberStyle = .decimal
        return numberFormatter
    }()
}

extension Double {
    
    var formattedWithCurrency: String {
        guard let currency = Formatter.withCurrency.string(for: self) else { return "" }
        return "$" + currency
    }
    
    var formattedWithDecimal: String {
        return Formatter.withDecimal.string(for: self) ?? ""
    }
}
