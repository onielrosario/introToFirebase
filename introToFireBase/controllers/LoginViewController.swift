//
//  ViewController.swift
//  introToFireBase
//
//  Created by Oniel Rosario on 2/11/19.
//  Copyright © 2019 Oniel Rosario. All rights reserved.
//

import UIKit
import FirebaseAuth



class LoginViewController: UIViewController {
    @IBOutlet weak var loginView: LoginView!
    private var usersession: UserSession!
    override func viewDidLoad() {
        super.viewDidLoad()
      loginView.delegate = self
        usersession = (UIApplication.shared.delegate as! AppDelegate).usersession
        usersession.userSessionAccountDelegate = self
        usersession.userSessionsignInDelegate = self
    }
}

extension LoginViewController: LoginViewDelegate {
    func didSelectLoginButton(_ loginView: LoginView, accountLoginState: AccountLoginState) {
        guard let email = loginView.emailTF.text, let password = loginView.pwTF.text, !email.isEmpty, !password.isEmpty else {
            //todo: show user alert
            print("email and password required")
            return
        }
        switch accountLoginState {
        case .newAccount:
            usersession.createNewAccount(email: email, password: password)
        case .existingAccount:
            usersession.signIn(email: email, password: password)
        }
    }
}

extension LoginViewController: UserSessionAccountCreationDelegate {
    func didCreateAccount(_ usersSession: UserSession, user: User) {
        let alertController = UIAlertController(title: "Account Created", message: "account create using \(user.email ?? "no email entered") ", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    func didReceivedErrorCreatingAccount(_ userSession: UserSession, error: Error) {
        print("didRecieveErrorCreatingAccount eith error: \(error)")
        let alertController = UIAlertController(title: "Account Creation EArror", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}

extension LoginViewController: UserSessionSignInDelegate {
    func didReceivedSignInError(_ usersession: UserSession, error: Error) {
        let alertController = UIAlertController(title: "Sign In Error", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    func didSignIn(_ ussersession: UserSession, user: User) {
        let alertController = UIAlertController(title: "Welcome back!", message: "hello \(user.email ?? "no email entered")", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) {
            alert in
            let storyboard = UIStoryboard(name: "RaceReviewTab", bundle: nil)
            let raceReviewTab = storyboard.instantiateViewController(withIdentifier: "RaceReviewsTabController") as! RaceReviewsTabController
            raceReviewTab.modalTransitionStyle = .crossDissolve
            raceReviewTab.modalPresentationStyle = .overFullScreen
            self.present(raceReviewTab, animated: true, completion: nil)
        }
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    
}
