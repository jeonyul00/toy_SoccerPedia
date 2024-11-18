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
        mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: String(describing:  TeamAnnotation.self))
        
        Task {
            let list = try await fetch()
            let pointMakers: [MKAnnotation] = list.map {
                if let image = UIImage(named: $0.team) {
                    return TeamAnnotation(team: $0, logo: image)
                } else {
                    let pin = MKPointAnnotation()
                    pin.title = $0.team
                    pin.subtitle = "\($0.stadium) \($0.capacity.formatted()) 명"
                    pin.coordinate = CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
                    return pin
                }
                
            }
            mapView.addAnnotations(pointMakers)
            let region = MKCoordinateRegion(center: pointMakers.first!.coordinate, latitudinalMeters: 50000, longitudinalMeters: 50000)
            mapView.setRegion(region, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DetailViewController {
            vc.team = sender as? TeamResponse.Team
            vc.sheetPresentationController?.detents = [.medium()]
            
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
        if let teamAnnotation = annotation as? TeamAnnotation {
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: String(describing: TeamAnnotation.self), for: annotation)
            annotationView.image = teamAnnotation.logo
            annotationView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            annotationView.canShowCallout = true
            let imgView = UIImageView(image: teamAnnotation.logo)
            imgView.frame = CGRect(x: 0, y: 0, width: annotationView.frame.height, height: annotationView.frame.height)
            annotationView.leftCalloutAccessoryView = imgView
            let btn = UIButton(type: .infoLight)
            annotationView.rightCalloutAccessoryView = btn
            return annotationView
        }
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier, for: annotation) as? MKMarkerAnnotationView else { return nil }
        annotationView.markerTintColor = .systemBlue
        annotationView.glyphImage = UIImage(systemName: "soccerball")
        annotationView.glyphTintColor = .systemYellow
        annotationView.selectedGlyphImage = UIImage(systemName: "checkmark.circle.fill")
        return annotationView
    }
    
    // 악세사리뷰에서 버튼 클릭 시 호출
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let teamAnnotation = view.annotation as? TeamAnnotation else { return }
        performSegue(withIdentifier: "detailSegue", sender: teamAnnotation.team)
    }
}
