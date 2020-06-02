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


struct MovieInstance : Decodable
{
    let movieId : Int64
    let title : String
//    let year : String
    let genres : String
//    let description : String
//    let  moviePoster : String?
    
}

enum MovieQuestionsType
{
    case Random
    case GenreBased
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
    // Variables
    var mQuesType = MovieQuestionsType.Random
    var results:MovieRecommenderOutput?
    var ratingMoviesList = [MovieInstance]()
    var SelectedGenres : [String]?
    var MoviesList = [MovieInstance]()
    private var R1Changed : Bool = false
    private var R2Changed : Bool = false
    private var R3Changed : Bool = false
    private var R4Changed : Bool = false
        var UserRating:[Double] = [Double](repeating: 0, count: 4)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("The selected Genres are : \(SelectedGenres)")

        SetInitialRatings()
        DeocodeMoviesDataset()
        // Do any additional setup after loading the view.
        Movie1Rating.addTarget(self, action: #selector(self.Value1Changed), for: UIControl.Event.valueChanged)
        Movie2Rating.addTarget(self, action: #selector(self.Value2Changed), for: UIControl.Event.valueChanged)
        Movie3Rating.addTarget(self, action: #selector(self.Value3Changed), for: UIControl.Event.valueChanged)
        Movie4Rating.addTarget(self, action: #selector(self.Value4Changed), for: UIControl.Event.valueChanged)
        
        clapBtn.isEnabled = false
        if(mQuesType == .Random){
            GetRandomMovies(numOfMovies: 4)
        }
        else{
            GetGenreBasedMovies(numOfMovies: 4)
        }
            
        MTitle1.text = ratingMoviesList[0].title
        MTitle2.text = ratingMoviesList[1].title
        MTitle3.text = ratingMoviesList[2].title
        MTitle4.text = ratingMoviesList[3].title

    }

    @IBAction func clapBtnPressed(_ sender: Any) {
        
        let movieModel = MovieRecommender()
        let inputs = MovieRecommenderInput(items: [ratingMoviesList[0].movieId : UserRating[0],ratingMoviesList[1].movieId : UserRating[1],ratingMoviesList[2].movieId : UserRating[2],ratingMoviesList[3].movieId : UserRating[3]], k: 10, restrict_: [], exclude: [])
        results = try? movieModel.prediction(input: inputs)
        print(results?.recommendations)
        performSegue(withIdentifier: SegueIdentifiers().MovieQuesToRecomm, sender: self)
    }
    @IBAction func BackToGenVsSurp(_ sender: Any) {
        performSegue(withIdentifier: SegueIdentifiers().MoviequesToGenVsSurp, sender: self)
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
        if(segue.identifier == SegueIdentifiers().MovieQuesToRecomm){
            let destVC = segue.destination as! MovieRecommendationsVC
            destVC.finalResults = results?.recommendations as! [Int64]
        }
    }
    
    
    func DeocodeMoviesDataset()
    {
        let fileURL = Bundle.main.url(forResource: "MoviesDataset", withExtension: "json")!
        let data = try! Data(contentsOf: fileURL)
        let decoder = JSONDecoder()
        MoviesList = try! decoder.decode([MovieInstance].self, from: data)
    }
    
    func GetRandomMovies(numOfMovies : Int)  {
        for _ in 0 ... numOfMovies - 1
        {
            let randNum = Int.random(in: 0..<MoviesList.count)
            let movietoSelect = MoviesList[randNum]
            ratingMoviesList.append(movietoSelect)
        }
    }

    
    func GetGenreBasedMovies(numOfMovies num : Int) {
        if(num <= 0){
            return
        }
        let randNum = Int.random(in: 0..<MoviesList.count)
        var simIdx : Float = 0
        let thersholdSimIdx : Float = 0
        let delimiter = "|"
        let newstr = MoviesList[randNum].genres
        let movieGenres = newstr.components(separatedBy: delimiter)
        let minSimIdx : Float = 1 / Float(SelectedGenres!.count + movieGenres.count)
        for sm in 0..<SelectedGenres!.count{
            for gm in 0..<movieGenres.count{
//                print("Selected Genre : \(SelectedGenres![sm]) and MovieGenre : \(movieGenres[gm])")
                let compStr : String = SelectedGenres![sm]
                if(compStr == movieGenres[gm]){
                    simIdx += (minSimIdx)
                }
                else{
                    simIdx += 0
                }
            }
        }
        if(simIdx > thersholdSimIdx){
            ratingMoviesList.append(MoviesList[randNum])
            GetGenreBasedMovies(numOfMovies: num - 1)
        }
        else{
            GetGenreBasedMovies(numOfMovies: num)
        }
    }
}
