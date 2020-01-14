//
//  DataService.swift
//  Flaint
//
//  Created by Kerby Jean on 7/10/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import FirebaseDynamicLinks
import SwiftKeychainWrapper

class DataService {
    
    static let shared = DataService()
    
    // MARK: - Firebase Refs
    
    var RefBase: DatabaseReference {
        return Database.database().reference()
    }
    
    var RefUsers: DatabaseReference {
        return Database.database().reference().child("users")
    }
    
    var RefArts: DatabaseReference {
        return Database.database().reference().child("arts")
    }
    
    var RefUsernames: DatabaseReference {
        return Database.database().reference().child("usernames")
    }
    
    var RefUsernameAuthLink: DatabaseReference {
        return Database.database().reference().child("usernameAuthLink")
    }
    
    var RefStorage: StorageReference {
        return Storage.storage().reference()
    }
    
    
    // MARK: - Handle refs
    
    var artsRef: DatabaseReference!
    var artsRefHandle: DatabaseHandle!
    let session = URLSession(configuration: .default)
    
    private var handle: AuthStateDidChangeListenerHandle!

    
    
    // MARK: - Save User Data
    
    func saveUserData(_ userId: String, _ data: [String : Any], complete: @escaping (Bool, Error?) -> ()) {
        RefUsers.child(userId).setValue(data) { (error, ref) in
            if let err = error {
                print("error:", err.localizedDescription)
                complete(false, err)
            } else {
                complete(true, nil)
            }
        }
    }
    
    // MARK: - Update user data
    
    func updateUserData(_ name: String, _ email: String, _ phone: String, _ image: UIImage, complete: @escaping (Bool, Error?) -> ()) {
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            handle = Auth.auth().addStateDidChangeListener { (auth, user) in
                if let user = user, let password = KeychainWrapper.standard.string(forKey: "pwd") {
                    let credential = EmailAuthProvider.credential(withEmail: user.email!, password: password)
                    user.reauthenticate(with: credential, completion:  { (result, error) in
                        if let error = error {
                            complete(false, error)
                        } else {
                            let ref = DataService.shared.RefStorage.child("profile_images").child(user.uid)
                            self.saveImg(ref, user.uid, imageData, { (url, success, error) in
                                if !success {
                                    complete(false, error)
                                } else {
                                    if let url = url {
                                        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                                        changeRequest?.displayName = name
                                        changeRequest?.photoURL = URL(string: url)
                                        changeRequest?.commitChanges { (error) in
                                            if let err = error  { complete(false, err) }
                                            let data = ["imgUrl": url, "name": name] as [String : Any]
                                            self.RefUsers.child(user.uid).updateChildValues(data, withCompletionBlock: { (error, ref) in
                                                if let error = error {
                                                    complete(false, error)
                                                } else {
                                                    complete(true, nil)
                                                }
                                            })
                                        }
                                    }
                                }
                            })
                        }
                    })
                }
            }
        }
    }
    
    
    // MARK: - Save/Check Username
    
    func saveUsername(_ username: String) {
        RefUsernames.updateChildValues([username: true])
    }
    
    func updateUsernameAuth(_ username: String) {
        if let email = KeychainWrapper.standard.string(forKey: "email") {
            // Add new username
            self.RefUsernameAuthLink.updateChildValues([username: email])
        }
    }
    
    func removeUsername(username: String) {
        // Look for user current username
        // Remove username
        RefUsernames.child("username").removeValue()
        // Remove Auth username
                
        if !username.isEmpty {
            RefUsernameAuthLink.child(username).removeValue()
        }
    }
    
    
    func checkUsername(_ username: String, complete: @escaping (Bool) -> ()) {
        RefUsernames.child(username).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                // Username taken
                complete(false)
            } else {
                // Username not taken
                complete(true)
            }
        }
    }
    
    func authLink(username: String, email: String) {
        RefUsernameAuthLink.updateChildValues([username: email])
    }

    
    // MARK: - Get user email
    
    func retrieveUserEmail(_ username: String, complete: @escaping (Bool, String?) -> ()) {
        Database.database().reference().child("usernameAuthLink/\(username)").observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                let details = snapshot.value as! String
                complete(true, details)
            } else {
                complete(false, nil)
            }
        }
    }
    
    // MARK: - Fetch current user
    
    func fetchCurrentUser(userID: String?, complete: @escaping (Bool, Error?, Users) -> ()) {
        guard let id = Auth.auth().currentUser?.uid else {return}
        RefUsers.child(id).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let value = snapshot.value else {return}
            let postDict = value as? [String : AnyObject] ?? [:]
            let key = snapshot.key
            let user = Users(key: key, data: postDict)
            complete(true, nil, user)
        })
    }
    
    
    // MARK: - Fetch current user arts
    
    func fetchCurrentUserArt(complete: @escaping (Bool, Error?, Art?) -> ()) {
        guard let id = UserDefaults.standard.string(forKey: "userId") else {return}
         RefArts.child(id).observeSingleEvent(of: .value) { (snapshot) in
            self.RefArts.keepSynced(true)
            if snapshot.exists() {
                let enumerator = snapshot.children
                while let rest = enumerator.nextObject() as? DataSnapshot {
                    let key = rest.key
                    let data = rest.value as?  [String : AnyObject]
                    let art = Art(key: key, data: data!)
                    complete(true, nil, art)
                }
            } else {
                complete(false, nil, nil)
            }
        }
    }
    
    // MARK: - Add Art
    
    func saveImg(_ ref: StorageReference, _ userID: String, _ data: Data, _ completion: @escaping (_ url: String?, _ success: Bool, _ error: Error?) -> ()) {
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        ref.putData(data, metadata: metadata) { (metadata, error) in
            if error != nil {
                print("Couldn't Upload Image")
            } else {
                print("Uploaded")
                ref.downloadURL(completion: { (url, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    if url != nil {
                        completion(url!.absoluteString, true, nil)
                    }
                })
            }
        }
    }
    
    // MARK: - Save Art
    
    func saveArt(userID: String, artId: String, values: [String: Any], imgData: Data,  _ completion: @escaping (_ success: Bool, _ error: Error?) -> ()) {
        let ref = RefArts.child(userID).child(artId)
        DispatchQueue.global(qos: .background).async {
            self.createLink(Id: artId, completion: { (success, error, url) in
                ref.updateChildValues(["url": url])
            })
        }
        ref.updateChildValues(values) { (error, ref) in
            if let error = error {
                print("error:", error.localizedDescription)
                completion(false, error)
            } else {
                let style = values["style"] as! String
                self.RefBase.child(style.lowercased()).child(artId).updateChildValues(values)
                completion(true, nil)
            }
        }
    }
    
    // MARK: - Edit Art
    
    func editArt(userId: String, artId: String, data: [String: Any],  _ completion: @escaping (_ success: Bool, _ error: Error?) -> ()) {
        DataService.shared.RefArts.child(userId).child(artId).updateChildValues(data) { (error, ref) in
            if let error = error {
                print("error:", error.localizedDescription)
                completion(false, error)
            } else {
                completion(true, nil)
            }
        }
    }
    
    // MARK: - Delete Art

    func deleteArt(userId: String, artId: String,  _ completion: @escaping (_ success: Bool, _ error: Error?) -> ()) {
        DataService.shared.RefArts.child(userId).child(artId).removeValue { (error, ref) in
            if let error = error {
                print("error: ", error.localizedDescription)
                completion(false, error)
            } else {
                completion(true, nil)
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    // MARK: - Create Link
    
    func createLink(Id: String, completion: @escaping ( _ success: Bool, _ error: Error?, _ link: String)->() ) {
        guard let link = URL(string: "https://www.flaintapp.com/?id=\(Id)") else { return }
        let dynamicLinksDomainURIPrefix = "https://flaint"
        let linkBuilder = DynamicLinkComponents(link: link, domainURIPrefix: dynamicLinksDomainURIPrefix)
        linkBuilder?.iOSParameters = DynamicLinkIOSParameters(bundleID: "com.Kurbs.Flaint")
        guard let longDynamicLink = linkBuilder?.url else { return }
        print("The long URL is: \(longDynamicLink.absoluteString)")
        
        completion(true, nil,longDynamicLink.absoluteString)
    }
}

