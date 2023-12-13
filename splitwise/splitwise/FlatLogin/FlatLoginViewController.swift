//
//  FlatLoginViewController.swift
//  splitwise
//
//  Created by Gokul Jayavel on 12/1/23.
//

import UIKit

class LoginViewController: UIViewController {
    // Outlets for email and password text fields
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    func saveData(_ data: [String: Any]) {
          let defaults = UserDefaults.standard
          for (key, value) in data {
              defaults.set(value, forKey: key)
          }
      }

    // Login action
    @IBAction func loginButtonTapped(_ sender: UIButton) {
//        let email = emailTextField.text!
//        let password = passwordTextField.text!

        // Add your validation here
        
        
        guard let email = emailTextField.text, !email.isEmpty else{
            showErrorAlert(message: "email should not be empty!")
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else{
            showErrorAlert(message: "password should not be empty!")
            return
        }

        let loginData = [
            "email": email,
            "password": password
        ]
        
        loginUser(loginData: loginData)
    }

    func loginUser(loginData: [String: String]) {
        guard let url = URL(string: "http://localhost:5001/flat/login") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: loginData, options: [])

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                // Handle network error
                self.showErrorAlert(message: "An error occurred: \(error.localizedDescription)")
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

            do {
                // Assuming the response is JSON and contains data you want to save
                if let jsonResponse = try JSONSerialization.jsonObject(with: data!) as? [String: Any] {
                    // Save the response data
                    print(jsonResponse)
                    self.saveData(jsonResponse)
                    
                    // Perform segue to the next screen
                    DispatchQueue.main.async {
                        self.emailTextField.text = ""
                        self.passwordTextField.text = ""
                        self.performSegue(withIdentifier: "LoginToNextScreenSegue", sender: self)
                    }
                }
            } catch {
                // Handle JSON parsing error
                self.showErrorAlert(message: "Failed to parse response.")
            }
        }.resume()
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

