//
//  MovieRecommendationsVC.swift
//  MLH Rookie hacks
//
//  Created by phani srikar on 31/05/20.
//  Copyright © 2020 phani srikar. All rights reserved.
//

import UIKit
import CSV
class MovieRecommendationsVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate{
    
    var finalResults = [Int64]()
    var finalMoviesList = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let fileURL = Bundle.main.url(forResource: "movies", withExtension: "csv")!
        let stream = InputStream(url: fileURL)!
        let moviesCSV = try! CSVReader(stream: stream,hasHeaderRow: true)
        let headerRow = moviesCSV.headerRow!
        print("\(headerRow)") // => ["id", "name"]
            while let row = moviesCSV.next() {
                var j = 0
                while(j < finalResults.count)
                {
                    if(Int64(row[0]) == finalResults[j])
                    {
                        finalMoviesList.append(row[1])
                    }
                    j += 1
                }
        }
        print(finalMoviesList)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return finalMoviesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PredictionCell", for: indexPath) as! PredictionCell
        cell.PositionIndex.text = String(indexPath.row + 1)
        cell.PredictedMovie.text = "\(finalMoviesList[indexPath.row])"
        return cell
    }
}
