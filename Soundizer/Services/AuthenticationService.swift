//
//  AuthenticationService.swift
//  Soundizer
//
//  Created by Krzysztof Kogut on 16/12/2020.
//

import Foundation
import Firebase
import GoogleSignIn

class AuthenticationService: NSObject, ObservableObject, GIDSignInDelegate {
    @Published var isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
    
    override init() {
        super.init()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
    -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        if let currentUser = Auth.auth().currentUser {
            currentUser.link(with: credential, completion: { (authResult, error) in
                if let error = error, (error as NSError).code == AuthErrorCode.credentialAlreadyInUse.rawValue {
                    print("This user is already in use.")
                    if let updatedCredential = (error as NSError).userInfo[AuthErrorUserInfoUpdatedCredentialKey] as? OAuthCredential {
                        print("Signing in using updated credential")
                        Auth.auth().signIn(with: updatedCredential) { (authResult, error) in
                            UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                            self.isUserLoggedIn = true
                            if let user = authResult?.user {
                                print("User=" + (user.email)!)
                            }
                        }
                    }
                }
                else {
                    UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                    self.isUserLoggedIn = true
                    print("User=" + (authResult?.user.email ?? "none"))
                }
            })
        }
        else {
            Auth.auth().signIn(with: credential) { (result, error) in
                if error != nil {
                    print((error?.localizedDescription)!)
                }
                UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                self.isUserLoggedIn = true
                print("User=" + (result?.user.email)!)
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
    
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
            self.isUserLoggedIn = false
            print("Signed out")
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError)")
        }
    }
}
