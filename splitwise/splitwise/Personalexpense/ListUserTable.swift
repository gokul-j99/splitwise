//
//  GroupExpense.swift
//  splitwise
//
//  Created by Gokul Jayavel on 12/14/23.
//

import Foundation
import UIKit

protocol MultiSelectionDelegate: AnyObject {
    func didSelectItems(_ selectedItems: [User])
}

import UIKit
class MultiSelectionTableViewController: UITableViewController {
    weak var delegate: MultiSelectionDelegate?
    var users: [User] = [] // Selected users
    var allusers: [User] = [] // All available users

    override func viewDidLoad() {
        super.viewDidLoad()
        self.allusers = self.loadUsers(forKey: "allusers") ?? []
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UserCell")
        tableView.allowsMultipleSelection = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        preSelectUsers()
    }
    
    func preSelectUsers() {
        for (index, user) in allusers.enumerated() {
            if users.contains(where: { $0.id == user.id }) {
                let indexPath = IndexPath(row: index, section: 0)
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allusers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        let user = allusers[indexPath.row]
        cell.textLabel?.text = user.firstName
        // Set checkmark for selected users
        cell.accessoryType = users.contains(where: { $0.id == user.id }) ? .checkmark : .none
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUser = allusers[indexPath.row]
        if !users.contains(where: { $0.id == selectedUser.id }) {
            users.append(selectedUser)
        }
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let deselectedUser = allusers[indexPath.row]
        users.removeAll(where: { $0.id == deselectedUser.id })
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }


    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        let selectedUsers = getSelectedUsers()
        delegate?.didSelectItems(selectedUsers)
        navigationController?.popViewController(animated: true)
    }

    func getSelectedUsers() -> [User] {
        if let selectedIndexPaths = tableView.indexPathsForSelectedRows {
            return selectedIndexPaths.map { allusers[$0.row] }
        }
        return []
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
}
