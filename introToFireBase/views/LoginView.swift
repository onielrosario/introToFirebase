//
//  LoginView.swift
//  introToFireBase
//
//  Created by Oniel Rosario on 2/11/19.
//  Copyright © 2019 Oniel Rosario. All rights reserved.
//

import UIKit

//state for login
enum AccountLoginState {
    case existingAccount
    case newAccount
}

//delegate for login view
protocol LoginViewDelegate: AnyObject {
    func didSelectLoginButton(_ loginView: LoginView, accountLoginState: AccountLoginState)
}

class LoginView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var pwTF: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var messageLabe: UILabel!
    //gestures
    private var tapGesture: UITapGestureRecognizer!
    //setting default account state
    private var accountLoginState = AccountLoginState.newAccount
    public weak var delegate: LoginViewDelegate?
    //coming from code programmatic
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    
    //coming from storyboard
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        commonInit()
    }
    
    
    //bridging helping method
    private func commonInit() {
        //loade the nib/ xib
        Bundle.main.loadNibNamed("LoginView", owner: self, options: nil)
        addSubview(contentView)
        //contentview takes size of bounds
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //setup button and message label
        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        //setup tapGesture recognizer
        //label and imageview by default isuserinteractionenabled is false, this not allowing for gesture recognizer by the user.
        messageLabe.isUserInteractionEnabled = true
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(gestureRecognizer:)))
        messageLabe.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        accountLoginState = accountLoginState == .newAccount ? .existingAccount : .newAccount
        switch accountLoginState {
        case .newAccount:
            loginButton.setTitle("Create", for: .normal)
            messageLabe.text = "Login into your account"
        case .existingAccount:
             loginButton.setTitle("Login", for: .normal)
             messageLabe.text = "New user? Create an account"
        }
    }
    
    @objc private func loginButtonPressed() {
        print("\(accountLoginState)")
        delegate?.didSelectLoginButton(self, accountLoginState: accountLoginState)
    }
}
