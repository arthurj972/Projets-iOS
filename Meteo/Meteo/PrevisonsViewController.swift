//
//  PrevisonsViewController.swift
//  Meteo
//
//  Created by Arthur JANSSENS on 13/05/2017.
//  Copyright © 2017 Arthur JANSSENS. All rights reserved.
//

import UIKit

class PrevisonsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var ville:String = ""
    @IBOutlet weak var barre_haut: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    var data = [Meteo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        barre_haut.topItem?.title = "Prévisons de \(ville)"
        
        do {
            let url = NSURL(string: "http://api.openweathermap.org/data/2.5/forecast?appid=79ab92ee7aba089ef7c6dbb6c96c9a54&units=metric&q=\(ville)");
            let texte:NSString = try NSString(contentsOf: url! as URL, usedEncoding: nil)
            
            let jsonData = texte.data(using: 4)
            let jsonResult: NSDictionary? = try JSONSerialization.jsonObject(with: jsonData!) as? NSDictionary
            
            if let jsonResult = jsonResult {
                let list = jsonResult["list"]! as! NSArray
                
                for meteo_ in list {
                    let meteo:NSDictionary = meteo_ as! NSDictionary
                    let dt = meteo["dt"]! as! Int
                    let main = meteo["main"]! as! NSDictionary
                    let weather_array = meteo["weather"]! as! NSArray
                    let weather = weather_array[0] as! NSDictionary
                    
                    let id_condition:Int = weather["id"] as! Int
                    let temp = main["temp"] as! Double
                    
                    self.data.append(Meteo(unix: dt, temp: temp, id_condition: id_condition))
                }
                
            }
        } catch {
            print("Erreur de conversion")
        }
    }

    @IBAction func quitter(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    // MARK: - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        //Nombre de section: Une seule
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //Nombre de cellules à afficher:
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //Customisation de notre cellule
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cellule") as! CustomTableViewCell
        
        let meteo:Meteo = self.data[indexPath.row]
        
        cell.icone.image = UIImage(named: meteo.nom_image)
        cell.degre.text = "\(meteo.temperature) °C"
        cell.description_meteo.text = meteo.description
        cell.date.text = meteo.date_string
        
        return cell
    }
}
