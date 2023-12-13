////
////  refrence.swift
////  splitwise
////
////  Created by Gokul Jayavel on 12/12/23.
////
//
//import Foundation
//import UIKit
//
//
//class LoginViewController: UIViewController {
//    
//    
//    
//    @IBOutlet var emailLabel: UILabel!
//    
//    
//    @IBOutlet var PasswordLabel: UILabel!
//    
//    
//    @IBOutlet var label: UILabel!
//    
//    @IBOutlet var PasswordTextFeild: UITextField!
//    
//    @IBOutlet var EmailTextFeild: UITextField!
//    
//    
//    @IBOutlet var loginButton: UIButton!
//    
//    var scrollView: UIScrollView!
//    
//    var handleAuth: AuthStateDidChangeListenerHandle?
//    
//    var currentUser:FirebaseAuth.User?
//    
//    var activityIndicator: UIActivityIndicatorView?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupScrollView()
//        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
//            tapRecognizer.cancelsTouchesInView = false
//            view.addGestureRecognizer(tapRecognizer)
//        setup()
//        initConstrainsts()
//        
//    }
//    
//    @objc func hideKeyboardOnTap(){
//        //MARK: removing the keyboard from screen...
//        view.endEditing(true)
//    }
//    
//    func setupScrollView() {
//            // Initialize the scroll view and add it to the view
//            scrollView = UIScrollView(frame: .zero)
//            scrollView.translatesAutoresizingMaskIntoConstraints = false
//            view.addSubview(scrollView)
//            
//            // Constrain the scroll view to the entire view
//            NSLayoutConstraint.activate([
//                scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//                scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//                scrollView.topAnchor.constraint(equalTo: view.topAnchor),
//                scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//            ])
//            
//            // Add the previously added subviews to the scroll view instead
//            scrollView.addSubview(label)
//            scrollView.addSubview(emailLabel)
//            scrollView.addSubview(PasswordLabel)
//            scrollView.addSubview(EmailTextFeild)
//            scrollView.addSubview(PasswordTextFeild)
//            scrollView.addSubview(loginButton)
//        }
//    
//    func setup()
//    {
//       
//    
//        label.translatesAutoresizingMaskIntoConstraints = false
//        PasswordTextFeild.translatesAutoresizingMaskIntoConstraints = false
//        EmailTextFeild.translatesAutoresizingMaskIntoConstraints =  false
//        loginButton.translatesAutoresizingMaskIntoConstraints = false
//        emailLabel.translatesAutoresizingMaskIntoConstraints = false
//        PasswordLabel.translatesAutoresizingMaskIntoConstraints = false
//        
//    }
//    
//    func initConstrainsts()
//    
//    {
//        let contentLayoutGuide = scrollView.contentLayoutGuide
//        NSLayoutConstraint.activate([
//            label.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor, constant: 82),
//            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            
//            emailLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 42),
//            emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            
//            EmailTextFeild.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 18),
//            EmailTextFeild.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            EmailTextFeild.widthAnchor.constraint(equalToConstant: 233),
//            
//            PasswordLabel.topAnchor.constraint(equalTo: EmailTextFeild.bottomAnchor, constant: 32),
//            PasswordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            
//            PasswordTextFeild.topAnchor.constraint(equalTo: PasswordLabel.bottomAnchor, constant: 18),
//            PasswordTextFeild.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            PasswordTextFeild.widthAnchor.constraint(equalToConstant: 233),
//            
//            loginButton.topAnchor.constraint(equalTo: PasswordTextFeild.bottomAnchor, constant: 45),
//            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            loginButton.widthAnchor.constraint(equalToConstant: 91),
//            
//            // This is the key constraint that enables scrolling by tying the bottom of the button to the bottom of the scroll view's content.
//            loginButton.bottomAnchor.constraint(equalTo: contentLayoutGuide.bottomAnchor, constant: -20)
//        ])
//        
//        
//        
//        
//        
//    }
//    override func viewWillAppear(_ animated: Bool) {
//           super.viewWillAppear(animated)
//           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//       }
//       
//       override func viewWillDisappear(_ animated: Bool) {
//           super.viewWillDisappear(animated)
//           NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
//           NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
//       }
//       
//       @objc func keyboardWillShow(notification: NSNotification) {
//           guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
//               return
//           }
//           scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
//           scrollView.scrollIndicatorInsets = scrollView.contentInset
//       }
//       
//       @objc func keyboardWillHide(notification: NSNotification) {
//           scrollView.contentInset = .zero
//           scrollView.scrollIndicatorInsets = .zero
//       }
//    
//    @IBAction func LoginSubmit(_ sender: Any) {
//        
////        
////        if let email = EmailTextFeild.text, !email.isEmpty,
////                   let password = PasswordTextFeild.text, !password.isEmpty,
////                   isValidEmail(email) {
////                    // Show activity indicator or loading spinner
////                    showActivityIndicator()
////
////                    // Perform Firebase authentication for signing in
////                    Auth.auth().signIn(withEmail: email, password: password) { [weak self] (result, error) in
////                        // Hide activity indicator or loading spinner
////                        self?.hideActivityIndicator()
////
////                        if let error = error {
////                            // Handle sign-in failure
////                            self?.showAlert(message: "Sign in failed. \(error.localizedDescription)")
////                        } else {
////                            // Sign-in successful
////                            self?.currentUser = Auth.auth().currentUser
////                            // Perform segue to the home page
////                            DispatchQueue.main.async {
////                                    self?.performSegue(withIdentifier: "MainSegueIdentifier", sender: self)
////                                }
////                        }
////                    }
////                } else {
////                    showAlert(message: "Please enter a valid email address and password.")
////                }
////            }
////
////            // Function to validate email format
////            func isValidEmail(_ email: String) -> Bool {
////                let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
////                let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
////                return emailPredicate.evaluate(with: email)
////            }
////
////            // Function to show an alert
////            func showAlert(message: String) {
////                let alert = UIAlertController(title: "Authentication Error", message: message, preferredStyle: .alert)
////                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
////                present(alert, animated: true, completion: nil)
////            }
////
////            // Function to show the activity indicator
////            func showActivityIndicator() {
////                if activityIndicator == nil {
////                    activityIndicator = UIActivityIndicatorView(style: .large)
////                    activityIndicator?.center = view.center
////                    view.addSubview(activityIndicator!)
////                }
////
////                activityIndicator?.startAnimating()
//            }
//
//            // Function to hide the activity indicator
//            func hideActivityIndicator() {
//                activityIndicator?.stopAnimating()
//                activityIndicator?.removeFromSuperview()
//            }
//        }
