//
//  Team.swift
//  SoccerPedia
//
//  Created by 전율 on 11/18/24.
//

import Foundation

struct TeamResponse:Codable {
    let totalCount: Int
    let list:[Team]
    let code: Int
    let message: String?
    
    struct Team: Codable {
        let description: String
        let team: String
        let stadium: String
        let capacity: Int
        let latitude: Double
        let longitude: Double
        let country: String
    }

}


extension String:Error {
    
}
