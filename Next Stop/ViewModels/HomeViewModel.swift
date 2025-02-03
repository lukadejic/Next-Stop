import Foundation

class HomeViewModel : ObservableObject {
    @Published var destinations : [Destination] = []
    
    private let destinationService : DestinationsService
    
    init(destinationService: DestinationsService) {
        self.destinationService = destinationService
    }
    
    func getDestinations(query: String) {
        Task{
            do{
                print("fetching destinations")
                destinations = try await destinationService.fetchDestinations(query: query)
                print(destinations)
            }catch{
                throw error
            }
        }
    }
    
}
