//
//  LaunchViewController.swift
//  CafeNibm
//
//  Created by Tiny Pahattuge on 2021-04-30.
//

import UIKit

class LaunchViewController: UIViewController {

    let sessionmgr = Session()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        if sessionmgr.getloggedstate() {
            self.performSegue(withIdentifier: "Launchtohome", sender: nil)
        }
        else
        {
            self.performSegue(withIdentifier: "LaunchtoSignin", sender: nil)
        }
        
    }

}
