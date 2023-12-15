//
//  UserLanding.swift
//  splitwise
//
//  Created by Gokul Jayavel on 12/15/23.
//

import Foundation
import UIKit

class CurrentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Additional setup if needed
    }

    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        // Pop the current view controller and go back to UsersTableViewController
        if let viewControllers = navigationController?.viewControllers {
                    for viewController in viewControllers {
                        if let usersTableVC = viewController as? UsersTableViewController {
                            // Pop to UsersTableViewController
                            navigationController?.popToViewController(usersTableVC, animated: true)
                            return
                        }
                    }
                }
    }
}
