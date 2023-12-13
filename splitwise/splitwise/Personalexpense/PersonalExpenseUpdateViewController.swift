//
//  PersonalExpenseUpdateViewController.swift
//  splitwise
//
//  Created by Gokul Jayavel on 12/12/23.
//

import Foundation
import UIKit



class PersonalExpenseViewController: UIViewController{
    
    var expense: Expense?
    
    var selType = "Expense"
    var cattype = "Food"
    var recexp = false
    var recurringexp = "No"
    var recurringexparr = ["Yes", "No"]
    var cattypes = ["Food", "Rent", "Mobile", "Grocieries", "Travel"]
    var types = ["Income", "Expense"]
    var dateString: String = ""
    
    @IBOutlet weak var typeButton: UIButton!
    @IBOutlet weak var category: UIButton!
    @IBOutlet weak var recurr: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var destext: UITextField!
    @IBOutlet weak var refrence: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.typeButton.showsMenuAsPrimaryAction = true
        self.typeButton.setTitle("Expense", for: .normal)
        self.category.showsMenuAsPrimaryAction = true
        self.category.setTitle("Food", for: .normal)
        self.recurr.showsMenuAsPrimaryAction = true
        self.recurr.setTitle("No", for: .normal)
        
        self.typeButton.menu = getMenuTypes()
        self.category.menu = getCateMenuTypes()
        self.recurr.menu = getrecurMenuTypes()
        
        if let expense = self.expense {
                populateUIWithExpense(expense)
            }
    }
    
    
    func populateUIWithExpense(_ expense: Expense) {
        // Assuming you have a DateFormatter to format the date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        self.amount.text = String(expense.amount)
        self.destext.text = expense.description
        self.refrence.text = expense.reference
        self.typeButton.setTitle(expense.type, for: .normal)
        self.category.setTitle(expense.subCategory, for: .normal)
        self.recurr.setTitle(expense.recurringExpense ? "Yes" : "No", for: .normal)
        self.datePicker.date = expense.date
        
        self.selType = expense.category
        self.cattype = expense.subCategory
        self.recurringexp = expense.recurringExpense ? "Yes" : "No"
        self.dateString = dateFormatter.string(from: expense.date)
    }
    
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        
        print("Inside update")
        
        guard let amount = self.amount.text, !amount.isEmpty else{
            showErrorAlert(message: "Amount should not be empty!")
            return
        }
        
        guard let amountdoub = Double(amount) else {
            showErrorAlert(message: "Amount should be an integer!")
            return
        }
        
        guard let desc = self.destext.text, !desc.isEmpty else{
            showErrorAlert(message: "Amount should not be empty!")
            return
        }
        
        guard let ref = self.refrence.text, !ref.isEmpty else{
            showErrorAlert(message: "Amount should not be empty!")
            return
        }
        
        if (self.recurringexp == "Yes"){
            self.recexp = true
        }
        else{
            self.recexp = false
        }
        
        let jsonData: [String: Any] = [
                "amount": amountdoub,
                "type": "personal",
                "category": self.selType,
                "sub_category": self.cattype,
                "recurring_expense": self.recexp,
                "description": desc,
                "reference": ref,
                "date": self.dateString
            ]
        print(jsonData)
        
        self.sendPostRequest(with: jsonData)
        
    }
    
    func sendPostRequest(with jsonData: [String: Any]) {
        
        var urls: String?
        
        if let expense = self.expense {
            if let userid = expense.id as? String {
                // Update the label text
                urls = "http://localhost:5001/expense/personal/\(userid)"
                
            }
            }
        
  
        guard let url = URL(string: urls ?? "") else {
            // Handle invalid URL
            return
        }
        print(url)

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let data = try JSONSerialization.data(withJSONObject: jsonData, options: [])
            request.httpBody = data

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error sending request: \(error)")
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode) else {
                        print("Error with the response, unexpected status code: \(String(describing: response))")
                        
                        if let data = data,
                           let errorResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String],
                           let errorMessage = errorResponse["message"] {
                            self.showErrorAlert(message: errorMessage)
                        } else {
                            self.showErrorAlert(message: "An unexpected error occurred")
                        }
                        
                        return
                }
                
               // self.showSuccessAlert()
                DispatchQueue.main.async {
                    self.destext.text = ""
                    self.refrence.text = ""
                    self.amount.text = ""
                    self.typeButton.setTitle("Income", for: .normal)
                    self.category.setTitle("Food", for: .normal)
                    self.recurr.setTitle("No", for: .normal)
                    self.datePicker.date = Date()
                    self.navigationController?.popViewController(animated: true)
                }
                
                print("Data sent successfully.")
            }
            task.resume()
        } catch {
            print("Error serializing JSON: \(error)")
        }
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        
        var urls: String?
        
        if let expense = self.expense {
            if let userid = expense.id as? String {
                // Update the label text
                urls = "http://localhost:5001/expense/personal/\(userid)"
                
            }
            }
        
  
        guard let url = URL(string: urls ?? "") else {
            // Handle invalid URL
            return
        }
        print(url)

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        
        do {


            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error sending request: \(error)")
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode) else {
                        print("Error with the response, unexpected status code: \(String(describing: response))")
                        
                        if let data = data,
                           let errorResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String],
                           let errorMessage = errorResponse["message"] {
                            self.showErrorAlert(message: errorMessage)
                        } else {
                            self.showErrorAlert(message: "An unexpected error occurred")
                        }
                        
                        return
                }
                
               // self.showSuccessAlert()
                DispatchQueue.main.async {
                    self.destext.text = ""
                    self.refrence.text = ""
                    self.amount.text = ""
                    self.typeButton.setTitle("Income", for: .normal)
                    self.category.setTitle("Food", for: .normal)
                    self.recurr.setTitle("No", for: .normal)
                    self.datePicker.date = Date()
                    self.navigationController?.popViewController(animated: true)
                }
                
                print("Data sent successfully.")
            }
            task.resume()
        } catch {
            print("Error serializing JSON: \(error)")
        }
        
        
    }

    
    
    
    func getMenuTypes() -> UIMenu{
        var menuItems = [UIAction]()
            
        for type in types{
            let menuItem = UIAction(title: type,handler: {(_) in
                                self.selType = type
                                self.typeButton.setTitle(self.selType, for: .normal)
                                })
            menuItems.append(menuItem)
        }
            
        return UIMenu(title: "Select type", children: menuItems)
    }
    
    
    func getCateMenuTypes() -> UIMenu{
        var menuItems = [UIAction]()
            
        for type in cattypes{
            let menuItem = UIAction(title: type,handler: {(_) in
                                self.cattype = type
                                self.category.setTitle(self.cattype, for: .normal)
                                })
            menuItems.append(menuItem)
        }
            
        return UIMenu(title: "Select type", children: menuItems)
    }
    
    func getrecurMenuTypes() -> UIMenu{
        var menuItems = [UIAction]()
            
        for type in recurringexparr{
            let menuItem = UIAction(title: type,handler: {(_) in
                                self.recurringexp = type
                                self.recurr.setTitle(self.recurringexp, for: .normal)
                                })
            menuItems.append(menuItem)
        }
            
        return UIMenu(title: "Select type", children: menuItems)
    }
    
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        // Format the date as needed
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.dateString = dateFormatter.string(from: selectedDate)

        print("Date picker value changed to: \(dateString)")
    }
    
    func showSuccessAlert() {
        let alert = UIAlertController(title: "Success", message: "Expense Updated successful!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }

    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    func retrieveData(forKey key: String) -> Any? {
        let defaults = UserDefaults.standard
        return defaults.object(forKey: key)
    }
    


    
    
    
}
