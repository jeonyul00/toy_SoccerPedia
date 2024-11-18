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
        mapView.delegate = self
        Task {
            let list = try await fetch()
            let pointMakers = list.map {
                let pin = MKPointAnnotation()
                pin.title = $0.team
                pin.subtitle = "\($0.stadium) \($0.capacity.formatted()) 명"
                pin.coordinate = CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
                return pin
            }
            mapView.addAnnotations(pointMakers)
            let region = MKCoordinateRegion(center: pointMakers.first!.coordinate, latitudinalMeters: 50000, longitudinalMeters: 50000)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func fetch() async throws -> [TeamResponse.Team] {
        guard let url = URL(string: "https://kxapi.azurewebsites.net/team?apiKey=Vp3lkFGT4CyPC5t8vF8D") else { throw "invalid url" }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { throw "invalid reponse" }
        let teamResponse = try JSONDecoder().decode(TeamResponse.self, from: data)
        return teamResponse.list
    }
        
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier, for: annotation) as? MKMarkerAnnotationView else { return nil }
        annotationView.markerTintColor = .systemBlue
        annotationView.glyphImage = UIImage(systemName: "soccerball")
        annotationView.glyphTintColor = .systemYellow
        annotationView.selectedGlyphImage = UIImage(systemName: "checkmark.circle.fill")
        return annotationView
    }
}
