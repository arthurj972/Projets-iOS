//
//  ViewController.swift
//  Touch ID
//
//  Created by Arthur JANSSENS on 28/02/2017.
//  Copyright © 2017 Arthur JANSSENS. All rights reserved.
//

import UIKit
import LocalAuthentication


class ViewController: UIViewController {

    @IBOutlet weak var infoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if #available(iOS 9.0, *) {
            //A partir de iOS 9
            
            let authenticationContext = LAContext()
            var error: NSError?
            
            if authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                authenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Posez votre doigt sur le capteur d'empreinte pour dévérouiller votre application", reply: { (success: Bool, error: Error?) in
                    
                    if success {
                        //Empreinte OK
                        self.performSegue(withIdentifier: "mdp_ok", sender: self)
                    } else {
                        //L'utilisateur à annulé ou choisi de rentrer un mot de passe à la place
                        if let evaluateError = error as? NSError {
                            let code_erreur:Int = evaluateError.code
                            let msg_erreur:String = self.getInfoAvecCode(code: code_erreur)
                            
                            self.infoLabel.text = msg_erreur
                            
                            if( code_erreur == LAError.userFallback.rawValue ){
                                //L'utilisateur préfère rentrer son mot de passe
                                self.demanderMotDePasse()
                            }
                        }
                    }
                    
                })
            } else {
                //Si il n'y a pas pas de lecteur d'empreinte digitale
                demanderMotDePasse()
            }
        } else {
            //Si on est dans iOS inférieur à la version 9.0
            demanderMotDePasse()
        }
        
        
    }
    
    func demanderMotDePasse() {
        infoLabel.text = "Entrez votre mot de passe"
        //Faire quelque chose pour demander le mot de passe à la place
        //Ce doit être votre propre systeme..
        //...
    }
    
    //Optionel, juste pour mettre des message personalisés, traduisez-les :)
    func getInfoAvecCode(code: Int) -> String {
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

