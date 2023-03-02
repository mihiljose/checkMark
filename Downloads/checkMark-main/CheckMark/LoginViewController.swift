//
//  LoginViewController.swift
//  CheckMark
//
//  Created by Mihil Jose on 01/03/23.
//

import UIKit
import Firebase


class LoginViewController: UIViewController {

    
   
    @IBOutlet weak var loginEmailTextField: UITextField!
    @IBOutlet weak var loginPasswordTextField: UITextField!
    @IBAction func loginBtn(_ sender: Any) {
        print(loginEmailTextField.text)
        print(loginPasswordTextField.text)
        
        Auth.auth().signIn(withEmail: loginEmailTextField.text ?? "", password: loginPasswordTextField.text ?? "") { authResult, error in
          guard let user = authResult?.user, error == nil else {
            // handle error
              
              self.view.makeToast("\(error?.localizedDescription ?? "Error")", duration: 3.0)
            return
          }
          // User is signed in
            self.view.makeToast("Log In Succesfull!", duration: 3.0)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ViewController")
            self.navigationController?.pushViewController(vc, animated: true)
        }

        
        

    }
    
    
    @IBAction func registerPageBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SignUpViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.hidesBackButton = true
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
