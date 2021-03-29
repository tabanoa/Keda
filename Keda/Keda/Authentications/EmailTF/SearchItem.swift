//
//  SearchItem.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class SearchItem {
    
    var attributedEmail: NSMutableAttributedString?
    var allAttributedEmail: NSMutableAttributedString?
    var email: String
    var password: String
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
    func getFormatterText() -> NSMutableAttributedString {
        allAttributedEmail = NSMutableAttributedString()
        allAttributedEmail!.append(attributedEmail!)
        return allAttributedEmail!
    }
    
    func getEmail() -> String {
        return "\(email)"
    }
}
