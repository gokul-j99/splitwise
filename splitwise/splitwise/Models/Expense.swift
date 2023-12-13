//
//  Expense.swift
//  splitwise
//
//  Created by Gokul Jayavel on 12/12/23.
//

import Foundation
import Foundation

struct Expense {
    let id: String
    let date: Date
    let subCategory: String
    let category: String
    let amount: Double
    let currency: String
    let description: String
    let reference: String
    let recurringExpense: Bool
    let userId: String
    let createdAt: String
    let updatedAt: String
    let version: Int
    let type: String
}

extension Expense {
    init?(json: [String: Any]) {
        let dateFormatter = ISO8601DateFormatter()
        let simpleDateFormatter = DateFormatter()
        simpleDateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard
            let id = json["_id"] as? String,
            let dateString = json["date"] as? String,
            let date = simpleDateFormatter.date(from: dateString) ?? dateFormatter.date(from: dateString),
            let subCategory = json["sub_category"] as? String,
            let category = json["category"] as? String,
            let amount = json["amount"] as? Double,
            let currency = json["currency"] as? String,
            let description = json["description"] as? String,
            let reference = json["reference"] as? String,
            let recurringExpense = json["recurring_expense"] as? Bool,
            let userId = json["user_id"] as? String,
            let createdAtString = json["createdAt"] as? String,
           // let createdAt = dateFormatter.date(from: createdAtString),
            let updatedAtString = json["updatedAt"] as? String,
          //  let updatedAt = dateFormatter.date(from: updatedAtString),
            let version = json["__v"] as? Int,
            let type = json["type"] as? String
            
        else {
            print("Parsing error in Expense init")
                       return nil
        }

        self.id = id
        self.date = date
        self.subCategory = subCategory
        self.category = category
        self.amount = amount
        self.currency = currency
        self.description = description
        self.reference = reference
        self.recurringExpense = recurringExpense
        self.userId = userId
        self.createdAt = createdAtString
        self.updatedAt = updatedAtString
        self.version = version
        self.type = type
    }
}
