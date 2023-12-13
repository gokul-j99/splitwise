//
//  FlatmateLoginController.swift
//  splitwise
//
//  Created by Gokul Jayavel on 12/4/23.
//


import UIKit

class FlateMateSignupViewController: UIViewController {
    // Outlets
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!

    // Signup Action
    @IBAction func signupButtonTapped(_ sender: UIButton) {

        // Add your validation here
        
        guard let username = firstnameTextField.text, !username.isEmpty else{
            showErrorAlert(message: "First name should not be empty!")
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
        
        guard let lastName = lastNameTextField.text, !lastName.isEmpty else{
            showErrorAlert(message: "Last name should not be empty!")
            return
        }
        
        
        
   

        let signupData = [
            "firstName": username,
            "lastName": lastName,
            "email": email,
            "password": password
        ]
        
        signupUser(signupData: signupData)
    }

    func signupUser(signupData: [String: String]) {
        
        var urls: String?
        
        if let flatid = retrieveData(forKey: "_id") as? String {
            // Update the label text
            urls = "http://localhost:5001/user/\(flatid)"
            
        }
        
        
        guard let url = URL(string: urls ?? "") else { return }

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
                    
                    if let data = data,
                       let errorResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String],
                       let errorMessage = errorResponse["message"] {
                        self.showErrorAlert(message: errorMessage)
                    } else {
                        self.showErrorAlert(message: "An unexpected error occurred")
                    }
                    
                    return
            }


           
            
            self.showSuccessAlert()
            DispatchQueue.main.async {
                self.firstnameTextField.text = ""
                self.lastNameTextField.text = ""
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
            }
        }.resume()
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


