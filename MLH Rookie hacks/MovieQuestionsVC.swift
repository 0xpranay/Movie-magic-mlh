//
//  ViewController.swift
//  MLH Rookie hacks
//
//  Created by phani srikar on 30/05/20.
//  Copyright © 2020 phani srikar. All rights reserved.
//

import UIKit
import HCSStarRatingView
import CoreML
import CSV



struct MovieInstance : Decodable
{
    let movieId : Int64
    let title : String
    let genres : String
}


class MovieQuestionsVC: UIViewController {

    // MARK: References and IBOutlets

// Movie title labels
    @IBOutlet weak var MTitle1: UILabel!
    @IBOutlet weak var MTitle2: UILabel!
    @IBOutlet weak var MTitle3: UILabel!
    @IBOutlet weak var MTitle4: UILabel!
// Move Ratings
    @IBOutlet weak var Movie1Rating: HCSStarRatingView!
    @IBOutlet weak var Movie2Rating: HCSStarRatingView!
    @IBOutlet weak var Movie3Rating: HCSStarRatingView!
    @IBOutlet weak var Movie4Rating: HCSStarRatingView!
    
    @IBOutlet weak var clapBtn: UIButton!
    var results:MovieRecommenderOutput?
    
    var ratingMoviesList = [String]()
    var ratingMoviesListIndex = [Int64]()

    
    var MoviesList = [MovieInstance]()
    
    
    @IBAction func clapBtnPressed(_ sender: Any) {
        
        let movieModel = MovieRecommender()
        let inputs = MovieRecommenderInput(items: [ratingMoviesListIndex[0] : UserRating[0],ratingMoviesListIndex[1] : UserRating[1],ratingMoviesListIndex[2] : UserRating[2],ratingMoviesListIndex[3] : UserRating[3]], k: 10, restrict_: [], exclude: [])
        results = try? movieModel.prediction(input: inputs)
        print(results?.recommendations)
        performSegue(withIdentifier: "MovieRecommendations", sender: self)
    }
    

    
    // variables
    private var R1Changed : Bool = false
    private var R2Changed : Bool = false
    private var R3Changed : Bool = false
    private var R4Changed : Bool = false
    
    var UserRating:[Double] = [Double](repeating: 0, count: 4)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetInitialRatings()
        // Do any additional setup after loading the view.
        Movie1Rating.addTarget(self, action: #selector(self.Value1Changed), for: UIControl.Event.valueChanged)
        Movie2Rating.addTarget(self, action: #selector(self.Value2Changed), for: UIControl.Event.valueChanged)
        Movie3Rating.addTarget(self, action: #selector(self.Value3Changed), for: UIControl.Event.valueChanged)
        Movie4Rating.addTarget(self, action: #selector(self.Value4Changed), for: UIControl.Event.valueChanged)
        
        clapBtn.isEnabled = false
        GetRandomMovies(numOfMovies: 4)
        MTitle1.text = ratingMoviesList[0]
        MTitle2.text = ratingMoviesList[1]
        MTitle3.text = ratingMoviesList[2]
        MTitle4.text = ratingMoviesList[3]

    }


    @objc func Value1Changed()
    {
        UserRating[0] = Double(Float(Movie1Rating.value))
//        print(UserRating)
        R1Changed = true
        CheckFinalisingInput()
    }
    @objc func Value2Changed()
    {
        UserRating[1] = Double(Float(Movie2Rating.value))
//        print(UserRating)
        R2Changed = true
        CheckFinalisingInput()
    }
    @objc func Value3Changed()
    {
        UserRating[2] = Double(Float(Movie3Rating.value))
//        print(UserRating)
        R3Changed = true
        CheckFinalisingInput()
    }
    @objc func Value4Changed()
    {
        UserRating[3] = Double(Float(Movie4Rating.value))
//        print(UserRating)
        R4Changed = true
        CheckFinalisingInput()
    }
    
    func SetInitialRatings()  {
        UserRating[0] = Double(Float(Movie1Rating.value))
        UserRating[1] = Double(Float(Movie2Rating.value))
        UserRating[2] = Double(Float(Movie3Rating.value))
        UserRating[3] = Double(Float(Movie4Rating.value))
    }
    func CheckFinalisingInput()
    {
        if(R1Changed && R2Changed && R3Changed && R4Changed)
        {
            clapBtn.isEnabled = true
            PulseFX()
            print(UserRating)
        }
    }
    func PulseFX()
    {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        
        pulse.duration = 0.4
        pulse.fromValue = 0.98
        pulse.toValue = 1
        pulse.autoreverses = true
        pulse.repeatCount = .infinity
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        clapBtn.layer.add(pulse,forKey:nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destVC = segue.destination as! MovieRecommendationsVC
        destVC.finalResults = results?.recommendations as! [Int64]
    }
    
    
    func GetRandomMovies(numOfMovies : Int)  {
        //from here
                let fileURL = Bundle.main.url(forResource: "MoviesDataset", withExtension: "json")!
        let data = try! Data(contentsOf: fileURL)
            
        let decoder = JSONDecoder()
        MoviesList = try! decoder.decode([MovieInstance].self, from: data)
                
        for i in 0 ... numOfMovies - 1
        {
            let randNum = Int.random(in: 0..<9000)
            let movietoSelect = MoviesList[randNum].title
            ratingMoviesList.append(movietoSelect)
            ratingMoviesListIndex.append(MoviesList[randNum].movieId)
        }
        
        
           }
}

