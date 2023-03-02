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
    var hour: String
    var dueDate: String

    init(title: String, hour: String, dueDate: String) {
        self.title = title
        self.hour = hour
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
        
        
        cell.hourTodo?.text = todoItem.hour

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
    @IBAction func signOutBtn(_ sender: Any) {
        firebaseUserID = nil
        self.view.makeToast("Log Out Succesfull!", duration: 3.0)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func hideCompletedButton(_ sender: Any) {
//        let sheetViewController = tryViewController()
//        sheetViewController.modalPresentationStyle = .pageSheet
//        present(sheetViewController, animated: true, completion: nil)
    }
    
    private let floatingButton: UIButton = {
        let FABbutton = UIButton (frame: CGRect (x: 0, y: 0, width: 60, height: 60))
        FABbutton.layer.masksToBounds = true
        FABbutton.layer.cornerRadius = 30
        FABbutton.backgroundColor = . black
        let image = UIImage (systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium))
        FABbutton.setImage (image, for: .normal)
        FABbutton.tintColor = .white
        FABbutton.setTitleColor( .white, for: .normal)
        return FABbutton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.hidesBackButton = true
        today_checklists.dataSource = self
        today_checklists.delegate = self
        
        view.addSubview(floatingButton)
        floatingButton.addTarget(self, action: #selector(didTapFAButton), for: .touchUpInside)
        
        ref = Database.database().reference()
    
        
        today_checklists.register(UINib(nibName: "todo_list_item", bundle: nil), forCellReuseIdentifier: "todo_list_item")
        
        // Fetch the list of to-do items from Firebase
                ref.child("TodoTasks\(firebaseUserID ?? "")").observe(.value, with: { snapshot in
                    self.todoItems.removeAll()

                    for child in snapshot.children {
                        if let childSnapshot = child as? DataSnapshot,
                            let dict = childSnapshot.value as? [String:Any],
                            let title = dict["name"] as? String,
                            let hr = dict["hour"] as? String,
                            let dueDateString = dict["date"] as? String {
                            let todoItem = TodoItem(title: title, hour: hr, dueDate: dueDateString)
                            self.todoItems.append(todoItem)
                            print(todoItem)
                        }
                    }

                    self.today_checklists.reloadData()
                })
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        floatingButton.frame = CGRect(
            x: view.frame.size.width - 70 - 8,
            y: view.frame.size.height - 100 - 8,
        width: 60,
        height: 60)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let itemsObject = UserDefaults.standard.object(forKey: "items")
        
        
        if let tempItems = itemsObject as? [String] {
            
            items = tempItems
            
        }
        
        today_checklists.reloadData()
    }
    
    @objc private func didTapFAButton(){
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let sheetPresenationController =
        storyboard.instantiateViewController(withIdentifier: "SheetViewController") as! SheetViewController
        self.present (sheetPresenationController, animated: true, completion: nil)
    }

}



