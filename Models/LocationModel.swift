import Foundation

struct LocationModel : Identifiable, Hashable {
    let id = UUID()
    let title: String
    let subtitle: String
}
