//
//  ViewController.swift
//  SoccerPedia
//
//  Created by 전율 on 11/18/24.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func fetch() async throws -> [TeamResponse.Team] {
        guard let url = URL(string: "https://kxapi.azurewebsites.net/team?apiKey=Vp3lkFGT4CyPC5t8vF8D") else { throw "invalid url" }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { throw "invalid reponse" }
        let teamResponse = try JSONDecoder().decode(TeamResponse.self, from: data)
        return teamResponse.list
    }
    
    
}

