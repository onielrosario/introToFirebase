//
//  UserSession.swift
//  introToFireBase
//
//  Created by Oniel Rosario on 2/12/19.
//  Copyright © 2019 Oniel Rosario. All rights reserved.
//

import Foundation
import FirebaseAuth
//static func doesnt work with weak var

protocol UserSessionAccountCreationDelegate: AnyObject {
    func didCreateAccount(_ usersSession: UserSession, user: User)
    func didReceivedErrorCreatingAccount(_ userSession: UserSession, error: Error)
}

protocol UserSessionSignOutDelegate: AnyObject {
    func didRecieveSignOutError(_ usersession: UserSession, error: Error)
    func didSignOutUser(_ usersession: UserSession)
}

protocol UserSessionSignInDelegate: AnyObject {
    func didReceivedSignInError(_ usersession: UserSession, error: Error)
    func didSignIn(_ ussersession: UserSession, user: User)
}


final class UserSession {
    weak var userSessionAccountDelegate: UserSessionAccountCreationDelegate?
    weak var userSessionSignOutDelegate: UserSessionSignOutDelegate?
    weak var userSessionsignInDelegate: UserSessionSignInDelegate?
    
    
   public func createNewAccount(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            if let error = error {
                self.userSessionAccountDelegate?.didReceivedErrorCreatingAccount(self, error: error)
            } else if let authResult = authDataResult {
              self.userSessionAccountDelegate?.didCreateAccount(self, user: authResult.user)
            }
        }
    }
    
    public func getCurrentUser() -> User? {
      return Auth.auth().currentUser
    }
    
    public func signOut() {
        guard let _ = getCurrentUser() else {
           print("no current users")
            return
        }
        
        do {
            try Auth.auth().signOut()
            userSessionSignOutDelegate?.didSignOutUser(self)
        } catch {
            userSessionSignOutDelegate?.didRecieveSignOutError(self, error: error)
        }
    }
    
    public func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            if let error = error {
              self.userSessionsignInDelegate?.didReceivedSignInError(self, error: error)
            } else if let authDataResult = authDataResult {
                self.userSessionsignInDelegate?.didSignIn(self, user: authDataResult.user)
            }
        }
    }
    
}
