import Foundation
import FirebaseFirestore

protocol UserManagerProtocol {
    func createUser(auth: AuthDataResultModel) async throws
    func getUser(userId: String) async throws -> DBUser
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
    
    func getUser(userId: String) async throws -> DBUser {
        let snapshot =  try await Firestore.firestore().collection("users").document(userId).getDocument()

        guard let data = snapshot.data() else {
            throw DBUserError.noData
        }
        
        guard let userId = data["user_id"] as? String else {
            throw DBUserError.noUserId
        }
        
        let dateCreated = data["date_created"] as? Date
        let displayName = data["display_name"] as? String
        let email = data["email"] as? String
        let photoURL = data["photo_url"] as? String
        
        return DBUser(userId: userId, email: email, photoURL: photoURL,
                      displayName: displayName, dateCreated: dateCreated)
    }
}
