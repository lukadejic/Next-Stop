import Foundation

struct Destination : Codable, Identifiable , Equatable{
    let id = UUID()
    let destID: String
    let searchType: String
    let cityName: String
    let label: String
    let roundtrip: String
    let imageURL: String
    let country: String
    let nrHotels: Int
    let region: String
    let destType: String
    let cc1: String
    let longitude: Double
    let lc: String
    let latitude: Double
    let hotels: Int
    let cityUfi: Int?
    let name: String
    var query: String?
    
    enum CodingKeys: String, CodingKey {        
        case destID = "dest_id"
        case searchType = "search_type"
        case cityName = "city_name"
        case label, roundtrip, imageURL = "image_url"
        case country, nrHotels = "nr_hotels", region, destType = "dest_type"
        case cc1, longitude, lc, latitude, hotels
        case cityUfi = "city_ufi"
        case name, query
    }
}

struct Response: Codable {
    let status: Bool
    let message : String
    let timestamp : Int
    let data: [Destination]
}
