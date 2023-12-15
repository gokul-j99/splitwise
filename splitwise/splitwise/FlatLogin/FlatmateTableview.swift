import UIKit

class UsersTableViewController: UITableViewController {
    var users: [User] = [] // Array to store user data
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UserCell")
        // Fetch user data from the API and populate the 'users' array.
        fetchUserData()
    }
    
    // Function to fetch user data from the API
    func fetchUserData() {
        // Replace with your API URL
        var apiUrl: String = ""
        
        // Retrieve the data
        if let name = retrieveData(forKey: "_id") as? String {
            apiUrl = "http://localhost:5001/user/\(name)"
        }
       
        guard let url = URL(string: apiUrl) else {
            // Handle invalid URL
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if let error = error {
                // Handle the error, e.g., show an alert to the user
                print("Error fetching data: \(error)")
                return
            }
            
            if let data = data {
                do {
                    // Parse the JSON response as an array of users
                    if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                        // Map the JSON array to an array of User objects
                        self.users = jsonArray.compactMap { User(json: $0) }
                       // self.saveData(self.users)
                        self.saveUsers(self.users, forKey: "allusers")
                        // Update the table view on the main thread
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                } catch {
                    // Handle JSON parsing error
                    print("Error parsing JSON: \(error)")
                }
            }
        }.resume()
    }
    
    // Implement UITableViewDataSource methods here to populate the table view.
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        let user = users[indexPath.row]
        cell.textLabel?.text = user.firstName // Display the user's first name in the cell
        return cell
    }
    
    // Implement UITableViewDelegate method to handle cell selection and navigation.
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUser = users[indexPath.row]
        performSegue(withIdentifier: "PasswordEntrySegue", sender: selectedUser)
    }
    
    // Prepare for segue to pass data to the next view controller.
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PasswordEntrySegue",
           let passwordEntryViewController = segue.destination as? PasswordEntryViewController,
           let selectedUser = sender as? User {
            passwordEntryViewController.selectedUser = selectedUser
        }
    }
    
    func retrieveData(forKey key: String) -> Any? {
        let defaults = UserDefaults.standard
        return defaults.object(forKey: key)
    }
    
    func saveUsers(_ users: [User], forKey key: String) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(users)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Unable to Encode Array of Users (\(error))")
        }
    }

//
//    func saveData(_ data: [User]) {
//          let defaults = UserDefaults.standard
//        defaults.set(data, forKey: "allusers")
//      }

}
