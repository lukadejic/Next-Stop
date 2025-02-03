import Foundation

class DestinationsService {
    func fetchDestinations(query:String) async throws -> [Destination] {
        let parameters = ["query" : query]
        
        let response : Response = try await NetworkManager.shared.fetchData(
            endpoint: "hotels/searchDestination",
            parameters: parameters)
        
        return response.data
    }
}
