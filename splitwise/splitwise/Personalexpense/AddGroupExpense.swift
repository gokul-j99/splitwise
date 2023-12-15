//
//  AddExpense.swift
//  splitwise
//
//  Created by Gokul Jayavel on 12/12/23.
//

import Foundation
import UIKit

class AddGroupexpense: UIViewController, UITextFieldDelegate, MultiSelectionDelegate {
    

    
    var userslist: [User] = []
    var allusers: [User] = []
    var selType = "Expense"
    var cattype = "Food"
    var recexp = false
    var paiduser: String = ""
    var recurringexp = "No"
    var recurringexparr = ["Yes", "No"]
    var cattypes = ["Food", "Rent", "Mobile", "Grocieries", "Travel"]
    var types = ["Income", "Expense"]
    var dateString: String = ""
    
    @IBOutlet weak var typeButton: UIButton!
    @IBOutlet weak var category: UIButton!
    @IBOutlet weak var recurr: UIButton!
    @IBOutlet weak var users: UIButton!
    @IBOutlet weak var paidby: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var destext: UITextField!
    @IBOutlet weak var refrence: UITextField!
    
    
    func didSelectItems(_ selectedItems: [User]) {
        print("Selected users: \(selectedItems)")
        self.userslist = selectedItems
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.allusers = self.loadUsers(forKey: "allusers") ?? []
        typeButton.showsMenuAsPrimaryAction = true
        typeButton.setTitle("Expense", for: .normal)
        category.showsMenuAsPrimaryAction = true
        category.setTitle("Food", for: .normal)
        recurr.showsMenuAsPrimaryAction = true
        recurr.setTitle("No", for: .normal)
        paidby.showsMenuAsPrimaryAction = true
        paidby.setTitle("paidby", for: .normal)
        
        typeButton.menu = getMenuTypes()
        category.menu = getCateMenuTypes()
        recurr.menu = getrecurMenuTypes()
        paidby.menu = getpaidbyMenuTypes()
    }
    
    
    @IBAction func userButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "usersegue", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "usersegue",
           let multiSelectionVC = segue.destination as? MultiSelectionTableViewController {
            multiSelectionVC.delegate = self
            multiSelectionVC.users = self.userslist
            // Pass any other necessary data to multiSelectionVC if needed
        }
    }

    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        
        
        print("inside add")
        
        guard let amount = amount.text, !amount.isEmpty else{
            showErrorAlert(message: "Amount should not be empty!")
            return
        }
        
        guard let amountdoub = Double(amount) else {
            showErrorAlert(message: "Amount should be an integer!")
            return
        }
        
        guard let desc = destext.text, !desc.isEmpty else{
            showErrorAlert(message: "Amount should not be empty!")
            return
        }
        
        guard let ref = refrence.text, !ref.isEmpty else{
            showErrorAlert(message: "Amount should not be empty!")
            return
        }
        
        if (recurringexp == "Yes"){
            recexp = true
        }
        else{
            recexp = false
        }
        
        var idlist: [String] = []
        
        if(self.userslist.isEmpty){
            showErrorAlert(message: "Users should not be empty!")
            return
        }
        
        
        for i in self.userslist{
            idlist.append(i.id)
        }
        var user_id = ""
 
        for u in allusers{
            if u.firstName == self.paiduser{
                user_id = u.id
            }
        }
        
        let jsonData: [String: Any] = [
                "amount": amountdoub,
                "type": "Group",
                "category": selType,
                "sub_category": cattype,
                "recurring_expense": recexp,
                "description": desc,
                "reference": ref,
                "users": idlist,
                "paidby": user_id,
                "date": dateString
            ]
        
        print(jsonData)
        
        sendPostRequest(with: jsonData)
        
    }
    
    func sendPostRequest(with jsonData: [String: Any]) {
        
        
        
        var urls: String?
        
        if let userid = retrieveData(forKey: "_id") as? String {
            // Update the label text
            urls = "http://localhost:5001/expense/\(userid)"
            
        }
        guard let url = URL(string: urls ?? "") else {
            // Handle invalid URL
            return
        }
        print(url)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
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
    
    func getpaidbyMenuTypes() -> UIMenu{
        var menuItems = [UIAction]()
            
        for type in allusers{
            let menuItem = UIAction(title: type.firstName,handler: {(_) in
                self.paiduser = type.firstName
                                self.paidby.setTitle(self.paiduser, for: .normal)
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
        let alert = UIAlertController(title: "Success", message: "Expense Added successful!", preferredStyle: .alert)
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
    

    func loadUsers(forKey key: String) -> [User]? {
        if let data = UserDefaults.standard.data(forKey: key) {
            let decoder = JSONDecoder()
            do {
                let users = try decoder.decode([User].self, from: data)
                return users
            } catch {
                print("Unable to Decode Array of Users (\(error))")
            }
        }
        return nil
    }


}
