//
//  DetailViewController.swift
//  SoccerPedia
//
//  Created by 전율 on 11/18/24.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    var team: TeamResponse.Team?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        teamLabel.text = team?.team
        descriptionTextView.text = team?.description
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
