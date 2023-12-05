//
//  MainController.swift
//  splitwise
//
//  Created by Gokul Jayavel on 12/1/23.
//

import UIKit

class SignupViewController: UIViewController {
    // Outlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!

    // Signup Action
    @IBAction func signupButtonTapped(_ sender: UIButton) {
        //let username = usernameTextField.text!
       // let email = emailTextField.text!
       // let password = passwordTextField.text!
      //  let confirmPassword = confirmPasswordTextField.text!

        // Add your validation here
        
        guard let username = usernameTextField.text, !username.isEmpty else{
            showErrorAlert(message: "Flatname should not be empty!")
            return
        }
        
        guard let email = emailTextField.text, !email.isEmpty else{
            showErrorAlert(message: "email should not be empty!")
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else{
            showErrorAlert(message: "password should not be empty!")
            return
        }
        
        guard let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else{
            showErrorAlert(message: "confirmPassword should not be empty!")
            return
        }
        
        
        
        if(password != confirmPassword){
            self.showErrorAlert(message:"Confirm Password doesn't match with Password")
            return
        }

        let signupData = [
            "flatName": username,
            "email": email,
            "password": password
        ]
        
        signupUser(signupData: signupData)
    }

    func signupUser(signupData: [String: String]) {
        guard let url = URL(string: "http://localhost:5001/flat") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
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
                self.showErrorAlert(message: (String(describing: response)))
                return
            }

            // Handle success
            
            self.showSuccessAlert()
            DispatchQueue.main.async {
               
            }
        }.resume()
    }
    
    func showSuccessAlert() {
        let alert = UIAlertController(title: "Success", message: "Signup successful!", preferredStyle: .alert)
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

    
}


