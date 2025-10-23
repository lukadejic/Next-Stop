import Foundation

struct Destination : Codable, Identifiable , Equatable {
    let id = UUID()
    let destType: String?
    let cc1: String?
    let cityName: String?
    let label: String?
    let longitude: Double?
    let latitude: Double?
    let type: String?
    let region: String?
    let cityUfi: Int?
    let name: String?
    let roundtrip: String?
    let country: String?
    let imageurl: String?
    let destid: String?
    let nrHotels: Int?
    let lc: String?
    let hotels: Int?
    var query: String?
    
    enum CodingKeys: String, CodingKey {
        case destType = "dest_type"
        case cc1 = "cc1"
        case cityName = "city_name"
        case label = "label"
        case longitude = "longitude"
        case latitude = "latitude"
        case type = "type"
        case region = "region"
        case cityUfi = "city_ufi"
        case name = "name"
        case roundtrip = "roundtrip"
        case country = "country"
        case imageurl = "image_url"
        case destid = "dest_id"
        case nrHotels = "nr_hotels"
        case lc = "lc"
        case hotels = "hotels"
    }
}

struct Response: Codable {
    let status: Bool?
    let message : String?
    let timestamp : Int?
    let data: [Destination]?
}
