//
//  ViewController.swift
//  Meteo
//
//  Created by Arthur JANSSENS on 13/05/2017.
//  Copyright © 2017 Arthur JANSSENS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var image_fond: UIImageView!
    @IBOutlet weak var degre: UILabel!
    @IBOutlet weak var icone: UIImageView!
    @IBOutlet weak var description_meteo: UILabel!
    @IBOutlet weak var ville: UITextField!
    @IBOutlet weak var date: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rechercher(ville: "Paris")
    }
    
    func rechercher(ville:String) {
        do {
            let url = NSURL(string: "http://api.openweathermap.org/data/2.5/weather?appid=79ab92ee7aba089ef7c6dbb6c96c9a54&units=metric&q=\(ville)");
            let texte:NSString = try NSString(contentsOf: url! as URL, usedEncoding: nil)
            
            let jsonData = texte.data(using: 4)
            let jsonResult: NSDictionary? = try JSONSerialization.jsonObject(with: jsonData!) as? NSDictionary
            
            if let jsonResult = jsonResult {
                let weather_array = jsonResult["weather"] as! NSArray
                let weather = weather_array[0] as! NSDictionary
                let main = jsonResult["main"] as! NSDictionary
                let dt = jsonResult["dt"]! as! Int
                
                let id_condition:Int = weather["id"] as! Int
                let temp = main["temp"] as! Double
                
                let meteo:Meteo = Meteo(unix: dt, temp: temp, id_condition: id_condition)
                afficher(m: meteo)
            }
        } catch {
            print("Erreur de conversion")
        }
    }

    func afficher(m:Meteo) {
        icone.image = UIImage(named: m.nom_image)
        image_fond.image = UIImage(named: "f-"+m.nom_image)
        degre.text = "\(m.temperature) °C"
        description_meteo.text = m.description
        date.text = "Dernière mise à jour le \(m.date_string)"
    }
    
    @IBAction func rechercher(_ sender: UIButton) {
        rechercher(ville: ville.text!)
    }
    
    
    //MARK - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="aller_vers_previsons"){
            let previsonsVC:PrevisonsViewController = segue.destination as! PrevisonsViewController
            previsonsVC.ville = ville.text!
        }
    }


}

