import Foundation
import FirebaseAuth

struct AuthDataResultModel : Equatable{
    let uid : String
    let email: String?
    let photoURL: String?
    var displayName: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoURL = user.photoURL?.absoluteString
        self.displayName = user.displayName
    }
}
