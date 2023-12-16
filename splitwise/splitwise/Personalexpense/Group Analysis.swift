//
//  Group Analysis.swift
//  splitwise
//
//  Created by Gokul Jayavel on 12/15/23.
//

import Foundation
import UIKit

class GroupAnalysis: UIViewController, UITextFieldDelegate {
    

    var expenses = [GroupExpense]()
    var allusers: [User] = []
    
    @IBOutlet weak var category: UIButton!
    @IBOutlet weak var frequency: UIButton!
    @IBOutlet weak var sdatePicker: UIDatePicker!
    @IBOutlet weak var edatePicker: UIDatePicker!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var paidby: UIButton!
    var selType = "Last Week"
    var selval = "7"
    var cattype = "Food"
    var paiduser: String = ""
    var cattypes = ["Food", "Rent", "Miscellaneous", "Grocieries", "Travel"]
    var types = ["Last Week", "Last Month", "Last Year","Custom"]
    var startDateString: String = ""
    var endDateString: String = ""
    var datestring: String = ""
    var userid: String = "all"
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.allusers = self.loadUsers(forKey: "allusers") ?? []
        frequency.showsMenuAsPrimaryAction = true
        frequency.setTitle("Last Week", for: .normal)
        category.showsMenuAsPrimaryAction = true
        category.setTitle("Food", for: .normal)
        paidby.showsMenuAsPrimaryAction = true
        paidby.setTitle("paidby", for: .normal)
        
        category.menu = getMenuTypes()
        frequency.menu = getCateMenuTypes()
        paidby.menu = getpaidbyMenuTypes()
    }
    
    
    
    func getMenuTypes() -> UIMenu{
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
    
    func getCateMenuTypes() -> UIMenu{
        var menuItems = [UIAction]()
            
        for type in types{
            let menuItem = UIAction(title: type,handler: {(_) in
                                self.selType = type
                                self.frequency.setTitle(self.selType, for: .normal)
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
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        // Format the date as needed
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.startDateString = dateFormatter.string(from: selectedDate)

        print("Date picker value changed to: \(startDateString)")
    }
    
    @IBAction func enddatePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        // Format the date as needed
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.endDateString = dateFormatter.string(from: selectedDate)

        print("Date picker value changed to: \(endDateString)")
    }
    
    
    @IBAction func functionTaped(_ sender: UIButton) {
        
        if(self.selType == "Custom"){
            self.datestring = self.startDateString + "," + self.endDateString
            self.selval = "all"
        }
        
        else if(self.selType == "Last Week"){
            self.selval = "7"
        }
        else if(self.selType == "Last Month"){
            self.selval = "30"
        }
        else if(self.selType == "Last Year"){
            self.selval = "365"
        }
        
        for u in allusers{
            if u.firstName == self.paiduser{
                self.userid = u.id
            }
        }
        
        fetchExpenses()
    }
    
    
    
    func fetchExpenses() {
        
        
        
        var urls: String?
        
        if let flatid = retrieveData(forKey: "_id") as? String {
            // Update the label text
            urls = "http://localhost:5001/expense/group/\(flatid)"
            
        }
        
        var urlComponents = URLComponents(string: urls!)
        urlComponents?.queryItems = [
            URLQueryItem(name: "frequency", value: self.selval),
            URLQueryItem(name: "selectedRange", value: self.datestring),
            URLQueryItem(name: "category", value: self.cattype),
            URLQueryItem(name: "paidby", value: self.userid )
        ]
        print(urls!)
        guard let url = urlComponents?.url else {
             print("Invalid URL")
             return
         }
        print(url)
//        guard let url = URL(string: "http://localhost:5001/expense/personal/656bca53d1f30e46d7199acb") else {
//            print("Invalid URL")
//            return
//        }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                    guard let data = data, error == nil else {
                        print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                        return
                    }

                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                         let fetchedExpenses = json.compactMap(GroupExpense.init)
                            
                            var tot = 0.0
                            print(fetchedExpenses)
                            DispatchQueue.main.async {
                                self?.expenses = fetchedExpenses
                                for i in fetchedExpenses{
                                    tot = tot + i.amount
                                }
                                print(tot)
                                self?.totalAmount.text = "You Spent totally \(tot)"
                            }
                        }
                    } catch {
                        print("Error parsing JSON: \(error)")
                    }
                }
                task.resume()
        
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

    
    
    
    func showSuccessAlert() {
        let alert = UIAlertController(title: "Success", message: "Account Created successful!", preferredStyle: .alert)
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
