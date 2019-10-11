//
//  ScheduledSoundsData.swift
//  SampleProjet
//
//  Created by Jason Jardim on 10/11/19.
//  Copyright © 2019 Jason Jardim. All rights reserved.
//

import Foundation
 
class ScheduledSoundsData: NSObject, NSCoding, NSSecureCoding {
    
    // Limits
    
    static let kRestrictionAmoutTotal = 10
    
    // Object Defaults
    // ------------------------------------------------
 
    static let defaultShouldSyncOnNewSound : Bool = true
    static let defaultScheduledSoundName = ""
    static let defaultFadeInDuration = 600
    static let defaultFadeOutDuration = 3600
    static let defaultRepeatFrequencyArray = [0, 1, 2, 3, 4, 5, 6]
    static let defaultFadeInFadeOutPickerArray = [0, 1, 5, 10, 15, 30, 45, 60, 300, 600, 900, 1800, 2700, 3600]

    static let defaultRepeatFrequencyText: String = {
       
        let calendar = Calendar.current
        var returnedData: String = ""

        for days in calendar.shortWeekdaySymbols {
            returnedData = returnedData + "\(days) "
        }
        return String(returnedData.dropLast(1))
    }()
    // ------------------------------------------------
    

    var title = ""
    
    var isActive : Bool = false {
        didSet {
            shouldSync = true
        }
    }

    var fadeInDuration : Int = 0
    
    var fadeOutDuration : Int = 0

    var repeatFrequency = ""
  
    var arrayRepeatFrequency : [Int] = [Int]() {
        didSet {
            shouldSync = true
        }
    }

    var startTime : String?
    var stopTime : String?

    var startTimeDate: Date? {
        didSet {
            shouldSync = true
            updateFadeInOutDurations()
        }
    }

    var stopTimeDate: Date? {
        didSet {
            updateFadeInOutDurations()
        }
    }

    var soundOrMix: HSSound?
    
    var shouldSync : Bool = ScheduledSoundsData.defaultShouldSyncOnNewSound
    
    
    // Parameters used when sending in HSAPIClient
    var serverParameters: [String : AnyObject] {
        get {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            dateFormatter.timeZone = TimeZone(identifier: "UTC")
            
            let date = dateFormatter.string(from: startTimeDate!)
            
            return ["startTime" : date as AnyObject, "repeat" : arrayRepeatFrequency as AnyObject]
        }
    }
    
    init(title: String, active: Bool, fadeIn: Int, fadeOut: Int, repeatFrequency: String, arrayRepeatFrequency: [Int], startTime: String?, stopTime: String?, startTimeDate: Date?, stopTimeDate: Date?, soundOrMix: HSSound?, shouldSync: Bool) {
        super.init()
        self.title = title
        self.isActive = active
        self.fadeInDuration = fadeIn
        self.fadeOutDuration = fadeOut
        self.repeatFrequency = repeatFrequency
        self.arrayRepeatFrequency = arrayRepeatFrequency
        self.startTime = startTime
        self.stopTime = stopTime
        self.startTimeDate = startTimeDate
        self.stopTimeDate = stopTimeDate
        self.soundOrMix = soundOrMix
        self.shouldSync = shouldSync
    }
    
    // MARK: NSCoding Implementation
    
    enum Keys: String {
        case title = "title"
        case isActive = "isActive"
        case fadeIn = "fadeIn"
        case fadeOut = "fadeOut"
        case repeatFrequency = "repeatFrequency"
        case arrayRepeatFrequency = "arrayRepeatFrequency"
        case startTime = "startTime"
        case stopTime = "stopTime"
        case startTimeDate = "startTimeDate"
        case stopTimeDate = "stopTimeDate"
        case soundOrMix = "soundOrMix"
        case shouldSync = "shouldSync"
    }
    
    func updateFadeInOutDurations() {
        if (startTimeDate != nil && stopTimeDate != nil) {
            let totalPlayDuration = ScheduledSoundsManager.calculateTimeDelta(startTime: self.startTimeDate!, stopTime: self.stopTimeDate!)
            
            var pickerData: [Int] = [Int]()
            pickerData = ScheduledSoundsData.defaultFadeInFadeOutPickerArray.filter { $0 <= abs(totalPlayDuration/2) }
            let greatestPossibleFadeDuration = pickerData.last ?? 0
            
            if self.fadeInDuration > greatestPossibleFadeDuration {
                self.fadeInDuration = greatestPossibleFadeDuration
            }
            
            if self.fadeOutDuration > greatestPossibleFadeDuration {
                self.fadeOutDuration = greatestPossibleFadeDuration
            }
        }
    }
    
    func shouldFadeIn() -> Bool {
        if self.fadeInDuration > 0 {
            return true
        }
        return false
    }
    
    func shouldFadeOut() -> Bool {
        if self.fadeOutDuration > 0 {
            return true
        }
        return false
    }
    
    func repeatFrequencyAsNaturalString() -> String {
        let daysSelected = self.arrayRepeatFrequency

        if daysSelected.count == 2 && daysSelected.contains(0) && daysSelected.contains(6) {
            return NSLocalizedString("SCHEDULED_SOUNDS_WEEKENDS", comment: "")
        } else if daysSelected.count == 5 && daysSelected.contains(1) && daysSelected.contains(2) && daysSelected.contains(3) && daysSelected.contains(4) && daysSelected.contains(5) {
            return NSLocalizedString("SCHEDULED_SOUNDS_WEEKDAYS", comment: "")
        } else if daysSelected.count == 7 {
            return NSLocalizedString("SCHEDULED_SOUNDS_EVERY_DAY", comment: "")
        } else {
            return repeatFrequency
        }
    }
    
    
    func encode(with aCoder: NSCoder) {
        //    For NSCoding
        aCoder.encode(title, forKey: Keys.title.rawValue)
        aCoder.encode(isActive, forKey: Keys.isActive.rawValue)
        aCoder.encode(fadeInDuration, forKey: Keys.fadeIn.rawValue)
        aCoder.encode(fadeOutDuration, forKey: Keys.fadeOut.rawValue)
        aCoder.encode(repeatFrequency, forKey: Keys.repeatFrequency.rawValue)
        aCoder.encode(arrayRepeatFrequency, forKey: Keys.arrayRepeatFrequency.rawValue)
        aCoder.encode(startTime, forKey: Keys.startTime.rawValue)
        aCoder.encode(stopTime, forKey: Keys.stopTime.rawValue)
        aCoder.encode(startTimeDate, forKey: Keys.startTimeDate.rawValue)
        aCoder.encode(stopTimeDate, forKey: Keys.stopTimeDate.rawValue)
        aCoder.encode(soundOrMix, forKey: Keys.soundOrMix.rawValue)
        aCoder.encode(shouldSync, forKey: Keys.shouldSync.rawValue)

        //    For NSSecureCoding
        //    aCoder.encode(title as NSString, forKey: Keys.title.rawValue)
        //    aCoder.encode(NSNumber(value: rating), forKey: Keys.rating.rawValue)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        //    For NSCoding
        //    let title = aDecoder.decodeObject(forKey: Keys.title.rawValue) as! String
        //    let rating = aDecoder.decodeFloat(forKey: Keys.rating.rawValue)
        
        //    For NSSecureCoding
        let title = aDecoder.decodeObject(of: NSString.self, forKey: Keys.title.rawValue) as String? ?? ""
        let isActive = aDecoder.decodeBool(forKey: Keys.isActive.rawValue)
        let fadeIn = aDecoder.decodeCInt(forKey: Keys.fadeIn.rawValue)
        let fadeOut = aDecoder.decodeCInt(forKey: Keys.fadeOut.rawValue)
        let repeatFreq = aDecoder.decodeObject(of: NSString.self, forKey: Keys.repeatFrequency.rawValue) as String? ?? ""
        let arrayRepeatFrequency = aDecoder.decodeObject(forKey: Keys.arrayRepeatFrequency.rawValue) as? [Int] ?? []
        let startTime = aDecoder.decodeObject(of: NSString.self, forKey: Keys.startTime.rawValue) as String?
        let stopTime = aDecoder.decodeObject(of: NSString.self, forKey: Keys.stopTime.rawValue) as String?

        let startTimeDate = aDecoder.decodeObject(forKey: Keys.startTimeDate.rawValue) as! Date?
        let stopTimeDate = aDecoder.decodeObject(forKey: Keys.stopTimeDate.rawValue) as! Date?

        let soundOrMix = aDecoder.decodeObject(forKey: Keys.soundOrMix.rawValue) as! HSSound?
        let shouldSync = aDecoder.decodeBool(forKey: Keys.shouldSync.rawValue)

        self.init(title: title, active: isActive, fadeIn: Int(fadeIn), fadeOut: Int(fadeOut), repeatFrequency: repeatFreq, arrayRepeatFrequency: arrayRepeatFrequency, startTime: startTime, stopTime: stopTime, startTimeDate: startTimeDate, stopTimeDate: stopTimeDate, soundOrMix: soundOrMix, shouldSync: shouldSync)
    }
    
    
    static var supportsSecureCoding: Bool {
        return false
    }
}

extension ScheduledSoundsData {
    override var description: String {
        return "(Self: \(self), Title: \(self.title), isActive: \(self.isActive), fadeInDuration: \(self.fadeInDuration), fadeOutDuration: \(self.fadeOutDuration), repeatFrequency: \(self.repeatFrequency), arrayFrequency: \(self.arrayRepeatFrequency), startTime: \(String(describing: self.startTime)), stopTime: \(String(describing: self.stopTime)), startTimeDate: \(String(describing: self.startTimeDate)), stopTimeDate: \(String(describing: self.stopTimeDate)), soundOrMix: \(String(describing: self.soundOrMix)), shouldSync: \(self.shouldSync))"
    }
}
