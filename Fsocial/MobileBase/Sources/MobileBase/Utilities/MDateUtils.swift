//
//  DateUtils.swift
// Example
//
//  Created by ChungTV on 14/02/2022.
//

import Foundation

enum DateFormat {
    case month
    /// MM/yyyy
    case monthYear
    
    /// HH:mm
    case hourMinute
    
    /// HH:mm dd/MM/yyyy
    case hourMinuteFullDate
    
    //"HH:mm:ss dd/MM/yyyy"
    case hourMinuteSecondFullDate
    
    /// dd/MM/yyyy
    case full
    
    /// yyyy-MM-dd
    case dob
    
    /// HH:mm:ss
    case hourMinuteSecond
    
    case custom(key: String)
    
    fileprivate var keyDate: String {
        switch self {
        case .month:
            return "MM"
        case .monthYear:
            return "MM/yyyy"
        case .hourMinute:
            return "HH:mm"
        case .hourMinuteFullDate:
            return "HH:mm dd/MM/yyyy"
        case .full:
            return "dd/MM/yyyy"
        case .dob:
            return "yyyy-MM-dd"
            
        case .hourMinuteSecond:
            return "HH:mm:ss"
            
        case .hourMinuteSecondFullDate:
            return "HH:mm:ss dd/MM/yyyy"
            
        case .custom(let key):
            return key
        }
    }
}

struct DateUtils {
    private static let defaultFormat = "yyyy-MM-dd HH:mm:ss"
    
    static func format(from dateString: String?, with format: DateFormat) -> String? {
        guard let dateStr = dateString else {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = defaultFormat
        
        guard let date = dateFormatter.date(from: dateStr) else {
            return nil
        }
        dateFormatter.dateFormat = format.keyDate
        return dateFormatter.string(from: date)
    }
    
    static func date(from dateString: String?,
                     with format: DateFormat) -> Date? {
        guard let dateStr = dateString else {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.keyDate
        return dateFormatter.date(from: dateStr)
    }
    
    static func dateTimeZone(from dateString: String?) -> Date? {
        guard let dateStr = dateString else {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Ho_Chi_Minh")!
        dateFormatter.locale = Locale(identifier: "vi_VN")
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: dateStr)
    }
    
    
    static func format(from date: Date?,
                       with format: DateFormat) -> String? {
        guard let date = date else {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.keyDate
        return dateFormatter.string(from: date)
    }
    
    static func format(from date: Date?) -> String? {
        guard let date = date else {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = defaultFormat
        return dateFormatter.string(from: date)
    }
    
    static func hourMinuteSecond(timeCounting: Int) -> String{
        let hour   = (timeCounting / 3600)
        let minute = (timeCounting % 3600) / 60
        let second = (timeCounting % 3600) % 60
        
        let sH = hour   < 10 ? "0\(hour)"   : "\(hour)"
        let sM = minute < 10 ? "0\(minute)" : "\(minute)"
        let sS = second < 10 ? "0\(second)" : "\(second)"
        
        return "\(sH):\(sM):\(sS)"
    }
    
    static func formatToWeekStr(stringToString dateString: String?) -> String? {
        guard let dateStr = dateString else {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "vi")
        dateFormatter.timeZone = TimeZone.init(abbreviation: "GMT+7")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        guard let date = dateFormatter.date(from: dateStr) else {
            return nil
        }
        dateFormatter.dateFormat = "EEEEE"
        return dateFormatter.string(from: date)
    }
    
    static func format(stringToString dateString: String?) -> String? {
        
        guard let dateStr = dateString else {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "vi")
        dateFormatter.timeZone = TimeZone.init(abbreviation: "GMT+7")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        guard let date = dateFormatter.date(from: dateStr) else {
            return nil
        }
        dateFormatter.dateFormat = "HH:mm dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
    
    
    static func format(stringToString dateString: String?, formart: DateFormat) -> String? {
        
        guard let dateStr = dateString else {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "vi")
        dateFormatter.timeZone = TimeZone.init(abbreviation: "GMT+7")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        guard let date = dateFormatter.date(from: dateStr) else {
            return nil
        }
        dateFormatter.dateFormat = formart.keyDate
        return dateFormatter.string(from: date)
    }
    
    static func format(stringTodate dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Ho_Chi_Minh")!
        dateFormatter.locale = Locale(identifier: "vi")
        dateFormatter.timeZone = TimeZone.init(abbreviation: "GMT+7")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: dateString)
        
    }
    
    static func date(from dateTodate: Date) -> Date {
        let dateFormatter = DateFormatter()
        //  dateFormatter.timeZone = TimeZone(identifier: "Asia/Ho_Chi_Minh")!
        dateFormatter.locale = Locale(identifier: "vi")
        dateFormatter.timeZone = TimeZone.init(abbreviation: "GMT+7")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateStr = dateFormatter.string(from: dateTodate)
        
        //  dateFormatter.timeZone = TimeZone(identifier: "Asia/Ho_Chi_Minh")!
        
        let dateFormatter2 = DateFormatter()
        // dateFormatter2.locale = Locale(identifier: "vi")
        dateFormatter2.timeZone = TimeZone.init(abbreviation: "GMT")
        dateFormatter2.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter2.date(from: dateStr) ?? Date()
    }

    static func date(from dateString: String?) -> Date? {
        guard let dateStr = dateString else {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = defaultFormat
        return dateFormatter.date(from: dateStr)
    }
}
extension Date{
    var dateInRegion: String?{
        return DateUtils.format(from: self)
    }
    var timestamp: TimeInterval?{
        return self.timeIntervalSince1970
    }
}

extension Date {
    func timeAgoDisplay(createTime: String?) -> String {
        let currentDate = DateUtils.date(from: Date())
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Asia/Ho_Chi_Minh")!
        calendar.locale = Locale(identifier: "vi")
        let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: currentDate)!
        let hourAgo = calendar.date(byAdding: .hour, value: -1, to: currentDate)!
        let dayAgo = calendar.date(byAdding: .day, value: -1, to: currentDate)!
       
        if minuteAgo < self {
            return "Vừa xong"
        } else if hourAgo < self {
            let diff = Calendar.current.dateComponents([.minute], from: self, to: currentDate).minute ?? 0
            return "\(diff) phút trước"
        } else if dayAgo < self {
            let diff = Calendar.current.dateComponents([.hour], from: self, to: currentDate).hour ?? 0
            return "\(diff) giờ trước"
        }
       let dateServer = DateUtils.date(from: createTime)
        return DateUtils.format(from: dateServer, with: .hourMinuteFullDate) ?? "date unknow"
    }
    
    func isTimeAgoIsBefor() -> Bool {
        let currentDate = DateUtils.date(from: Date())
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Asia/Ho_Chi_Minh")!
        calendar.locale = Locale(identifier: "vi")
        let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: currentDate)!
        let hourAgo = calendar.date(byAdding: .hour, value: -1, to: currentDate)!
        let dayAgo = calendar.date(byAdding: .day, value: -1, to: currentDate)!
        if minuteAgo < self {
            return true
        } else if hourAgo < self {
            return true
        } else if dayAgo < self {
            return true
        }
        return false
    }
    
}
