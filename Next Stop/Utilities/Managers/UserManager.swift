import Foundation
import FirebaseFirestore

protocol UserManagerProtocol {
    func getUser(userId: String) async throws -> DBUser
    func createNewUser(user: DBUser) async throws
    func updateUserBiography(userId: String, biography: String ) async throws
    func updatePreferences(userId: String, preference: String) async throws
    func removePreferences(userId: String, preference: String) async throws
    func updateLanguages(userId: String, language: String) async throws
    func removeLanguages(userId: String, language: String) async throws
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
    
    func updateLanguages(userId: String, language: String) async throws {
        let data: [String : Any] = [
            DBUser.CodingKeys.languages.rawValue : FieldValue.arrayUnion([language])
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
    func removeLanguages(userId: String, language: String) async throws {
        let data: [String : Any] = [
            DBUser.CodingKeys.languages.rawValue : FieldValue.arrayRemove([language])
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
}
