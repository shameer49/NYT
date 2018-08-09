//
//  DateUtility.swift
//  RentMojiLeasingAgent
//
//  Created by AJITH MK on 30/11/16.
//  Copyright © 2016 FingentCorp. All rights reserved.
//

import Foundation

enum dateFormatStrings:String {
    
    case DATE_AND_TIME = "MM/dd/yyyy - HH:mm a"
    case DATE_AND_TIME_LONG = "yyyy-MM-dd'T'HH:mm:ss.SS"
    case DATE_AND_TIME_LONG_2 = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    case DATE_ONLY = "dd-MM-yyyy"
    case TIME_ONLY = "hh:mm a"
    case TIME_ONLY_2 = "hh:mm:ss"
    case MONTH_AND_YEAR = "MMM yyyy"
    case MONTH_AND_YEAR_LONG = "MMMM yyyy"
    case MONTH_AND_YEAR_TWO = "yyyy/M"
    case DATE_AND_TIME_ONLY = "yyyy-MM-dd'T'HH:mm:ss"
    case DATE_HOUR_MINUTE_ZONE = "yyyy-MM-dd'T'HH:mmZZZZZ"

}

enum dateFormat {
    
    case date_and_time
    case date_and_time_long
    case date_and_time_long_2
    case date_only
    case time_only
    case time_only_2
    case month_and_year
    case month_and_year_long
    case month_and_year_alt
    case date_and_time_only
    case date_hour_minute_zone

    
}

class DateUtility {
    
    class func getFormattedDateStringForDateString(dateString:String ,inDateFormat dateFormat:dateFormat ,isToLocalTimeZone toLocaltZone:Bool) -> String {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        var date: Date?
        if let val = dateFormatter.date(from: dateString){
            date = val
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let val = dateFormatter.date(from: dateString){
            date = val
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let val = dateFormatter.date(from: dateString){
            date = val
        }
        
        dateFormatter.dateFormat = "MM/dd/yyyy"
        if let val = dateFormatter.date(from: dateString){
            date = val
        }
        
        
        let formattedString = self.getFormattedDateStringForDate(date: date!, inDateFormat: dateFormat, isToLocalTimeZone: toLocaltZone)
        return formattedString
        
    }
    
    class func getFormattedDateStringForDate(date:Date ,inDateFormat dateFormat:dateFormat ,isToLocalTimeZone toLocaltZone:Bool) -> String {
        
        let dateFormatter = DateFormatter()
        switch dateFormat {
            
        case .date_and_time:
            dateFormatter.dateFormat = dateFormatStrings.DATE_AND_TIME.rawValue
        case .date_and_time_long:
            dateFormatter.dateFormat = dateFormatStrings.DATE_AND_TIME_LONG.rawValue
        case .date_and_time_long_2:
            dateFormatter.dateFormat = dateFormatStrings.DATE_AND_TIME_LONG_2.rawValue
        case .date_hour_minute_zone:
            dateFormatter.dateFormat = dateFormatStrings.DATE_HOUR_MINUTE_ZONE.rawValue
        case .date_only:
            dateFormatter.dateFormat = dateFormatStrings.DATE_ONLY.rawValue
        case .month_and_year:
            dateFormatter.dateFormat = dateFormatStrings.MONTH_AND_YEAR.rawValue
        case .time_only:
            dateFormatter.dateFormat = dateFormatStrings.TIME_ONLY.rawValue
        case .time_only_2:
            dateFormatter.dateFormat = dateFormatStrings.TIME_ONLY_2.rawValue
        case .month_and_year_long:
            dateFormatter.dateFormat = dateFormatStrings.MONTH_AND_YEAR_LONG.rawValue
        case .month_and_year_alt:23
            dateFormatter.dateFormat = dateFormatStrings.MONTH_AND_YEAR_TWO.rawValue
        case .date_and_time_only:
            dateFormatter.dateFormat = dateFormatStrings.DATE_AND_TIME_ONLY.rawValue

        default:
            dateFormatter.dateFormat = dateFormatStrings.DATE_AND_TIME.rawValue
        }
        
        if toLocaltZone{
            
            dateFormatter.timeZone = NSTimeZone.local
        }
        else {
            
            dateFormatter.timeZone =  NSTimeZone(name: "UTC") as TimeZone!
        }
        
        let formattedString = dateFormatter.string(from: date)
        return formattedString
        
    }
    
    class func getFormattedDateFromString( dateString: String , inTimeZone timeZone:NSTimeZone? ) -> Date{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormatStrings.DATE_AND_TIME_LONG.rawValue
        if let tZone =  timeZone {
            dateFormatter.timeZone = tZone as TimeZone!
        }
        var  formattedDate = Date()
        if let _formattedDate = dateFormatter.date(from: dateString) {
            formattedDate = _formattedDate
        }
       // if formattedDate == nil {
        dateFormatter.dateFormat = dateFormatStrings.DATE_AND_TIME_LONG_2.rawValue
        if let _formattedDate = dateFormatter.date(from: dateString) {
            formattedDate = _formattedDate
        }
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mmZZZZZ"
        if let _formattedDate = dateFormatter.date(from: dateString) {
            formattedDate = _formattedDate
        }
        //}
        return formattedDate
        
    }

}
