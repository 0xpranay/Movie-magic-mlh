//
//  GenreVsSurpVC.swift
//  MLH Rookie hacks
//
//  Created by phani srikar on 01/06/20.
//  Copyright © 2020 phani srikar. All rights reserved.
//

import UIKit



class GenreVsSurpVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
   
    @IBAction func GenreBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: SegueIdentifiers().GenreSelection, sender: self)
    }
    
    
    @IBAction func SurpriseBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: SegueIdentifiers().SurpriseMovieQuestions, sender: self)
    }
        
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == SegueIdentifiers().SurpriseMovieQuestions){
            let quesVC = segue.destination as! MovieQuestionsVC
            quesVC.mQuesType = .Random
        }
    }
}
