//
//  Storage.swift
//  Filling
//
//  Created by mac on 17.02.2024.
//

import FirebaseStorage
import Foundation
public class Storage {
    static let shared = Storage()
    let bucket = Storage.storage().reference()
    public func uploadUserPhoto(model:Post, completion:(Result<URL, Error>) -> Void){
        
        
    }
    public func downloadImage(with reference: String ,completion:(Result<URL, Error>) -> Void){
        
    }
    
    public enum userPostType {
        case photo,type
    }
}
struct Post {
    
}
