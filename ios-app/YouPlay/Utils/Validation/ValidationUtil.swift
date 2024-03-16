//
//  ValidationUtil.swift
//  YouPlay
//
//  Created by Sebastian on 3/15/24.
//

import Foundation

enum ValidationUtil {
    static func isEmail(_ email: String) -> Bool {
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", EMAIL_REGEX)
        return emailPredicate.evaluate(with: email)
    }

    static func isValidPassword(_ password: String) -> Bool {
        return password.count >= MIN_PASSWORD_LENGTH
    }
}
