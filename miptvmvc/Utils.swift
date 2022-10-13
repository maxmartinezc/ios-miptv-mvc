//
//  Utils.swift
//  mitvmvc
//
//  Created by Max Martinez Cartagena on 06-03-22.
//

import Foundation
import UIKit

struct Utils {
    
    static func setUserPlayList(url: String?) {
        UserDefaults.standard.set(url, forKey: K.UserConfig.playList)
    }
    
    static func getUserPlayList() -> String? {
        return UserDefaults.standard.string(forKey: K.UserConfig.playList)
    }
    
    static func setLastPlayedChannel(row: Int?) {
        UserDefaults.standard.set(row, forKey: K.UserConfig.lastPlayed)
    }
    
    static func getLastPlayedChannel() -> Int? {
        return UserDefaults.standard.integer(forKey: K.UserConfig.lastPlayed)
    }
    
        static func getQueryStringParameter(url: String, param: String) -> String? {
            guard let url = URLComponents(string: url) else { return nil }
            return url.queryItems?.first(where: { $0.name == param })?.value
        }
        
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
    
    // OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
        
        self.lockOrientation(orientation)

        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
        
    }
    
    static func validateEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
              let trimmedString = email.trimmingCharacters(in: .whitespaces)
              let validateEmail = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
              let isValidateEmail = validateEmail.evaluate(with: trimmedString)
              return isValidateEmail
    }
    
    static func validatePassword(password: String) -> Bool {
        let isvalidatePass = password.count > 5
        return isvalidatePass
     }
}
