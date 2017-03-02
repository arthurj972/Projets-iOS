//
//  Fonctions.swift
//  Touch ID
//
//  Created by Arthur JANSSENS on 28/02/2017.
//  Copyright © 2017 Arthur JANSSENS. All rights reserved.
//

import Foundation
import UIKit
import LocalAuthentication

class Fonctions {
    
    static func getInfoAvecCode(code: Int) -> String {
        var message = ""
        
        /*
         Si code = -9, afficher "Authentication was cancelled by application"
         Si code = -1, afficher "The user failed to provide valid credentials"
         ...etc
         */
        
        switch code {
        case LAError.appCancel.rawValue://-9
            message = "Authentication was cancelled by application"
            
        case LAError.authenticationFailed.rawValue://-1
            message = "The user failed to provide valid credentials"
            
        case LAError.invalidContext.rawValue://-10
            message = "The context is invalid"
            
        case LAError.passcodeNotSet.rawValue://..etc
            message = "Passcode is not set on the device"
            
        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            
        case LAError.touchIDLockout.rawValue:
            message = "Too many failed attempts."
            
        case LAError.touchIDNotAvailable.rawValue:
            message = "TouchID is not available on the device"
            
        case LAError.userCancel.rawValue:
            message = "The user did cancel"
            
        case LAError.userFallback.rawValue:
            //message = "The user chose to use the fallback"
            message = "Entrez le mot de passe"
            
        default:
            message = "Did not find error code on LAError object"
        }
        
        return message
    }
}
