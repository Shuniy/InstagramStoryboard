//
//  DatabaseManager.swift
//  InstagramStoryboard
//
//  Created by Shubham Kumar on 25/02/22.
//

import FirebaseDatabase

public class DatabaseManager {
    static let shared = DatabaseManager()
    private let database = Database.database().reference()
    
    //MARK: - Public
    /// Check if username and email is available
    /// - Parameters
    ///     - email: String representing email
    ///     - username: String representing username
    public func canCreateNewUser(with email:String, username:String, completion: @escaping (Bool) -> Void) {
        completion(true)
    }
    /// Insert user into database
    /// - Parameters
    ///     - email: String representing email
    ///     - username: String representing username
    ///     - completion: async callback to result
    public func insertNewUser(with email:String, username:String, completion: @escaping (Bool) -> Void) {
        database.child(email.safeDatabaseKey()).setValue(["username":username]) { error, _ in
            if error == nil {
                completion(true)
                return
            } else {
                completion(false)
                return
            }
        }
    }
    
}
