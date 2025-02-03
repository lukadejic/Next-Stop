import Foundation

struct Destination : Codable {
    let destType, cc1, cityName, label: String?
    let longitude, latitude: Double?
    let type, region: String?
    let cityUfi: Int?
    let name, roundtrip, country: String?
    let imageURL: String?
    let destID: String?
    let nrHotels: Int?
    let lc: String?
    let hotels: Int?

    enum CodingKeys: String, CodingKey {
        case destType = "dest_type"
        case cc1
        case cityName = "city_name"
        case label, longitude, latitude, type, region
        case cityUfi = "city_ufi"
        case name, roundtrip, country
        case imageURL = "image_url"
        case destID = "dest_id"
        case nrHotels = "nr_hotels"
        case lc, hotels
    }
}
