//
//  UserDefaultsExtensions.swift
//  SampleProjet
//
//  Created by Jason Jardim on 10/11/19.
//  Copyright © 2019 Jason Jardim. All rights reserved.
//

import Foundation

// MARK: -

extension UserDefaults {
    
    class func isUserLoggedIn() -> Bool {
        if self.standard.object(forKey: "kUserLoggedIn") != nil {
            return self.standard.bool(forKey: "kUserLoggedIn")
        } else {
            self.setUserLoggedIn(flag: false)
            return false
        }
    }
    
    class func setUserLoggedIn(flag: Bool) {
        self.standard.set(flag, forKey: "kUserLoggedIn")
    }
    
}
