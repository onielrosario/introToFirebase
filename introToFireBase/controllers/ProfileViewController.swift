//
//  ProfileViewController.swift
//  introToFireBase
//
//  Created by Oniel Rosario on 2/12/19.
//  Copyright © 2019 Oniel Rosario. All rights reserved.
//

import UIKit

class ProfileViewController: UITableViewController {
    @IBOutlet weak var signOut: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    private var usersession: UserSession!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
usersession = (UIApplication.shared.delegate as! AppDelegate).usersession
        //delegate foir sign out
        usersession.userSessionSignOutDelegate = self
        
        if let user = usersession.getCurrentUser() {
            emailLabel.text = user.email ?? "no email found for logged user"
        } else {
            emailLabel.text = "no logged user"
        }
    }


    @IBAction func signOutButtonPressed(_ sender: UIButton) {
        usersession.signOut()
    }
  
}

extension ProfileViewController: UserSessionSignOutDelegate {
    func didRecieveSignOutError(_ usersession: UserSession, error: Error) {
        print("didRecievedSignOutError: \(error)")
    }
    
    func didSignOutUser(_ usersession: UserSession) {
        let window = (UIApplication.shared.delegate as! AppDelegate).window
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        window?.rootViewController = loginViewController
    }
    
    
}
