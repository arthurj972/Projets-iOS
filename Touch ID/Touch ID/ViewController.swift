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
    @IBOutlet weak var motDePasse: UITextField!
    var motDePasseTest:String = "12341234"
    
    /* NSUserDefaults est capable de stoquer:
     NSData, NSString, NSNumber, NSDate, NSArray, ou NSDictionary.
     https://developer.apple.com/library/prerelease/ios/documentation/Cocoa/Reference/Foundation/Classes/NSUserDefaults_Class/index.html
     */
    let maVariableIneffacable:UserDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let deverouillerParTouchID:Bool = maVariableIneffacable.bool(forKey: "deverouillerParTouchID") as Bool
        if(deverouillerParTouchID) {
            verifParEmpreinteDigitale()
        }
        //Sinon, l'authentification par mot de passe est proposé dans tous les cas
        
    }
    
    func verifParEmpreinteDigitale() {
        if #available(iOS 9.0, *) {
            //A partir de iOS 9
            
            let myContext = LAContext()
            let myLocalizedReasonString = "Posez votre doigt sur le capteur d'empreinte pour dévérouiller votre application"
            
            var authError: NSError? = nil
            if myContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                myContext.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReasonString) { (success, evaluateError) in
                    if (success) {
                        //Empreinte OK
                        self.performSegue(withIdentifier: "mdp_ok", sender: self)
                    } else {
                        //L'utilisateur à annulé ou choisi de rentrer un mot de passe à la place
                        if let evaluateError = evaluateError as? NSError {
                            let code_erreur:Int = evaluateError.code
                            let msg_erreur:String = Fonctions.getInfoAvecCode(code: code_erreur)
                            
                            self.infoLabel.text = msg_erreur
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func verifParMDP(_ sender: UIButton) {
        if( motDePasse.text == motDePasseTest ){
            self.performSegue(withIdentifier: "mdp_ok", sender: self)
        } else {
            infoLabel.text = "Mot de passe incorect"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

