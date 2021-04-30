//
//  SignInViewController.swift
//  CafeNibm
//
//  Created by Tiny Pahattuge on 2021-04-10.
//

import UIKit
import Firebase
import Loaf

class SignInViewController: UIViewController {

    @IBOutlet weak var txtemail: UITextField!
    @IBOutlet weak var txtpassword: UITextField!
    @IBOutlet weak var onsignin: UIButton!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func onsigninclick(_ sender: Any) {
        if !InputValidator.isValidEmail(email: txtemail.text ?? ""){
            Loaf("Invalid Email address ",state:.error,sender:self).show()
            return
        }
        
        if !InputValidator.isValidPassword(pass: txtpassword.text ?? "" , minLength: 6, maxLength: 50){
            Loaf("Invalid Email address ",state:.error,sender:self).show()
            return
        }
        
        AuthenticateUser(email: txtemail.text!, password: txtpassword.text!)
        
    }
    
    
    func AuthenticateUser(email:String,password:String){
        Auth.auth().signIn(withEmail: email, password: password) {  authResult, error in
          
            if let err = error{
                print(err.localizedDescription)
                Loaf("User name or password is invalid",state:.error,sender:self).show()
                return
            }
            
            if let email = authResult?.user.email{
                self.getUserData(email: email)
            }
            else{
                Loaf("User not found ",state:.error,sender:self).show()
            }
            
            
        }
    }
    
    func getUserData(email :String){
        ref.child("users").child(email
                        .replacingOccurrences(of: "@", with: "_")
                        .replacingOccurrences(of: ".", with: "_")).observe(.value, with: {
            (snapshot) in
                if snapshot.hasChildren(){
                    if let data = snapshot.value{
                        if let userdata = data as? [String :Any]{
                            let user = User(
                                Username: userdata["userName"] as! String,
                                Useremail: userdata["userEmail"] as! String,
                                Userpassword:userdata["userPassword"] as! String,
                                Phonenumber:userdata["userPhone"] as! String)
                            
                            let sessionManager = Session()
                            sessionManager.saveuserlogin(user: user)
                            self.performSegue(withIdentifier: "SignInTohome", sender: nil)
                        }
                    }
                }
                else{
                    Loaf("User not found",state:.error,sender:self).show()
                    }
            } )
    }
}

