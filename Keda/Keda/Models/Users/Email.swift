//
//  Email.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import Foundation

struct EmailModel: Codable {
    let email: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case email, password
    }
}

class Email {
    
    private let emailModel: EmailModel
    
    init(emailModel: EmailModel) {
        self.emailModel = emailModel
    }
    
    var email: String { emailModel.email }
    var password: String { emailModel.password }
}

extension Email: Equatable {}
func ==(lhs: Email, rhs: Email) -> Bool {
    return lhs.email == rhs.email
}
