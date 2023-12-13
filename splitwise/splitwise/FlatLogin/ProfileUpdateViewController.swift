//
//  ProfileUpdateViewController.swift
//  splitwise
//
//  Created by Gokul Jayavel on 12/10/23.
//

import Foundation
import UIKit

class ProfileUpdateViewController: UIViewController {
    
    
    var users: User?
    
    // Text Fields
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var flatNameTextField: UILabel!
    @IBOutlet weak var targetSavingTextField: UITextField!
    @IBOutlet weak var monthlyBudgetTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetch user data and populate the text fields
        fetchUserProfile()
    }

    func fetchUserProfile() {
        // Replace with your API URL
       // let apiUrl = "http://localhost:5001/user/656bca53d1f30e46d7199acb"\\
//
//        let userDefaults = UserDefaults.standard
//
//        // Get the dictionary representation of all data in UserDefaults
//        let allUserDefaults = userDefaults.dictionaryRepresentation()
//
//        // Print each key-value pair
//        for (key, value) in allUserDefaults {
//            print("\(key) = \(value)")
//        }
//
        
        var urls: String?
        
        if let flatid = retrieveData(forKey: "user-_id") as? String {
            // Update the label text
            urls = "http://localhost:5001/user/\(flatid)"
            
        }
        
        guard let url = URL(string: urls ?? "") else {
            // Handle invalid URL
            return
        }
        
//        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
//            guard let self = self else { return }
//
//            if let error = error {
//                // Handle the error, e.g., show an alert to the user
//                print("Error fetching data: \(error)")
//                return
//            }
//
//            if let data = data {
//                do {
//                    // Parse the JSON response as a single user object
//                    if let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                        // Initialize a User object from the JSON dictionary
//                        if let user = User(json: jsonDictionary) {
//                            self.users = user  // Assuming `self.users` is now of type `User` and not `[User]`
//
//                            // Update the UI on the main thread, if needed
//                            DispatchQueue.main.async {
//                                self.emailTextField.text = user.email
//                                self.firstNameTextField.text = user.firstName
//                                // e.g., update labels, etc.
//                            }
//                        } else {
//                            print("Error initializing User from JSON")
//                        }
//                    }
//                } catch {
//                    // Handle JSON parsing error
//                    print("Error parsing JSON: \(error)")
//                }
//            }
//        }.resume()
        
        
        
        if let name = retrieveData(forKey: "user-firstName") as? String {
            self.firstNameTextField.text = name
        }
        if let lname = retrieveData(forKey: "user-lastName") as? String {
            self.lastNameTextField.text = lname
        }
        if let emailt = retrieveData(forKey: "user-email") as? String {
            self.emailTextField.text = emailt
        }
        if let target_saving = retrieveData(forKey: "user-target_saving") as? Int {
            self.targetSavingTextField.text = String(target_saving)
        }
        if let monthly_budget = retrieveData(forKey: "user-monthly_budget") as? Int {
            self.monthlyBudgetTextField.text = String(monthly_budget)
        }
        
        if let flatname = retrieveData(forKey: "flatName") as? String {
            self.flatNameTextField.text = flatname
        }
        
    }

    @IBAction func updateProfile(_ sender: UIButton) {
        
        
        guard let username = firstNameTextField.text, !username.isEmpty else{
            showErrorAlert(message: "First name should not be empty!")
            return
        }
        
        guard let email = emailTextField.text, !email.isEmpty else{
            showErrorAlert(message: "email should not be empty!")
            return
        }
        
        guard let lastName = lastNameTextField.text, !lastName.isEmpty else{
            showErrorAlert(message: "Last name should not be empty!")
            return
        }
        
        guard let monthly = monthlyBudgetTextField.text, !monthly.isEmpty else{
            showErrorAlert(message: "Monthly budget not be empty!")
            return
        }
        
        guard let monthlyint = Int(monthly) else {
            showErrorAlert(message: "Monthly Budget should be an integer!")
            return
        }
        
        guard let saving = targetSavingTextField.text, !saving.isEmpty else{
            showErrorAlert(message: "target Saving not be empty!")
            return
        }
        
        guard let savingint = Int(saving) else {
            showErrorAlert(message: "Target Saving should be an integer!")
            return
        }
        
        
        var urls: String?
        
        if let flatid = retrieveData(forKey: "user-_id") as? String {
            
            urls = "http://localhost:5001/user/\(flatid)"
            
        }
        
        let signupData = [
            "firstName": username,
            "lastName": lastName,
            "email": email,
            "target_saving": savingint,
            "monthly_budget": monthlyint
        ] as [String : Any]
        
        
    //    let apiUrl = "http://localhost:5001/user/656bca53d1f30e46d7199acb"
        
        
        guard let url = URL(string: urls ?? "") else {
            // Handle invalid URL
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: signupData, options: [])
        
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
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
            
            
            if let data = data {
                do {
                    // Parse the JSON response
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        // Handle the response data as needed
                        print("Update response: \(json)")
                        self.saveData(json)
                        // Example: If the response indicates successful login, navigate to the home page.
                        
                        
                        DispatchQueue.main.async {
                            self.viewDidLoad()
                          //  self.passwordTextField.text = ""
                           // self.performSegue(withIdentifier: "HomeSegue", sender: self)
                        }
                
                    }
                } catch {
                    // Handle JSON parsing error
                    print("Error parsing JSON: \(error)")
                }
            }

            
            self.showSuccessAlert()
            DispatchQueue.main.async {
               
            }
        }.resume()

       
        
    }
    
    
    func showSuccessAlert() {
        let alert = UIAlertController(title: "Success", message: "Account Updated successful!", preferredStyle: .alert)
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
    
    func saveData(_ data: [String: Any]) {
          let defaults = UserDefaults.standard
          for (key, value) in data {
              var k =  "user-" + key
              defaults.set(value, forKey: k)
          }
      }
}
