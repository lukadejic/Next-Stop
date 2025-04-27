import Foundation

protocol NetworkManagerProtocol {
    func fetchData <T: Codable>(endpoint: String, parameters: [String: String]) async throws -> T
}

class NetworkManager: NetworkManagerProtocol {
    
    private let baseURL = "https://booking-com15.p.rapidapi.com/api/v1/"
    private let APIKey = "7815266853msh448ccee7ce2b5d6p14c668jsn76900ab74af8"
        
    func fetchData <T: Codable>(endpoint:String, parameters: [String: String]) async throws -> T{
        guard var urlComponents = URLComponents(string: baseURL + endpoint) else {
            throw URLError(.badURL)
        }
        
        urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value)}
        
        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10.0
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(APIKey, forHTTPHeaderField: "x-rapidapi-key")
        request.addValue("booking-com15.p.rapidapi.com", forHTTPHeaderField: "x-rapidapi-host")
        
        let(data,_) = try await URLSession.shared.data(for: request)

        do{
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        }catch{
            print("Error while decoding response data: \(error.localizedDescription)")
            throw error
        }
    }
}
