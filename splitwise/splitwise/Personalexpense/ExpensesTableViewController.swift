//
//  ExpensesTableViewController.swift
//  splitwise
//
//  Created by Gokul Jayavel on 12/12/23.
//

import Foundation
import UIKit




class ExpensesTableViewController: UITableViewController {
    var expenses = [Expense]()

    override func viewDidLoad() {
        super.viewDidLoad()
       // self.tableView.reloadData()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ExpenseCell")
        fetchExpenses()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Fetch the latest data
        fetchExpenses()
        // Reload the table view
        tableView.reloadData()
    }

    // Fetch expenses from the backend
    func fetchExpenses() {
        
        
        
        var urls: String?
        
        if let flatid = retrieveData(forKey: "user-_id") as? String {
            // Update the label text
            urls = "http://localhost:5001/expense/personal/\(flatid)"
            
        }
        print(urls!)
        guard let url = URL(string: urls ?? "") else {
            // Handle invalid URL
            return
        }
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
                         let fetchedExpenses = json.compactMap(Expense.init)
                            
                         
                            print(fetchedExpenses)
                            DispatchQueue.main.async {
                                self?.expenses = fetchedExpenses
                                self?.tableView.reloadData()
                            }
                        }
                    } catch {
                        print("Error parsing JSON: \(error)")
                    }
                }
                task.resume()
        
    }

    // Table View Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseCell", for: indexPath)
        cell.textLabel?.text = expenses[indexPath.row].description
        return cell
    }

    // Handling selection
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let expense = expenses[indexPath.row]
        performSegue(withIdentifier: "showDetail", sender: expense)
    }

    // Prepare for segue to pass data to the next view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail", let destinationVC = segue.destination as? PersonalExpenseViewController, let expense = sender as? Expense {
            destinationVC.expense = expense
        }
    }
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "YourSegueIdentifier", let destinationVC = segue.destination as? Addexpense {
//            destinationVC.delegate = self
//        }
//    }
    
    
    func retrieveData(forKey key: String) -> Any? {
        let defaults = UserDefaults.standard
        return defaults.object(forKey: key)
    }
}
