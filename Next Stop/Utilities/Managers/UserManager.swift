import Foundation
import FirebaseFirestore

protocol UserManagerProtocol {
    func getUser(userId: String) async throws -> DBUser
    func createNewUser(user: DBUser) async throws
    func updateUserBiography(userId: String, biography: String ) async throws
    func updatePreferences(userId: String, preference: String) async throws
    func removePreferences(userId: String, preference: String) async throws
    func updateLanguages(userId: String, languages: [String]) async throws
    func updateObsessed(userId: String, text: String) async throws
    func updateLocation(userId: String, location: String) async throws
    func updateWork(userId: String, work: String) async throws
}

final class UserManager : UserManagerProtocol {
    
    private let userCollection = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    func createNewUser(user: DBUser) async throws {
        try userDocument(userId: user.userId).setData(from: user,
                                                      merge: false)
    }
    
    func getUser(userId: String) async throws -> DBUser {
        try await userDocument(userId: userId).getDocument(as: DBUser.self)
    }
    
    func updateUserBiography(userId: String, biography: String) async throws {
        let data: [String : Any] = [
            DBUser.CodingKeys.biography.rawValue : biography
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
    func updatePreferences(userId: String, preference: String) async throws {
        let data: [String : Any] = [
            DBUser.CodingKeys.preferences.rawValue : FieldValue.arrayUnion([preference])
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
    func removePreferences(userId: String, preference: String) async throws {
        let data: [String : Any] = [
            DBUser.CodingKeys.preferences.rawValue : FieldValue.arrayRemove([preference])
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
    func updateLanguages(userId: String, languages: [String]) async throws {
        let data: [String : Any] = [
            DBUser.CodingKeys.languages.rawValue : languages
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
    func updateObsessed(userId: String, text: String) async throws {
        let data: [String : Any] = [
            DBUser.CodingKeys.obsessed.rawValue : text
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
    func updateLocation(userId: String, location: String) async throws {
        let data: [String : Any] = [
            DBUser.CodingKeys.location.rawValue : location
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
    func updateWork(userId: String, work: String) async throws {
        let data: [String : Any] = [
            DBUser.CodingKeys.work.rawValue : work
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
}
