import Foundation

func stayDate(arrivalDate: String?, departureDate: String?) -> String {
    
    guard let arrival = arrivalDate, let departure = departureDate else { return "unknow"}
    
    let inputFormater = DateFormatter()
    inputFormater.dateFormat = "yyyy-MM-dd"
    inputFormater.locale = Locale(identifier: "en_US_POSIX")
    
    let outputFormater = DateFormatter()
    outputFormater.dateFormat = "d"
    
    let monthFormater = DateFormatter()
    monthFormater.dateFormat = "MMM"
    
    if let arrivalDate = inputFormater.date(from: arrival),
       let departureDate = inputFormater.date(from: departure){
        
        let arrivalDay = outputFormater.string(from: arrivalDate)
        let departureDay = outputFormater.string(from: departureDate)
        let month = monthFormater.string(from: departureDate)
        
        return "\(arrivalDay) - \(departureDay) \(month)"
    }

    return "unknown"
}
