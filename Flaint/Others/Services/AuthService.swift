//
//  AuthService.swift
//  Flaint
//
//  Created by Kerby Jean on 7/4/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import FirebaseAuth

class AuthService {
    
    static let shared = AuthService()
    
    var UserID: String? {
        didSet {
            UserDefaults.standard.set(UserID, forKey: .userId)
        }
    }
    
    // MARK: - Phone verification

    func PhoneAuth(phone: String, complete: @escaping (Bool, Error?) -> Void) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: nil) { verificationID, error in
            if let error = error {
                print("ERROR:", error.localizedDescription)
                complete(false, error)
                return
            } else {
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                complete(true, nil)
            }
        }
    }
    
    // MARK: Email register

    func EmailAuth(username: String, name: String, email: String, phone: String, pwd: String, code: String, complete: @escaping (Bool, Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: pwd) { result, error in
            if let error = error {
                print("ERROR:", error.localizedDescription)
                complete(false, error)
            } else {
                if let user = result?.user {
                    
                /// Link email with phone credential
                    
                let credential: PhoneAuthCredential = PhoneAuthProvider.provider().credential(withVerificationID: UserDefaults.standard.string(forKey: "authVerificationID")!, verificationCode: code)
                    
                    user.link(with: credential, completion: { _, error in
                        if let err = error {
                            print("Error:", err.localizedDescription)
                        } else {
                            UserDefaults.standard.set(user.uid, forKey: "userId")
                            UserDefaults.standard.synchronize()
                            let changeRequest = user.createProfileChangeRequest()
                            changeRequest.displayName = name
                            changeRequest.commitChanges { error in
                                print("ERROR:", error?.localizedDescription ?? "")
                                let data: [String: Any] = ["email": email, "name": name, "username": username]
                                DataService.shared.saveUserData(user.uid, data, complete: { success, error in
                                    if !success {
                                        complete(false, error)
                                    } else {
                                        DataService.shared.authLink(username: username, email: email)
                                        UserDefaults.standard.set(pwd, forKey: "password")
                                        complete(true, nil)
                                    }
                                })
                            }
                        }
                    })
                }
            }
        }
    }
    
    // MARK: - Email login
    
    func emailLogin(email: String, pwd: String, complete: @escaping (String?, Bool, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: pwd) { result, error in
            if let error = error {
                complete(nil, false, error)
            } else {
                if let uid = result?.user.uid {
                    self.UserID = uid
                    UserDefaults.standard.set(uid, forKey: .userId)
                    complete(uid, true, nil)
                }
            }
        }
    }
    
    // MARK: - Phone login
    
    func phoneLogIn(code: String, complete: @escaping (Bool, Error?, String?) -> Void) {
        let defaults = UserDefaults.standard
          let credential: PhoneAuthCredential = PhoneAuthProvider.provider().credential(withVerificationID: defaults.string(forKey: "authVerificationID")!, verificationCode: code)
        Auth.auth().signIn(with: credential) { result, error in
            if let err = error {
                print(err)
                complete(false, error, nil)
                return
            } else {
                if let user = result?.user {
                    complete(true, nil, user.uid)
                }
            }
        }
    }

    
    // MARK: - Create account

    func createAccount(phone: String, code: String, name: String, username: String, email: String, pwd: String, complete: @escaping (Bool, Error?) -> Void) {
        let defaults = UserDefaults.standard
        
        let credential: PhoneAuthCredential = PhoneAuthProvider.provider().credential(withVerificationID: defaults.string(forKey: "authVerificationID")!, verificationCode: code)
        
        Auth.auth().signIn(with: credential) { result, error in
            if let err = error {
                complete(false, err)
                return
            } else {
                if let user = result?.user {
                    let emailCredential = EmailAuthProvider.credential(withEmail: email, password: pwd)
                    // Link phone with email credential
                    user.link(with: emailCredential, completion: { _, error in
                        if let err = error {
                            print("Error:", err.localizedDescription)
                        } else {
                            let changeRequest = user.createProfileChangeRequest()
                            changeRequest.displayName = name
                            // Commit change to profile
                            changeRequest.commitChanges { error in
                                // Create user profile link
                                DataService.shared.createLink(Id: user.uid, completion: { success, error, link in
                                    let data: [String: Any] = ["phone": phone, "email": email, "name": name, "username": username, "link": link]
                                                                        
                                    // Save user data
                                    DataService.shared.saveUserData(user.uid, data, complete: { success, error in
                                        if !success {
                                            print(" SAVING:", error!.localizedDescription)
                                            complete(false, error)
                                        } else {
                                            // Save Auth link
                                            DataService.shared.authLink(username: username, email: email)
                                            complete(true, nil)
                                        }
                                    })
                                })
                            }
                        }
                    })
                }
            }
        }
    }
}
