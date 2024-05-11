//
//  AuthManager.swift
//  Filling
//
//  Created by mac on 17.02.2024.
//

import Foundation
import FirebaseAuth

public class AuthManager {
    static let shared = AuthManager()
    public func signupNewUser(username : String, email : String , password : String, completion :@escaping (Bool) -> Void){
        //Check if username is available
        //Check if email is available
        //Create account
        //Insert account to database
        Databases.shared.canCreateNewUser(with: email, username: username){canCreate in
            if canCreate{
                Auth.auth().createUser(withEmail: email, password: password){
                    result, error in
                    guard error == nil , result != nil else {
                        completion(false)
                        return
                    }
                    Databases.shared.insertNewUser(with: email, username: username){
                        inserted in
                        if inserted {
                            completion(true)
                            return
                        }
                    }
                }
            }
            else {
                    completion(false)
                }
            }
        }
    
    public func loginUser(username : String? ,email : String? , password: String?,completion :@escaping ((Bool) -> Void)){
        if let email = email {
            Auth.auth().signIn(withEmail: email, password: password!) {authResult, error in
                guard authResult != nil ,error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            }
            
        }
        else if let username = username{
            print(username)
        }
    }
    public  func logOut(completion: (Bool) ->Void) {
        
        do {
            try Auth.auth().signOut()
            completion(true)
            return
        }
        catch {
            print(error)
            completion(false)
            return
        }
    }
    
}
