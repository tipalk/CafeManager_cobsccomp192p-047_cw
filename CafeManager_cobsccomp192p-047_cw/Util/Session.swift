//
//  Session.swift
//  CafeNibm
//
//  Created by Tiny Pahattuge on 2021-04-10.
//

import Foundation

class Session {
    func getloggedstate() -> Bool{
        UserDefaults.standard.bool(forKey: "Logged_in")
        return false
    }
    
    func saveuserlogin(user:User)
    {
        UserDefaults.standard.setValue(true, forKey: "Logged_in")
        UserDefaults.standard.setValue(user.Username, forKey: "User_name")
        UserDefaults.standard.setValue(user.Useremail, forKey: "User_mail")
        UserDefaults.standard.setValue(user.Phonenumber, forKey: "User_phone")
    }
    func getUserData()->User{
        let user =
            User(Username: UserDefaults.standard.string(forKey: "User_name") ??  "",
                Useremail: UserDefaults.standard.string(forKey: "User_mail") ?? "",
                Userpassword: ""  ,
                Phonenumber:UserDefaults.standard.string(forKey: "User_phone") ?? "" )
        return user
    }
    
    func clearuserlogin() {
        UserDefaults.standard.setValue(false, forKey: "Logged_in")
        
    }
}
