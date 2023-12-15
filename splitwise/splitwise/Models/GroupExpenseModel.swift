//
//  Expense.swift
//  splitwise
//
//  Created by Gokul Jayavel on 12/12/23.
//
import Foundation

struct GroupExpense {
    let id: String
    let date: Date
    let subCategory: String
    let category: String
    let amount: Double
    let currency: String
    let description: String
    let sharedAmount: Double
    let recurringExpense: Bool
    let reference: String
    let paidBy: String
    let flatId: String
    let userIds: [String]
    let createdAt: String
    let updatedAt: String
    let version: Int
    let mates: [String]
    let type: String
    let share: String

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
            let sharedAmount = json["shared_amount"] as? Double,
            let recurringExpense = json["recurring_expense"] as? Bool,
            let reference = json["reference"] as? String,
            let paidBy = json["paidby"] as? String,
            let flatId = json["flat_id"] as? String,
            let userIds = json["user_id"] as? [String],
            let createdAtString = json["createdAt"] as? String,
           // let createdAt = dateFormatter.date(from: createdAtString),
            let updatedAtString = json["updatedAt"] as? String,
           // let updatedAt = dateFormatter.date(from: updatedAtString),
            let version = json["__v"] as? Int,
            let mates = json["mates"] as? [String],
            let type = json["type"] as? String,
            let share = json["share"] as? String
        else {
            return nil
        }

        self.id = id
        self.date = date
        self.subCategory = subCategory
        self.category = category
        self.amount = amount
        self.currency = currency
        self.description = description
        self.sharedAmount = sharedAmount
        self.recurringExpense = recurringExpense
        self.reference = reference
        self.paidBy = paidBy
        self.flatId = flatId
        self.userIds = userIds
        self.createdAt = createdAtString
        self.updatedAt = updatedAtString
        self.version = version
        self.mates = mates
        self.type = type
        self.share = share
    }
}

