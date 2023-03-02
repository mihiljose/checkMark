//
//  SignUpViewController.swift
//  CheckMark
//
//  Created by Mihil Jose on 02/03/23.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    
    @IBOutlet weak var SignUpPasswordTextField: UITextField!
    @IBOutlet weak var SignUpEmailTextField: UITextField!

    
    @IBAction func LoginPageNavBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func SignUpBtn(_ sender: Any) {
        print(SignUpEmailTextField.text)
        print(SignUpPasswordTextField.text)
        
        Auth.auth().createUser(withEmail: SignUpEmailTextField.text ?? "", password: SignUpPasswordTextField.text ?? "") { authResult, error in
          guard let user = authResult?.user, error == nil else {
            // handle error
              self.view.makeToast("\(error?.localizedDescription ?? "Error")", duration: 3.0)
            return
          }
          // User is created and signed in
          // You can now access user.uid to identify the user in your database
            print(user.uid)
            firebaseUserID = user.uid
            self.view.makeToast("Sign Up Succesfull!", duration: 3.0)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ViewController")
            self.navigationController?.pushViewController(vc, animated: true)
        }
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
