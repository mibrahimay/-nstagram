import FirebaseStorage
import Foundation

public class StorageController {
    static let shared = StorageController()

    private let bucket = Storage.storage().reference()

    public enum IGStorageManagerError: Error {
        case failedToDownload
    }


    internal func uploadUserPost(model: Userpost, completion: @escaping (Result<URL, Error>) -> Void) {

    }

    public func downloadImage(with reference: String, completion: @escaping (Result<URL, IGStorageManagerError>) -> Void) {
        bucket.child(reference).downloadURL(completion: { url, error in
            guard let url = url, error == nil else {
                completion(.failure(.failedToDownload))
                return
            }

            completion(.success(url))
        })
    }

}
