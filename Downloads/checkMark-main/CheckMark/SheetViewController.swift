//
//  SheetViewController.swift
//  CheckMark
//
//  Created by Mihil Jose on 22/02/23.
//

import UIKit
import Firebase
//import Toast_Swift



class SheetViewController: UIViewController, UISheetPresentationControllerDelegate{

    @IBOutlet weak var todaySwitch: UISwitch!
    @IBOutlet weak var hourField: UIDatePicker!
    @IBOutlet weak var nameTextField: UITextField!
    
    // Get a reference to the Firebase database
    let ref = Database.database().reference()
    
    var Tododata = [
        "name": "John",
        "hour": "15:30",
        "date": "today"
    ]
    
    
   
    @IBAction func doneAddBtn(_ sender: Any) {
        
                let title = nameTextField.text
                print(title)
                if todaySwitch.isOn{
                    let datePicker = UIDatePicker()
        
                    // Get the selected date from the date picker
                    let selectedDate = datePicker.date
        
                    // Create a date formatter to format the date as a string
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "HH:mm"
                    dateFormatter.timeStyle = .short
                    // Convert the selected date to a string using the date formatter
                    let dateString = dateFormatter.string(from: selectedDate)
        
                    let hour = dateString
                    print(hour)
                    
                    Tododata = [
                        "name": title ?? "Martin",
                        "hour": hour,
                        "date": "today"
                    ]
                    
                    // Add the data to the database
                    ref.child("TodoTasks\(firebaseUserID ?? "")").childByAutoId().setValue(Tododata) { error, ref in
                        if let error = error {
                            print("Error adding record: \(error.localizedDescription)")
                            self.view.makeToast("Error adding record: \(error.localizedDescription)", duration: 3.0)
                        } else {
                            print("Record added successfully!")
                            self.view.makeToast("Record added successfully!", duration: 3.0)
                        }
                    }
                    
                }
                
                else{
                    let datePicker = UIDatePicker()
        
                    // Get the selected date from the date picker
                    let selectedDate = datePicker.date
        
                    // Create a Calendar instance
                    let calendar = Calendar.current
        
                    // Create a DateComponents instance representing one day
                    var dateComponents = DateComponents()
                    dateComponents.day = 1
        
                    // Add the date components to the selected date to get the next day
                    if let nextDay = calendar.date(byAdding: dateComponents, to: selectedDate) {
                        // nextDay is the selected date plus one day
                        print(nextDay)
                    }
                    
                    // Add the data to the database
                    ref.child("TodoTasksTommorow").childByAutoId().setValue(Tododata) { error, ref in
                        if let error = error {
                            print("Error adding record: \(error.localizedDescription)")
                            self.view.makeToast("Error adding record: \(error.localizedDescription)", duration: 3.0)
                        } else {
                            print("Record added successfully!")
                            self.view.makeToast("Record added successfully!", duration: 3.0)
                        }
                    }
                    
                }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
