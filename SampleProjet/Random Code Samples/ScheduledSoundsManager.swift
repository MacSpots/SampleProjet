//
//  ScheduledSoundsManager.swift
//  SampleProjet
//
//  Created by Jason Jardim on 10/11/19.
//  Copyright © 2019 Jason Jardim. All rights reserved.
//

import Foundation


import Foundation
import MediaPlayer
import Foundation
import AVFoundation
import AVKit
import os.log


class ScheduledSoundsManager: NSObject {

    static let kScheduledSoundsDidRefresh = "kScheduledSoundsDidRefresh"

    var audioPlayer: AVAudioPlayer?
    
    unowned let audioController: HSAudioController
    var scheduledSoundsArray: [ScheduledSoundsDocument] = []
    
    override init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.audioController = appDelegate.audioController
        super.init()
   
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveSignificantTimeChangeNotification), name: UIApplication.significantTimeChangeNotification, object: nil)
    }

    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // Handle TimeZone Change notifications
    @objc func didReceiveSignificantTimeChangeNotification(){
        
        let timezoneOffset =  TimeZone.current.secondsFromGMT()
        
        if HSUserDefaults.currentTimeZoneSecondOffset() != timezoneOffset {
            let creationOffset = HSUserDefaults.currentTimeZoneSecondOffset()
            let oldAndNewTimezoneOffset = timezoneOffset - creationOffset
            let oldAndNewTimezoneOffsetTimeInterval = TimeInterval(oldAndNewTimezoneOffset)
            let scheduledSoundsArrayTimezoneChange = ScheduledSoundsDatabase.activeScheduledSounds()
            
            for item in scheduledSoundsArrayTimezoneChange {
                item.data?.startTimeDate? = (item.data?.startTimeDate?.addingTimeInterval(oldAndNewTimezoneOffsetTimeInterval))!
                item.data?.stopTimeDate = (item.data?.stopTimeDate?.addingTimeInterval(oldAndNewTimezoneOffsetTimeInterval))
                item.saveData(sync: true)
            }
            
            HSUserDefaults.setCurrentTimeZoneSecondOffset(offset: timezoneOffset)
        }
    }
    
    
    func checkTimeZoneOffset() {
        
        let timezoneOffset =  TimeZone.current.secondsFromGMT()

        // Set an offset and store it in NSDefaults
        if timezoneOffset != HSUserDefaults.currentTimeZoneSecondOffset() {
            didReceiveSignificantTimeChangeNotification()
        } else {
            HSUserDefaults.setCurrentTimeZoneSecondOffset(offset: timezoneOffset)
        }
    }
    
    
    // Function used to check for sounds that have been started but force quit during creation
    func checkDataOnForForceQuit() {
        let scheduledSoundsArray = ScheduledSoundsDatabase.loadScheduledSoundsItems()
        
        for item in scheduledSoundsArray {

            if ((item.data?.startTime) == nil) || ((item.data?.stopTime) == nil) || ((item.data?.soundOrMix) == nil) {
                item.deleteScheduledSoundItem()
            }
        }
    }
    
    
    
    func playScheduledSounds() {
        
        if HSProducts.shared.isPremiumSubscription() == false {
            ScheduledSoundsDatabase.makeAllSoundsInActive()
            return
        }
        
        self.scheduledSoundsArray = ScheduledSoundsDatabase.activeScheduledSounds()
        var arrayPossibleActiveScheduledSounds: [ScheduledSoundsDocument] = []
       
        // Find out if today is when we should play the sound
        let todayIs = Date().dayNumberOfWeek()!

        if scheduledSoundsArray.count > 0 {
            for item in scheduledSoundsArray {
                if item.data!.arrayRepeatFrequency.contains(todayIs) {
                    arrayPossibleActiveScheduledSounds.append(item)
                }
            }
        }
        
        // Closest Possible Sound to play based on time
        var closestSceduledSoundToPlay: ScheduledSoundsDocument?
        
        if arrayPossibleActiveScheduledSounds.count > 0 {
            for item in arrayPossibleActiveScheduledSounds {
                
                if closestSceduledSoundToPlay == nil {
                    closestSceduledSoundToPlay = item
                } else {
                    if abs(closestSceduledSoundToPlay!.data!.startTimeDate!.timeIntervalSince(Date())) > abs(item.data!.startTimeDate!.timeIntervalSince(Date()))  {
                        closestSceduledSoundToPlay = item
                    }
                }
            }
        }

        self.scheduledSoundsArray = ScheduledSoundsDatabase.activeScheduledSounds()
        
        let name = closestSceduledSoundToPlay!.data!.soundOrMix!.title
        let category = closestSceduledSoundToPlay!.data!.soundOrMix!.category

       

        // Find the number of seconds from now that the scheduled sound should start
        let startTimeDate = closestSceduledSoundToPlay!.data!.startTimeDate!
        let startTime = 60 * Calendar.current.component(.hour, from: startTimeDate) + Calendar.current.component(.minute, from: startTimeDate)
        let currentTime =  60 * Calendar.current.component(.hour, from: Date()) + Calendar.current.component(.minute, from: Date())
        var delayBeforeStartingPlayInSeconds = TimeInterval((startTime - currentTime) * 60)
        
        // Find the number of seconds from now that the scheduled sound should end
        let stopTimeDate = closestSceduledSoundToPlay!.data!.stopTimeDate!
        let endTime = 60 * Calendar.current.component(.hour, from: stopTimeDate) + Calendar.current.component(.minute, from: stopTimeDate)
        let delayBeforeStoppingInSeconds = TimeInterval((endTime - currentTime) * 60)

        //Play Sound
        let querier = HSSoundQuerier()
        let sound = querier.findByTitle(name, category: category)
        
        if sound != nil {
            if delayBeforeStartingPlayInSeconds < 0.0 {
                delayBeforeStartingPlayInSeconds = 0
            }
            let audioFadeIn = TimeInterval(closestSceduledSoundToPlay?.data!.fadeInDuration ?? 0)
            let audioFadeOut = TimeInterval(closestSceduledSoundToPlay?.data!.fadeOutDuration ?? 0)
   
            self.audioController.playScheduledSoundSound(sound!,
                                                         startTimeDelayTimeInterval: delayBeforeStartingPlayInSeconds,
                                                         fadeInDurationTimeInterval: audioFadeIn,
                                                         stopTimeDelayTimeInterval: delayBeforeStoppingInSeconds,
                                                         fadeOutDurationTimeInterval: audioFadeOut)
        }
    }
    
    

    class func calculateTimeDelta(startTime: Date, stopTime: Date) -> Int {
        // Find the Delta between the push message and the time the Sound shoud START
        let startTime = 60 * Calendar.current.component(.hour, from: startTime) + Calendar.current.component(.minute, from: startTime)
        let stopTime = 60 * Calendar.current.component(.hour, from: stopTime) + Calendar.current.component(.minute, from: stopTime)
        
        let timeCalDelta = (startTime - stopTime) * 60
        
        return timeCalDelta
    }
    
    // Func that API uses send scheduled sounds
    func syncSoundsToServerIfNeeded() {
        
        if ScheduledSoundsDatabase.activeScheduledSoundsToSync().count == 0 {
            HSServerManager.shared.clearAllScheduledSounds()
        } else {
            HSServerManager.shared.sendActiveScheduledSounds()
        }
    }
}
