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

class DataService {
    
    static let shared = DataService()
    
    // MARK: - Firebase Refs
    
    var RefBase: DatabaseReference {
        Database.database().reference()
    }
    
    var RefUsers: DatabaseReference {
        Database.database().reference().child("users")
    }
    
    var RefArts: DatabaseReference {
        Database.database().reference().child("arts")
    }
    
    var RefUsernames: DatabaseReference {
        Database.database().reference().child("usernames")
    }
    
    var RefUsernameAuthLink: DatabaseReference {
        Database.database().reference().child("usernameAuthLink")
    }
    
    var RefStorage: StorageReference {
        Storage.storage().reference()
    }
    
    
    // MARK: - Handle refs
    
    var artsRef: DatabaseReference!
    var artsRefHandle: DatabaseHandle!
    
    private var handle: AuthStateDidChangeListenerHandle!
    
    typealias completion = Result<Any?, Error>
    
    
    // MARK: - Functions 
    
    // Save User Data
    func saveUserData(_ userId: String, _ data: [String: Any], complete: @escaping (Bool, Error?) -> Void) {
        RefUsers.child(userId).setValue(data) { error, _ in
            if let error = error {
                NSLog("Error saving user data: \(error)")
                complete(false, error)
            } else {
                complete(true, nil)
            }
        }
    }
    
    // Update user data
    func updateUserData(_ userId: String, _ name: String, _ image: UIImage, complete: @escaping (Bool, Error?) -> Void) {
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            
            let ref = DataService.shared.RefStorage.child("profile_images").child(userId)
            self.saveImg(ref, userId, imageData, { result in
                
                if let url = try? result.get() as? String {
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = name
                    changeRequest?.photoURL = URL(string: url)
                    changeRequest?.commitChanges { error in
                        if let err = error { complete(false, err) }
                        let data = ["imgUrl": url, "name": name] as [String: Any]
                        self.RefUsers.child(userId).updateChildValues(data, withCompletionBlock: { error, _ in
                            if let error = error {
                                complete(false, error)
                            } else {
                                complete(true, nil)
                            }
                        })
                    }
                }
            })
        }
    }
    
    
    // Save/Check Username
    func saveUsername(_ username: String) {
        RefUsernames.updateChildValues([username: true])
    }
    
    func updateUsernameAuth(_ username: String) {
        if let email = UserDefaults.standard.string(forKey: "email") {
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
    
    
    func checkUsername(_ username: String, complete: @escaping (Bool) -> Void) {
        RefUsernames.child(username).observeSingleEvent(of: .value) { snapshot in
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
    
    
    // Get user email
    func retrieveUserEmail(_ username: String, complete: @escaping (Bool, String?) -> Void) {
        Database.database().reference().child("usernameAuthLink/\(username)").observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                let details = snapshot.value as! String
                complete(true, details)
            } else {
                complete(false, nil)
            }
        }
    }
    
    // Fetch current user
    func fetchCurrentUser(userID: String?, completion: @escaping (completion) -> Void) {
        guard let id = Auth.auth().currentUser?.uid else { return }
        RefUsers.child(id).observeSingleEvent(of: .value, with: { snapshot in
            let key = snapshot.key
            guard let data = snapshot.data else { return }
            let decoder = JSONDecoder()
            do {
                let user = try decoder.decode(Users.self, from: data)
                user.userId = key
                completion(.success(user))
            } catch {
                completion(.failure(error))
            }
        })
    }
    
    
    // Fetch current user arts
    func fetchCurrentUserArt(userId: String?, complete: @escaping (completion) -> Void) {
        guard let userId = userId ?? AuthService.shared.UserID else { return }
        RefArts.child(userId).observeSingleEvent(of: .value) { snapshot in
            self.RefArts.keepSynced(true)
            if snapshot.exists() {
                let enumerator = snapshot.children
                while let rest = enumerator.nextObject() as? DataSnapshot {
                    let key = rest.key
                    guard let data = rest.data else { return }
                    let decoder = JSONDecoder()
                    do {
                        let art = try decoder.decode(Art.self, from: data)
                        art.id = key
                        complete(.success(art))
                    } catch {
                        NSLog("Error fetching current user: \(error)")
                        complete(.failure(error))
                    }
                }
            }
        }
    }
    
    // Add Art
    func saveImg(_ ref: StorageReference, _ userID: String, _ data: Data, _ completion: @escaping (completion) -> Void) {
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        ref.putData(data, metadata: metadata) { _, error in
            if error != nil {
                print("Couldn't Upload Image")
            } else {
                ref.downloadURL(completion: { url, error in
                    if error != nil {
                        NSLog("Error saving image: \(String(describing: error))")
                        return
                    }
                    if url != nil {
                        completion(.success(url!.absoluteString))
                    }
                })
            }
        }
    }
    
    // Save Art
    func createArt(userID: String, artId: String, values: [String: Any], imgData: Data, _ completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        let ref = RefArts.child(userID).child(artId)
        DispatchQueue.global(qos: .background).async {
            self.createLink(Id: artId, completion: { _, _, url in
                ref.updateChildValues(["url": url])
            })
        }
        ref.updateChildValues(values) { error, _ in
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
    
    // Edit Art
    func editArt(userId: String, artId: String, style: String, data: [String: Any], _ completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        DataService.shared.RefArts.child(userId).child(artId).updateChildValues(data) { error, _ in
            if let error = error {
                NSLog("error: \( error)")
                completion(false, error)
            } else {
                DataService.shared.RefBase.child(style).child(artId).updateChildValues(data)
                completion(true, nil)
            }
        }
    }
    
    //  Delete Art
    func deleteArt(userId: String, artId: String, artStyle: String, _ completion: @escaping (completion) -> Void = { _ in }) {
        DataService.shared.RefArts.child(userId).child(artId).removeValue { error, _ in
            if let error = error {
                NSLog("error: \(error)")
                completion(.failure(error))
            } else {
                DataService.shared.RefBase.child(artStyle.lowercased()).child(artId).removeValue { error, _ in
                    if let error = error {
                        NSLog("error: \(error)")
                        completion(.failure(error))
                    } else {
                        completion(.success(true))
                    }
                }
            }
        }
    }
    
    // Reorder arts
    func reorderArt(arts: [Art], userId: String, completion: @escaping (completion) -> Void = { _ in }) {
        for art in arts {
            guard let index = art.index else { return }
            RefArts.child(userId).child(art.id).updateChildValues(["index": index]) { error, _ in
                if let error = error {
                    NSLog("Error reordering arts: \(error)")
                    completion(.failure(error))
                    return
                }
                completion(.success(true))
            }
        }
    }
    
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    // Create Link
    func createLink(Id: String, completion: @escaping ( _ success: Bool, _ error: Error?, _ link: String) -> Void ) {
        //            guard let link = URL(string: "https://www.flaintapp.com/?id=\(Id)") else { return }
        //            let dynamicLinksDomainURIPrefix = "https://flaint"
        //            let linkBuilder = DynamicLinkComponents(link: link, domainURIPrefix: dynamicLinksDomainURIPrefix)
        //            linkBuilder?.iOSParameters = DynamicLinkIOSParameters(bundleID: "com.Kurbs.Flaint")
        //            guard let longDynamicLink = linkBuilder?.url else { return }
        //            print("The long URL is: \(longDynamicLink.absoluteString)")
        //
        //            completion(true, nil,longDynamicLink.absoluteString)
    }
}
