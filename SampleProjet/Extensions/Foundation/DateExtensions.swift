//
//  DateExtensions.swift
//  SampleProjet
//
//  Created by Jason Jardim on 10/11/19.
//  Copyright © 2019 Jason Jardim. All rights reserved.
//

import Foundation

// MARK: - SECOND
extension Date {
    
    // MARK: DATE CALCULATION

    func changeDate(withSeconds seconds: Int) -> Date {
        return Calendar.current.date(byAdding: .second, value: seconds, to: self)!
    }
    
    func dateBy(addingSeconds seconds: Int) -> Date {
        return self.changeDate(withSeconds: seconds)
    }
    
    func dateBy(substractingSeconds seconds: Int) -> Date {
        return self.changeDate(withSeconds: -seconds)
    }
}

// MARK: - MINUTE
extension Date {
    
    // MARK: DATE CALCULATION
    
    func changeDate(withMinutes minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
    
    func dateBy(addingMinutes minutes: Int) -> Date {
        return self.changeDate(withMinutes: minutes)
    }
    
    func dateBy(substractingMinutes minutes: Int) -> Date {
        return self.changeDate(withMinutes: -minutes)
    }
}

// MARK: - HOUR
extension Date {
    
    // MARK: DATE CALCULATION
    
    func changeDate(withHours hours: Int) -> Date {
        return Calendar.current.date(byAdding: .hour, value: hours, to: self)!
    }
    
    func dateBy(addingHours hours: Int) -> Date {
        return self.changeDate(withHours: hours)
    }
    
    func dateBy(substractingHours hours: Int) -> Date {
        return self.changeDate(withHours: -hours)
    }
}



// MARK: - DAY
extension Date {
    
    // MARK: DATE CALCULATION
    
    func changeDate(withDays days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
    
    func dateBy(addingDays days: Int) -> Date {
        return self.changeDate(withDays: days)
    }
    
    func dateBy(substractingDays days: Int) -> Date {
        return self.changeDate(withDays: -days)
    }
    
    func startLastDay() -> Date? {
        let calendar = Calendar.current
        var currentDateComponents = calendar.dateComponents([.year, .month, .day], from: self)
        currentDateComponents.day! -= 1
        let startLastDay = calendar.date(from: currentDateComponents)
        return startLastDay
    }
    
    func endLastDate() -> Date? {
        let calendar = Calendar.current
        let plusOneDay = changeDate(withDays: 1)
        var plusOneDayDateComponents = calendar.dateComponents([.year, .month, .day], from: plusOneDay)
        plusOneDayDateComponents.day! -= 1
        let endLastDate = calendar.date(from: plusOneDayDateComponents)?.addingTimeInterval(-1)
        return endLastDate
    }
}


// MARK: - MONTH
extension Date {
    
    // MARK: DATE CALCULATION

    func changeDate(withMonths months: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: months, to: self)!
    }
    
    
    // MARK: LAST MONTH

    func startLastMonth() -> Date? {
        let calendar = Calendar.current
        var currentDateComponents = calendar.dateComponents([.year, .month], from: self)
        currentDateComponents.month! -= 1
        let startLastMonth = calendar.date(from: currentDateComponents)
        return startLastMonth
    }
    
    
    func endLastMonth() -> Date? {
        let calendar = Calendar.current
        let plusOneMonthDate = changeDate(withMonths: 1)
        var plusOneMonthDateComponents = calendar.dateComponents([.year, .month], from: plusOneMonthDate)
        plusOneMonthDateComponents.month! -= 1
        let endLastMonth = calendar.date(from: plusOneMonthDateComponents)?.addingTimeInterval(-1)
        return endLastMonth
    }
    
    
    // MARK: CURRENT MONTH

    func startCurrentMonth() -> Date? {
        let calendar = Calendar.current
        let currentDateComponents = calendar.dateComponents([.year, .month], from: self)
        let startOfMonth = calendar.date(from: currentDateComponents)
        return startOfMonth
    }
    
    func endCurrentMonth() -> Date? {
        let calendar = Calendar.current
        let plusOneMonth = changeDate(withMonths: 1)
        let plusOneMonthComponents = calendar.dateComponents([.year, .month], from: plusOneMonth)
        let endOfMonth = calendar.date(from: plusOneMonthComponents)?.addingTimeInterval(-1)
        return endOfMonth
    }
    
    func startNextMonth() -> Date? {
        let calendar = Calendar.current
        var currentDateComponents = calendar.dateComponents([.year, .month], from: self)
        currentDateComponents.month! += 1
        let startNextMonth = calendar.date(from: currentDateComponents)
        return startNextMonth
    }
    
    func endNextMonth() -> Date? {
        let calendar = Calendar.current
        let plusOneMonthDate = changeDate(withMonths: 1)
        var plusOneMonthDateComponents = calendar.dateComponents([.year, .month], from: plusOneMonthDate)
        plusOneMonthDateComponents.month! -= 1
        let endNextMonth = calendar.date(from: plusOneMonthDateComponents)?.addingTimeInterval(-1)
        return endNextMonth
    }
}


// MARK: - DATE TO STRING

extension Date {
    
    func string_ss() -> String {
        let formatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "ss"
            dateFormatter.timeZone = Calendar.current.timeZone
            dateFormatter.locale = Calendar.current.locale
            return dateFormatter
        } ()
        return formatter.string(from: self)
    }
    
    func string_mm() -> String {
        let formatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "mm"
            dateFormatter.timeZone = Calendar.current.timeZone
            dateFormatter.locale = Calendar.current.locale
            return dateFormatter
        } ()
        return formatter.string(from: self)
    }
    
    func string_HH_mm() -> String {
        let formatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            dateFormatter.timeZone = Calendar.current.timeZone
            dateFormatter.locale = Calendar.current.locale
            return dateFormatter
        } ()
        return formatter.string(from: self)
    }

    func string_HH_mm_ss() -> String {
        let formatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss"
            dateFormatter.timeZone = Calendar.current.timeZone
            dateFormatter.locale = Calendar.current.locale
            return dateFormatter
        } ()
        return formatter.string(from: self)
    }
    
    func string_dd() -> String? {
        let formatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd"
            dateFormatter.timeZone = Calendar.current.timeZone
            dateFormatter.locale = Calendar.current.locale
            return dateFormatter
        }()
        return formatter.string(from: self)
    }
    
    func string_MM() -> String? {
        let formatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM"
            dateFormatter.timeZone = Calendar.current.timeZone
            dateFormatter.locale = Calendar.current.locale
            return dateFormatter
        }()
        return formatter.string(from: self)
    }
    
    func string_yyyy() -> String? {
        let formatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy"
            dateFormatter.timeZone = Calendar.current.timeZone
            dateFormatter.locale = Calendar.current.locale
            return dateFormatter
        }()
        return formatter.string(from: self)
    }

    func string_yyyy_MM() -> String? {
        let formatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy - MM"
            dateFormatter.timeZone = Calendar.current.timeZone
            dateFormatter.locale = Calendar.current.locale
            return dateFormatter
        }()
        return formatter.string(from: self)
    }
    
    func string_yyy_MM_dd() -> String {
        
        let formatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.timeZone = Calendar.current.timeZone
            dateFormatter.locale = Calendar.current.locale
            return dateFormatter
        } ()
        
        return formatter.string(from: self)
    }

    func string_yyyy_MM_dd_HH_mm_ss() -> String {
        let formatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.timeZone = Calendar.current.timeZone
            dateFormatter.locale = Calendar.current.locale
            return dateFormatter
        } ()
        return formatter.string(from: self)
    }
    
    func string_EEEE_MMMM_dd_yyyy_HH_MM() -> String {
        let formatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE, MMMM dd, yyyy HH:MM"
            dateFormatter.timeZone = Calendar.current.timeZone
            dateFormatter.locale = Calendar.current.locale
            return dateFormatter
        } ()
        return formatter.string(from: self)
    }
}

