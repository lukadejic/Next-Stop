import SwiftUI
import MapKit

struct MapView: View {
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    let annotationName: String
    
    @State private var isShowingLookAround = false
    @State private var lookAroundScene : MKLookAroundScene?
    @State private var route: MKRoute?
    @State private var selectedLocation : CLLocationCoordinate2D?
    @State private var mapSelection : MKMapItem?
    @State private var showLocationDetails = false
    
    var cameraPositon : MapCameraPosition {
        .region(.init(center: .init(latitude: latitude, longitude: longitude), latitudinalMeters: 1200, longitudinalMeters: 1200))
    }
    
    var body: some View {
        MapReader{ reader in
            Map(initialPosition: cameraPositon,selection: $mapSelection) {
                Annotation(annotationName, coordinate: .init(latitude: latitude, longitude: longitude)) {
                    Image(systemName: "mappin")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .padding(7)
                        .background(.red.gradient, in: .circle)
                        .foregroundStyle(.white)
                        .contextMenu {
                            Button("Look Around", systemImage: "binoculars") {
                                Task {
                                    lookAroundScene = await getLookAroundSceen(from: .panamaPark)
                                    isShowingLookAround = true
                                }
                            }
                        }
                }
                
                if let selectedLocation {
                    Annotation("", coordinate: selectedLocation) {
                        Image(systemName: "mappin")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .padding(7)
                            .background(.red.gradient, in: .circle)
                            .foregroundStyle(.white)
                            .contextMenu {
                                Button("Look Around", systemImage: "binoculars") {
                                    Task {
                                        lookAroundScene = await getLookAroundSceen(from: .panamaPark)
                                        isShowingLookAround = true
                                    }
                                }
                                
                                Button("Get Directions", systemImage: "arror.turn.down.right") {
                                    getDirections(to:selectedLocation )
                                }
                            }
                    }
                    
                }
                
                if let route {
                    MapPolyline(route)
                        .stroke(Color.blue,lineWidth: 5)
                }
            }
            .onTapGesture { screenCoordinate in
                Task {
                    let newLocation = reader.convert(screenCoordinate, from: .global)
                
                    guard let validLocation = newLocation else {
                        return
                    }
                
                    selectedLocation = validLocation
                    
                    reverseGeocode(location: validLocation) { mapItem in
                        mapSelection = mapItem
                        showLocationDetails = (mapItem != nil)
                    }
                }
            }


            .mapControls {
                MapCompass()
                MapPitchToggle()
                MapScaleView()
            }
            .mapStyle(.standard(elevation: .realistic))
            .lookAroundViewer(isPresented: $isShowingLookAround, scene: $lookAroundScene)
            .sheet(isPresented: $showLocationDetails) {
                LocationDetailsView(mapSelection: $mapSelection, show: $showLocationDetails)
                    .presentationDetents([.height(340)])
                    .presentationBackgroundInteraction(.enabled(upThrough: .height(340)))
                    .presentationCornerRadius(12)
            }
        }
    }
}

#Preview {
    MapView(latitude: 37.347730, longitude: -122.018715, annotationName: "Panama Park")
}

private extension MapView {
    
    func getLookAroundSceen(from coordinate: CLLocationCoordinate2D) async -> MKLookAroundScene? {
        do{
            return try await MKLookAroundSceneRequest(coordinate: coordinate).scene
        }catch{
            print("Cannot retrive Look Around Scene: \(error.localizedDescription)")
            return nil
        }
    }
    
    func getDirections(to destination: CLLocationCoordinate2D) {
        Task {
            let startLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: .init(coordinate: startLocation))
            
            request.destination = MKMapItem(placemark: .init(coordinate: destination))
            
            request.transportType = .automobile
            
            do{
                let direction = try await MKDirections(request: request).calculate()
                route = direction.routes.first
            }catch{
                print("Error while trying to get destination: \(error.localizedDescription)")
            }
        }
    }
    
    func reverseGeocode(location: CLLocationCoordinate2D, completion: @escaping (MKMapItem?) -> Void) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: location.latitude, longitude: location.longitude)
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first, error == nil else {
                print("Reverse geocoding failed: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            
            let mkPlacemark = MKPlacemark(placemark: placemark)
            let mapItem = MKMapItem(placemark: mkPlacemark)
            completion(mapItem)
        }
    }

}

extension CLLocationCoordinate2D {
    static let panamaPark = CLLocationCoordinate2D(latitude: 37.347730, longitude: -122.018715)
    static let appleHQ = CLLocationCoordinate2D(latitude: 37.3346, longitude: -122.0090)
}
