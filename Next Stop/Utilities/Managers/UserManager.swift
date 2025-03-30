import Foundation
import FirebaseFirestore

protocol UserManagerProtocol {
    func getUser(userId: String) async throws -> DBUser
    func createNewUser(user: DBUser) async throws
    func updateUserBiography(userId: String, biography: String ) async throws
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
}
