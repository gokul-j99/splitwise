//
//  User.swift
//  splitwise
//
//  Created by Gokul Jayavel on 12/5/23.
//

import Foundation
struct User {
    let id: String
    let firstName: String
    let lastName: String
    let flatId: String
    let email: String
    let password: String // Note: Passwords should not be stored in plain text in a production app
    let targetSaving: Int
    let monthlyBudget: Int
    let verified: Bool
}

extension User {
    init?(json: [String: Any]) {
        guard
            let id = json["_id"] as? String,
            let firstName = json["firstName"] as? String,
            let lastName = json["lastName"] as? String,
            let flatId = json["flatId"] as? String,
            let email = json["email"] as? String,
            let password = json["password"] as? String,
            let targetSaving = json["target_saving"] as? Int,
            let monthlyBudget = json["monthly_budget"] as? Int,
            let verified = json["verified"] as? Bool
        else {
            return nil
        }

        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.flatId = flatId
        self.email = email
        self.password = password
        self.targetSaving = targetSaving
        self.monthlyBudget = monthlyBudget
        self.verified = verified
    }
}
