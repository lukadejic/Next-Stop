import Foundation

struct Interest: Identifiable, Codable {
    var id: UUID
    let icon: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case id, icon, name
    }
    
    init(id: UUID = UUID(), icon: String, name: String) {
        self.id = id
        self.icon = icon
        self.name = name
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.icon = try container.decode(String.self, forKey: .icon)
        self.name = try container.decode(String.self, forKey: .name)
        self.id = (try? container.decode(UUID.self, forKey: .id)) ?? UUID()
    }
}
