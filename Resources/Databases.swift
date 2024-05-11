//
//  Databases.swift
//  Filling
//
//  Created by mac on 17.02.2024.
//

import Foundation
import FirebaseDatabase
public class Databases {
    static let shared = Databases()
    private let database = Database.database().reference()
    //Check if username and email is available
    //Parameters
    //email : string representing email
    //username :string representing usernamee
    public func canCreateNewUser(with email: String ,username : String , completion :(Bool) -> Void){
        completion(true)
        
    }
    public func insertNewUser(with email: String, username: String, completion: @escaping (Bool) -> Void) {
        let key = email.safeDatabaseKey()
        database.child(key).setValue(["email": email, "username": username]) { error,arg   in
            if let error = error {
                print("Failed to insert user:", error.localizedDescription)
                completion(false)
            } else {
                print("User inserted successfully")
                completion(true)
            }
        }
    }
}

