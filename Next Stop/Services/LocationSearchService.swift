import Foundation
import MapKit

protocol LocationSearchServiceProtocol {
    func handleSearchFragment(_ fragment: String)
}

enum SearchStatus : Equatable {
    case idle
    case searching
    case error(String)
    case result
}
@Observable
class LocationSearchService : NSObject, LocationSearchServiceProtocol {
    
    var query: String = "" {
        didSet {
            handleSearchFragment(query)
        }
    }
    
    var results: [LocationModel] = []
    var status : SearchStatus = .idle
    
    var completer: MKLocalSearchCompleter
    
    init(filter: MKPointOfInterestFilter = .excludingAll,
         region: MKCoordinateRegion = MKCoordinateRegion(.world),
         types: MKLocalSearchCompleter.ResultType = [.pointOfInterest, .query, .address]) {
        
        completer = MKLocalSearchCompleter()
        
        super.init()
        
        completer.delegate = self
        completer.pointOfInterestFilter = filter
        completer.region = region
        completer.resultTypes = types
    }
    
    func handleSearchFragment(_ fragment: String) {
        status = .searching
        
        if !fragment.isEmpty {
            self.completer.queryFragment = fragment
        } else {
            status = .idle
            results = []
        }
    }
    
}



