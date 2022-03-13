//
//  StorageManager.swift
//  InstagramStoryboard
//
//  Created by Shubham Kumar on 25/02/22.
//

import FirebaseStorage

public class StorageManager {
    static let shared = StorageManager()
    private let bucket = Storage.storage().reference()
    
    public enum IGStorageManagerError: Error {
        case failedToDownload
    }
    
    //MARK: Public
    
    public func uploadUserPhotoPost(model: UserPost, completion: @escaping (Result<URL, Error>) -> Void) {
        
    }
    
    public func downloadImage(with reference: String, completion: @escaping (Result<URL, Error>) -> Void) {
        bucket.child(reference).downloadURL { url, error in
            guard let url = url, error == nil else {
                completion(.failure(IGStorageManagerError.failedToDownload))
                return
            }
            completion(.success(url))
        }
    }
    
}
