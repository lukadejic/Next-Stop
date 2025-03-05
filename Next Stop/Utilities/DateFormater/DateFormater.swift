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

func arrivalDayFormater(date: Date?) -> String {
    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "d MMM"
    
    guard let date = date else { return "" }
    
    if let adjustedDate = Calendar.current.date(byAdding: .day, value: -7, to: date) {
        return outputFormatter.string(from: adjustedDate)
    }
    
    return "Unknown date"
}

func arrivalDayConverter(arrivalDate: String?) -> String {
    guard let arrival = arrivalDate else { return "unknown" }
    
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM-dd"
    inputFormatter.locale = Locale(identifier: "en_US_POSIX")
    
    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "d MMM"
    
    if let arrivalDate = inputFormatter.date(from: arrival) {
        let adjustedDate = Calendar.current.date(byAdding: .day, value: -7, to: arrivalDate)
        
        if let adjustedDate = adjustedDate {
            return outputFormatter.string(from: adjustedDate)
        }
    }
    
    return "unknown"
}
