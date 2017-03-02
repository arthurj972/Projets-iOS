//
//  ParametreViewController.swift
//  Touch ID
//
//  Created by Arthur JANSSENS on 28/02/2017.
//  Copyright © 2017 Arthur JANSSENS. All rights reserved.
//

import UIKit
import LocalAuthentication

class ParametreViewController: UIViewController {
    
    @IBOutlet weak var touchIdSwitch: UISwitch!
    let maVariableIneffacable:UserDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        touchIdSwitch.addTarget(self, action: #selector(evenementSwitch(leSwitch:)), for: UIControlEvents.valueChanged)
        
        let deverouillerParTouchID:Bool = maVariableIneffacable.bool(forKey: "deverouillerParTouchID") as Bool
        if(deverouillerParTouchID) {
            //Metre à ON quand l'utilisateur à déjà validé son empreinte et revient sur l'application
            touchIdSwitch.setOn(true, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func evenementSwitch(leSwitch: UISwitch) {
        if leSwitch.isOn {
            verifEmpreinteDigitale()
        } else {
            self.maVariableIneffacable.set(false, forKey: "deverouillerParTouchID")
        }
    }
    
    func verifEmpreinteDigitale() {
        if #available(iOS 9.0, *) {
            //A partir de iOS 9
            
            let myContext = LAContext()
            let myLocalizedReasonString = "Posez votre doigt sur le capteur d'empreinte pour confirmé"
            
            var authError: NSError? = nil
            if myContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                myContext.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReasonString) { (success, evaluateError) in
                    if (success) {
                        //Empreinte OK
                        self.maVariableIneffacable.set(true, forKey: "deverouillerParTouchID")
                    } else {
                        //L'utilisateur a annulé
                        self.touchIdSwitch.setOn(false, animated: true)//Metre à OFF
                        self.alert("Impossible", "Impossible d'effectuer l'action")
                    }
                    
                }
            } else {
                alert("Introuvable", "Vous n'avez pas de lecteur d'empreinte digitale")
                touchIdSwitch.setOn(false, animated: true)//Metre à OFF
            }
        } else {
            alert("Introuvable", "Vous n'avez pas de lecteur d'empreinte digitale")
            touchIdSwitch.setOn(false, animated: true)//Metre à OFF
        }
    }
    
    func alert(_ titre: String, _ message: String) {
        let alert = UIAlertController(title: titre, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    
}
