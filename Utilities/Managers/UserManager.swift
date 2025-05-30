import FirebaseFirestore
import FirebaseStorage

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
    func updatePets(userId: String, pets: String) async throws
    func updateUserInterests(userId: String, interests: [Interest]) async throws
    func updateUserProfilePicture(userId: String, picture: UIImage) async throws
    func updateUser(userId: String, with data: [String: Any]) async throws
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
    
    func updatePets(userId: String, pets: String) async throws {
        let data: [String : Any] = [
            DBUser.CodingKeys.pets.rawValue : pets
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
    func updateUserInterests(userId: String, interests: [Interest]) async throws {
        let interestsData: [[String: Any]] = interests.map { interest in
            [
                "icon": interest.icon,
                "name": interest.name
            ]
        }
        
        let data: [String: Any] = [
            DBUser.CodingKeys.interests.rawValue: interestsData
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
    func updateUserProfilePicture(userId: String, picture: UIImage) async throws {
        let storageRef = Storage.storage().reference()
        let imageRef = storageRef.child("profile_pictures/\(userId).jpg")

        guard let imageData = picture.jpegData(compressionQuality: 0.8) else {
            throw URLError(.badURL)
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let _ = try await imageRef.putDataAsync(imageData, metadata: metadata)
        
        let downloadURL = try await imageRef.downloadURL()
        let photoURL = downloadURL.absoluteString
        
        let data: [String: Any] = [
            DBUser.CodingKeys.photoURL.rawValue: photoURL
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
    func updateUser(userId: String, with data: [String: Any]) async throws {
        try await userDocument(userId: userId).updateData(data)
    }

}
