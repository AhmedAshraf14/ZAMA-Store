//
//  ValidationError.swift
//  ZAMAStore
//
//  Created by Ahmed Ashraf on 04/09/2024.
//

import Foundation

enum ValidationError: String {
    case invalidFirstName = "First name must be at least 4 characters long and contain only letters."
    case invalidLastName = "Last name must be at least 4 characters long and contain only letters."
    case invalidEmail = "Email address is not valid."
    case invalidPhone = "Phone number is not valid."
    case invalidPassword = "Password must be 6-15 characters long and include at least one digit, one letter, and one special character."
}
