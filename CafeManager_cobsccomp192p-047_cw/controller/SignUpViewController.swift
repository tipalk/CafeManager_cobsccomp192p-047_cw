//
//  SignUpViewController.swift
//  CafeNibm
//
//  Created by Tiny Pahattuge on 2021-04-10.
//

import UIKit
import Firebase
import Loaf

class SignUpViewController: UIViewController {

    @IBOutlet weak var txtname: UITextField!
    @IBOutlet weak var txtemail: UITextField!
    @IBOutlet weak var txttelnumber: UITextField!
    @IBOutlet weak var txtpassword: UITextField!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickSignUp(_ sender: Any) {
        
        if !InputValidator.isValidName(name: txtname.text ?? ""){
            Loaf("Invalid name ",state:.error,sender:self).show()
            return
        }
        if !InputValidator.isValidEmail(email: txtemail.text ?? ""){
            Loaf("Invalid Email address ",state:.error,sender:self).show()
            return
        }
        if !InputValidator.isValidMobileNo(txttelnumber.text ?? ""){
            Loaf("Invalid phone number ",state:.error,sender:self).show()
            return
        }
        if !InputValidator.isValidPassword(pass: txtpassword.text ?? "" , minLength: 6, maxLength: 50){
            Loaf("Invalid Email address ",state:.error,sender:self).show()
            return
        }
        
        let user = User(Username: txtname.text ?? "" , Useremail: txtemail.text ?? "", Userpassword: txtpassword.text ?? "", Phonenumber: txttelnumber.text ?? "")
        
        createUser(user:user)
    
    }
    
    @IBAction func GoToSignin(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func createUser (user :User){
        Auth.auth().createUser(withEmail: user.Useremail, password: user.Userpassword ) { authResult, error in
            
            if let err = error{
                print(err.localizedDescription)
                Loaf("Signup failed ",state:.error,sender:self).show()
                return
            }
            
            
            self.saveUserData(user: user)
            
            }
        }
   
    func saveUserData(user:User){
        let userdata = [
            "userName" : user.Username,
            "userEmail" : user.Useremail,
            "userPhone" : user.Phonenumber,
            "userPassword" : user.Userpassword
        ]
        
        self.ref.child("users").child(user.Useremail
                                        .replacingOccurrences(of: "@", with: "_")
                                        .replacingOccurrences(of: ".", with: "_")).setValue(userdata){
            (error,ref) in
            if let err = error{
                print(err.localizedDescription)
                Loaf("Signup data not saved ",state:.error,sender:self).show()
                return
            }
            
                                            
            Loaf("Signup data  saved ",state:.success,sender:self).show{
                type in
                self.dismiss(animated: true, completion: nil)
            }
            
             
        }
    }
    
}

