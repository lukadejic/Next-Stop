import Foundation

class HotelsService {
    func fetchDestinations(query:String) async throws -> [Destination] {
        let parameters = ["query" : query]
        
        let response : Response = try await NetworkManager.shared.fetchData(
            endpoint: "hotels/searchDestination",
            parameters: parameters)
        
        return response.data
    }
    
    func fetchHotels(for destination: Destination) async throws -> [Hotel] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let arivalDate = dateFormatter.string(from: Date())
        let departureDate = dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date())
        
        let parameters : [String: String] = [
            "dest_id": "\(destination.destID)",
            "search_type" : "\(destination.searchType)",
            "arrival_date" : "\(arivalDate)",
            "departure_date" : "\(departureDate)"
        ]
        
        let response : HotelsResponse = try await NetworkManager.shared.fetchData(
            endpoint: "hotels/searchHotels",
            parameters: parameters)
        
        return response.data.hotels
    }
}
