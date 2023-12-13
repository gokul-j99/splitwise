//
//  PasswordEntryViewController.swift
//  splitwise
//
//  Created by Gokul Jayavel on 12/5/23.
//

import Foundation
import UIKit

class PasswordEntryViewController: UIViewController {
    var selectedUser: User?
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = selectedUser {
            nameLabel.text = "Welcome \(user.firstName)!!"
        }
        
    }
    
    @IBAction func submitPassword(_ sender: UIButton) {
        if let enteredPassword = passwordTextField.text, let user = selectedUser {
            // Create a dictionary for the POST request body
            let requestBody: [String: Any] = [
                "firstName": user.firstName,
                "password": enteredPassword
            ]
            
            // Convert the dictionary to JSON data
            if let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) {
                // Replace with your API URL
                let apiUrl = "http://localhost:5001/user/login"
                if let url = URL(string: apiUrl) {
                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.httpBody = jsonData
                    
                    URLSession.shared.dataTask(with: request) { (data, response, error) in
                        if let error = error {
                            // Handle the error, e.g., show an alert to the user
                            print("Error making the login request: \(error)")
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
                                    print("Login response: \(json)")
                                    self.saveData(json)
                                    // Example: If the response indicates successful login, navigate to the home page.
                                    
                                    
                                    DispatchQueue.main.async {
                                        self.passwordTextField.text = ""
                                        self.performSegue(withIdentifier: "HomeSegue", sender: self)
                                    }
                            
                                }
                            } catch {
                                // Handle JSON parsing error
                                print("Error parsing JSON: \(error)")
                            }
                        }
                    }.resume()
                }
            }
        }
    }
    
    func saveData(_ data: [String: Any]) {
          let defaults = UserDefaults.standard
          for (key, value) in data {
              var k =  "user-" + key 
              defaults.set(value, forKey: k)
          }
      }
    
    
    func showSuccessAlert() {
        let alert = UIAlertController(title: "Success", message: "Login successful!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            // Perform segue or further actions after login
        }))
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }

    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error Login failed", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
}
