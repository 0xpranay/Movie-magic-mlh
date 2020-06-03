//
//  MovieRecommendationsVC.swift
//  MLH Rookie hacks
//
//  Created by phani srikar on 31/05/20.
//  Copyright © 2020 phani srikar. All rights reserved.
//

import UIKit
import  Foundation
 let imageCache = NSCache<NSString, UIImage>()
class MovieRecommendationsVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate{
    
    var finalResults = [Int64]()
    var finalMoviesList = [MovieInstance]()
    var MoviesList = [MovieInstance]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        findMovieTitle()
        print(finalMoviesList)
    }
    
    
    @IBAction func GetMore(_ sender: Any) {performSegue(withIdentifier: SegueIdentifiers().MvReccToGenVsSurp, sender: self)
    }
    
    
    
    func findMovieTitle() {
         let fileURL = Bundle.main.url(forResource: "MoviesDataset", withExtension: "json")!
               let data = try! Data(contentsOf: fileURL)
               let decoder = JSONDecoder()
               MoviesList = try! decoder.decode([MovieInstance].self, from: data)
        
        for i in 0..<MoviesList.count {
            for j in 0..<finalResults.count
            {
                if (MoviesList[i].movieId == finalResults[j]) {
                    finalMoviesList.append(MoviesList[i])
                }
            }
           
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return finalMoviesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoviePredictionCell", for: indexPath) as! MoviePredictionCell
        
        //Temp cell details
        let delimiter = "("
        let newstr = finalMoviesList[indexPath.row].title
        let token = newstr.components(separatedBy: delimiter)
        print(token)
        cell.PredictedMovie.text = "\(token[0])"
        cell.PredictedMovieYear.text = "(\(token[1])"
        cell.PredictedMovieGenre.text = finalMoviesList[indexPath.row].genres
        // MARK:  Final cell details
//        cell.PredictedMovie.text = "\(finalMoviesList[indexPath.row].title)"
//        cell.PredictedMovieYear.text = "(\(finalMoviesList[indexPath.row].year)"
//        cell.PredictedMovieGenre.text = "(\(finalMoviesList[indexPath.row].genres)"
        //set Place holder image here
        //                          cell.PredictedMoviePoster.image = placeHolderImage
//        let posterURLString = finalMoviesList[indexPath.row].moviePoster
//        if let posterURL = URL(string: posterURLString!)
//        {
//              URLSession.shared.dataTask(with: posterURL, completionHandler: { (imgData, response, err) in
//
//                  //print("RESPONSE FROM API: \(response)")
//                  if err != nil {
//                      print("ERROR LOADING IMAGES FROM URL: \(err)")
//                      DispatchQueue.main.async {
//                        //set Place holder image here
//                          cell.PredictedMoviePoster.image = placeHolder
//                      }
//                      return
//                  }
//                  DispatchQueue.main.async {
//                      if let data = imgData {
//                          if let downloadedImage = UIImage(data: data) {
//                            imageCache.setObject(downloadedImage, forKey: NSString(string: posterURLString!))
//                            cell.PredictedMoviePoster.image = downloadedImage
//                          }
//                      }
//                  }
//              }).resume()
//        }
//        cell.PredictedMovieDescription.text = "(\(finalMoviesList[indexPath.row].description)"
        
        return cell
    }
}
