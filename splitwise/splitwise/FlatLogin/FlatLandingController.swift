//
//  FlatLandingController.swift
//  splitwise
//
//  Created by Gokul Jayavel on 12/2/23.
//

import Foundation
import UIKit

class FlatLandingController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Retrieve the data
        if let name = retrieveData(forKey: "flatName") as? String {
            // Update the label text
            nameLabel.text = "Welcome to \(name)!!"
            nameLabel.textColor = .white
        }
    }

    func retrieveData(forKey key: String) -> Any? {
        let defaults = UserDefaults.standard
        return defaults.object(forKey: key)
    }
}

