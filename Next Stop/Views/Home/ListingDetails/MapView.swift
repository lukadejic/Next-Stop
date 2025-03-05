import SwiftUI
import MapKit

struct MapView: View {
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    let annotationName: String
    @State private var cameraPositon: MapCameraPosition
    
    init(latitude: CLLocationDegrees, longitude: CLLocationDegrees, annotationName: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.annotationName = annotationName
        
        _cameraPositon = State(initialValue: .region(.init(center: .init(latitude: latitude, longitude: longitude), latitudinalMeters: 10000, longitudinalMeters: 10000)))
    }
    
    var body: some View {
        MapReader{ reader in
            Map(initialPosition: cameraPositon) {
                Annotation(annotationName, coordinate: .init(latitude: latitude, longitude: longitude)) {
                    Image(systemName: "mappin")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .padding(7)
                        .background(.red.gradient, in: .circle)
                        .foregroundStyle(.white)
                }
            }
            .mapControls {
                MapCompass()
                MapPitchToggle()
                MapScaleView()
            }
            .mapStyle(.standard(elevation: .realistic))
        }
    }
}

#Preview {
    MapView(latitude: 37.347730, longitude: -122.018715, annotationName: "Panama Park")
}

extension CLLocationCoordinate2D {
    static let panamaPark = CLLocationCoordinate2D(latitude: 37.347730, longitude: -122.018715)
    static let appleHQ = CLLocationCoordinate2D(latitude: 37.3346, longitude: -122.0090)
}
