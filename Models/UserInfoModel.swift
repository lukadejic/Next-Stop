import Foundation

struct UserInfo: Identifiable {
    var id = UUID()
    var icon: String
    var text: String
    var info: String
    var itemType: UserInfoItem
    
    init(icon: String, text: String, info: String, itemType: UserInfoItem) {
        self.icon = icon
        self.text = text
        self.info = info
        self.itemType = itemType
    }
}
