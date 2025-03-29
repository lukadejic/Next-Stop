import Foundation
import FirebaseFirestore

protocol UserManagerProtocol {
    func createUser(auth: AuthDataResultModel) async throws
}

final class UserManager : UserManagerProtocol {
    
    func createUser(auth: AuthDataResultModel) async throws {
        
        var userData: [String : Any] = [
            "user_id" : auth.uid ,
            "date_created" : Timestamp()
        ]
        
        if let email = auth.email {
            userData["email"] = email
        }
        
        if let photoURL = auth.photoURL {
            userData["photo_url"] = photoURL
        }
        
        if let displayName = auth.displayName {
            userData["display_name"] = displayName
        }
        
        try await Firestore.firestore().collection("users").document(auth.uid).setData(userData, merge: false)
    }
}
