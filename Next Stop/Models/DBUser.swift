import Foundation

struct DBUser : Codable {
    let userId: String
    let email: String?
    let photoURL: String?
    let displayName: String?
    let dateCreated : Date?
    
    init(userId: String, email: String?, photoURL: String?, displayName: String?, dateCreated: Date?) {
        self.userId = userId
        self.email = email
        self.photoURL = photoURL
        self.displayName = displayName
        self.dateCreated = dateCreated
    }
    
    init(user: AuthDataResultModel) {
        self.userId = user.uid
        self.email = user.email
        self.photoURL = user.photoURL
        self.displayName = user.displayName
        self.dateCreated = Date()
    }

}
