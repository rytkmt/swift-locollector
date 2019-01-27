import RealmSwift
import MapKit
class Location: Object {
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0
    @objc dynamic var title: String = ""
    @objc dynamic var createdAt = Date()
    
    static func create(title: String, latitude: Double, longitude: Double) -> Location {
        let location = Location()
        location.title = title
        location.latitude = latitude
        location.longitude = longitude
        location.createdAt = Date()
        return location
    }
}
