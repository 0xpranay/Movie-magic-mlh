//
//  GenreSelectionVC.swift
//  MLH Rookie hacks
//
//  Created by phani srikar on 01/06/20.
//  Copyright © 2020 phani srikar. All rights reserved.
//

import UIKit
import Magnetic
import SpriteKit

class GenreSelectionVC: UIViewController {

    var GenreSelection = [String]()
    private var stopAdding = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        magneticView.magnetic.backgroundColor = #colorLiteral(red: 0.9121802137, green: 0.2071547611, blue: 0.2025774069, alpha: 1)
    }
    
    
    @IBAction func BackBtn(_ sender: Any) {
        performSegue(withIdentifier: SegueIdentifiers().GenselectionToGenVsSurp, sender: self)
    }
    
    
      //MARK: Magneti View Configurations
        
         @IBOutlet weak var magneticView: MagneticView! {
                didSet {
                    magnetic.magneticDelegate = self
                    magnetic.removeNodeOnLongPress = false
//                    #if DEBUG
//                    magneticView.showsFPS = true
//                    magneticView.showsDrawCount = true
//                    magneticView.showsQuadCount = true
//                    magneticView.showsPhysics = true
//                    #endif
                }
            }
            
            var magnetic: Magnetic {
                return magneticView.magnetic
            }
            
            override func viewDidAppear(_ animated: Bool) {
                super.viewDidAppear(animated)
                
                for i in 0..<12 {
                    add(nil,index: i)
                }
            }
            
    @IBOutlet weak var DoneBtn: UIButton!
    @IBAction func add(_ sender: UIControl?, index idx : Int) {
                let name = UIImage.names[idx]
                let color = UIColor.colors.randomItem()
                let node = Node(text: name.capitalized, image: UIImage(named: name), color: color, radius: 40)
                node.scaleToFitContent = true
                node.selectedColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                node.selectedFontColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                magnetic.addChild(node)
                // Image Node: image displayed by default
                // let node = ImageNode(text: name.capitalized, image: UIImage(named: name), color: color, radius: 40)
                // magnetic.addChild(node)
            }
            
    @IBAction func reset(_ sender: UIControl?) {
            let speed = magnetic.physicsWorld.speed * 1.25
            magnetic.physicsWorld.speed = 0
            let sortedNodes = magnetic.children.compactMap { $0 as? Node }.sorted { node, nextNode in
                let distance = node.position.distance(from: magnetic.magneticField.position)
                let nextDistance = nextNode.position.distance(from: magnetic.magneticField.position)
                return distance < nextDistance && node.isSelected
            }
            var actions = [SKAction]()
            for (index, node) in sortedNodes.enumerated() {
                node.physicsBody = nil
                let action = SKAction.run { [unowned magnetic, unowned node] in
                    if node.isSelected {
                        let point = CGPoint(x: magnetic.size.width / 2, y: magnetic.size.height + 40)
                        let movingXAction = SKAction.moveTo(x: point.x, duration: 0.2)
                        let movingYAction = SKAction.moveTo(y: point.y, duration: 0.4)
                        let resize = SKAction.scale(to: 0.3, duration: 0.4)
                        let throwAction = SKAction.group([movingXAction, movingYAction, resize])
                        node.run(throwAction) { [unowned node] in
                            node.removeFromParent()
                        }
                    }else{
                        node.removeFromParent()
                    }
                }
                actions.append(action)
                let delay = SKAction.wait(forDuration: TimeInterval(index) * 0.002)
                actions.append(delay)
            }
            magnetic.run(.sequence(actions)) { [unowned magnetic] in
                magnetic.physicsWorld.speed = speed
            }
    }
    
    
    @IBAction func DoneBtnPressed(_ sender: Any) {
        if(!GenreSelection.isEmpty){
                  reset(nil)
                  DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: {
                   self.performSegue(withIdentifier: "GenreToQues", sender: self)
                   })
               }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == SegueIdentifiers().GenreToQues){
            let quesVC = segue.destination as! MovieQuestionsVC
            quesVC.SelectedGenres = GenreSelection
            quesVC.mQuesType = .GenreBased
        }
    }

}

    // MARK: - MagneticDelegate
    extension GenreSelectionVC: MagneticDelegate {
        
        func magnetic(_ magnetic: Magnetic, didSelect node: Node) {
            print("didSelect -> \(node)")
            GenreSelection.append(node.text!)
        }
        
        func magnetic(_ magnetic: Magnetic, didDeselect node: Node) {
            print("didDeselect -> \(node)")
            
            GenreSelection.remove(at: GenreSelection.firstIndex(of: node.text!)!)
        }
        
        func magnetic(_ magnetic: Magnetic, didRemove node: Node) {
            print("didRemove -> \(node)")
        }
        
    }

    // MARK: - ImageNode
    class ImageNode: Node {
        override var image: UIImage? {
            didSet {
                texture = image.map { SKTexture(image: $0) }
            }
        }
    }

