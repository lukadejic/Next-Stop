import Foundation
import MapKit

enum SearchStatus : Equatable {
    case idle
    case searching
    case error(String)
    case result
}

class LocationSearchService : NSObject {
    
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
        
        //completer.delegate = self
        completer.pointOfInterestFilter = filter
        completer.region = region
        completer.resultTypes = types
    }
    
    func handleSearchFragment(_ fragment: String) {
        status = .searching
        
        if !fragment.isEmpty {
            self.completer.queryFragment = fragment
        }else{
            status = .idle
            results = []
        }
    }
    
}



