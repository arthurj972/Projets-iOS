//
//  Meteo.swift
//  Meteo
//
//  Created by Arthur JANSSENS on 13/05/2017.
//  Copyright © 2017 Arthur JANSSENS. All rights reserved.
//

import Foundation

class Meteo {
    
    var date_string:String = ""
    var temperature:Double = 0.0
    var description:String = ""
    var nom_image:String = ""
    
    init(unix:Int, temp:Double, id_condition:Int) {
        traiter_date(unix: unix)
        traiter_conditions(id: id_condition)
        self.temperature = temp
    }
    
    private func traiter_date(unix:Int) {
        let ns_date = NSDate(timeIntervalSince1970: TimeInterval(unix))
        let date:Date = ns_date as Date
        
        let date_formatter:DateFormatter = DateFormatter()
        date_formatter.dateFormat = "dd MMM YYYY à HH:mm" //03 Mai 2017 à 09:00
        self.date_string = date_formatter.string(from: date)+"H"
    }
    
    private func traiter_conditions(id:Int) {
        switch id {
        case 200...232:
            self.nom_image = "11d.png"
            self.description = "Orage"
        case 300...321, 520...531:
            self.nom_image = "09d.png"
            self.description = "Pluie nuageuse"
        case 500...504:
            self.nom_image = "10d.png"
            self.description = "Pluie ensoleillé"
        case 511:
            self.nom_image = "13d.png"
            self.description = "Pluie verglaçante"
        case 800:
            self.nom_image = "01d.png"
            self.description = "Ciel clair"
        case 801...804:
            self.nom_image = "03d.png"
            self.description = "Nuageux"
        default:
            self.nom_image = "01d.png"
            self.description = "Ciel clair"
        }
    }
}
