//
//  TeamAnnotation.swift
//  SoccerPedia
//
//  Created by 전율 on 11/18/24.
//

import Foundation
import MapKit

class TeamAnnotation: NSObject,MKAnnotation {
    let team: TeamResponse.Team
    let logo: UIImage?
    
    init(team: TeamResponse.Team, logo: UIImage?) {
        self.team = team
        self.logo = logo
    }
    
    // dynamic: 동적 디스패치 매커니즘
    @objc dynamic var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: team.latitude, longitude: team.longitude)
    }
    
    var title: String? {
        return team.team
    }
    var subtitle: String? {
        return "\(team.stadium) \(team.capacity.formatted()) 명"
    }
}
