//
//  ViewController.swift
//  CheckMark
//
//  Created by Mihil Jose on 17/02/23.
//

import UIKit
import Firebase

class TodoItem {
    var title: String
    var description: String
    var dueDate: Date

    init(title: String, description: String, dueDate: Date) {
        self.title = title
        self.description = description
        self.dueDate = dueDate
    }
}


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var items = [String]()
    var todoItems: [TodoItem] = []
    var ref: DatabaseReference!
    var cellHeight : CGFloat = 0
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 1
        //return items.count
        return todoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todo_list_item", for: indexPath) as! todo_list_item
//        cell.todoTitle.text = items[indexPath.row]
//        return cell
        
        let todoItem = todoItems[indexPath.row]

            cell.todoTitle?.text = todoItem.title
        print(todoItem.dueDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm" // Set the date format you want

        let currentDate = todoItem.dueDate
        let dateString = dateFormatter.string(from: currentDate) // Convert the date to a string

        var optionalString: String? // Declare your optional string variable
        optionalString = dateString // Assign the string to the optional string variable
        cell.timestamp?.text = optionalString
        print(optionalString)

            return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        print("treeeess\(cellHeight)")
        return 120
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
                deleteTodoItem(at: indexPath)
                todoItems.remove(at: indexPath.row)
            today_checklists.deleteRows(at: [indexPath], with: .fade)
            }
        
    }

    
    @IBOutlet weak var profilePicButton: UIImageView!
    @IBOutlet weak var today_checklists: UITableView!
    
    @IBAction func addButton(_ sender: Any) {
        let alertController = UIAlertController(title: "New To-Do Item", message: nil, preferredStyle: .alert)

                alertController.addTextField { textField in
                    textField.placeholder = "Title"
                }
                alertController.addTextField { textField in
                    textField.placeholder = "Description"
                }

                alertController.addTextField { textField in
                    textField.placeholder = "Due Date"
                    textField.inputView = UIDatePicker()
                }

                let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
                    guard let title = alertController.textFields?[0].text,
                        let description = alertController.textFields?[1].text,
                        let dueDateText = alertController.textFields?[2].text,
                        let dueDate = DateFormatter().date(from: dueDateText) else {
                            return
                    }

                    let todoItem = TodoItem(title: title, description: description, dueDate: dueDate)

                    // Add the new to-do item to Firebase
                    let childRef = self.ref.child("todoItems").childByAutoId()
                    childRef.setValue(["title": title, "description": description, "dueDate": DateFormatter().string(from: dueDate)])
                                       }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

            alertController.addAction(saveAction)
            alertController.addAction(cancelAction)

            present(alertController, animated: true)
        }

        func deleteTodoItem(at indexPath: IndexPath) {
            let todoItem = todoItems[indexPath.row]

            // Delete the to-do item from Firebase
            ref.child("todoItems").queryOrdered(byChild: "title").queryEqual(toValue: todoItem.title).observeSingleEvent(of: .value, with: { snapshot in
                for child in snapshot.children {
                    if let childSnapshot = child as? DataSnapshot {
                        childSnapshot.ref.removeValue()
                    }
                }
            })
        
    


//        let vc = storyboard?.instantiateViewController(withIdentifier: "addEntryViewController") as! addEntryViewController
//        vc.title = "New Task"
//        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func hideCompletedButton(_ sender: Any) {
//        let sheetViewController = tryViewController()
//        sheetViewController.modalPresentationStyle = .pageSheet
//        present(sheetViewController, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        today_checklists.dataSource = self
        today_checklists.delegate = self
        
        ref = Database.database().reference()
    
        
        today_checklists.register(UINib(nibName: "todo_list_item", bundle: nil), forCellReuseIdentifier: "todo_list_item")
        
        // Fetch the list of to-do items from Firebase
                ref.child("todoItems").observe(.value, with: { snapshot in
                    self.todoItems.removeAll()

                    for child in snapshot.children {
                        if let childSnapshot = child as? DataSnapshot,
                            let dict = childSnapshot.value as? [String:Any],
                            let title = dict["title"] as? String,
                            let description = dict["description"] as? String,
                            let dueDateString = dict["dueDate"] as? String,
                            let dueDate = DateFormatter().date(from: dueDateString) {
                            let todoItem = TodoItem(title: title, description: description, dueDate: dueDate)
                            self.todoItems.append(todoItem)
                        }
                    }

                    self.today_checklists.reloadData()
                })
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let itemsObject = UserDefaults.standard.object(forKey: "items")
        
        
        if let tempItems = itemsObject as? [String] {
            
            items = tempItems
            
        }
        
        today_checklists.reloadData()
    }
    


}



