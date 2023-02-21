//
//  ViewController.swift
//  CheckMark
//
//  Created by Mihil Jose on 17/02/23.
//

import UIKit



class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var items = [String]()
    var cellHeight : CGFloat = 0
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 1
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todo_list_item", for: indexPath) as! todo_list_item
        cell.todoTitle.text = items[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        print("treeeess\(cellHeight)")
        return 120
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            items.remove(at: indexPath.row)
            
            today_checklists.reloadData()
            
            UserDefaults.standard.set(items, forKey: "items")
            
        }
        
    }

    
    @IBOutlet weak var profilePicButton: UIImageView!
    @IBOutlet weak var today_checklists: UITableView!
    
    @IBAction func addButton(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "addEntryViewController") as! addEntryViewController
        vc.title = "New Task"
        navigationController?.pushViewController(vc, animated: true)
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
        
        today_checklists.register(UINib(nibName: "todo_list_item", bundle: nil), forCellReuseIdentifier: "todo_list_item")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let itemsObject = UserDefaults.standard.object(forKey: "items")
        
        
        if let tempItems = itemsObject as? [String] {
            
            items = tempItems
            
        }
        
        today_checklists.reloadData()
    }
    


}



