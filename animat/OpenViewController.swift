//
//  OpenViewController.swift
//  animat
//
//  Created by 潘政杰 on 2020/1/7.
//  Copyright © 2020 潘政杰. All rights reserved.
//

import UIKit
import GameplayKit

class OpenViewController: UIViewController {

    
    
    @IBOutlet var cardCollections: [UIButton]!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var flipPointLabel: UILabel!
    
    let face = [UIImage(named: "a"),UIImage(named: "b"),UIImage(named: "c"),UIImage(named: "d"),UIImage(named: "e"),UIImage(named: "f")]
    var faceArray = [UIImage]()
    var  counter = 0.0
    var timer:Timer?
    var isPlaying = false
    var count = 0
    var sum = 0
    var point = 0
    
    
    override func viewDidLoad() {
          super.viewDidLoad()
          gameInit()
            
      }
    
    var flipCount: Int = 0{
        didSet{
            flipPointLabel.text = String(flipCount)
        }
    }
    
    struct MatchState {
        var isOnBinding = false
        var bindCardIdentifier: Int = 0
        var bindCardCollectionIndex: Int? = nil
        var timeoutHolding = false
    }
    var matchState = MatchState()
    
    @objc func UpdateTimer() {
        counter = counter + 1.0
        
        if Float(counter) == 180.0 {
            timer?.invalidate()
            timer = nil
            isPlaying = false
            let controller = UIAlertController(title: "You lose QQ", message: "回家練練再來吧！", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
        }
        timeLabel.text = String(format: "%.1f", counter)
        
    }
    
    
    @IBAction func touchCard(_ sender: UIButton) {
        if timer == nil{
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
        }
        
        
            isPlaying = true
        //注意
        if let cardIndex = cardCollections.firstIndex(of: sender), !cards[cardIndex].isMatch ,
            !matchState.timeoutHolding{
            
            //是否是還沒翻過牌（兩次的第一次）
            if !matchState.isOnBinding{
                matchState.isOnBinding = true
                matchState.bindCardIdentifier = cards[cardIndex].identifier
                matchState.bindCardCollectionIndex = cardIndex
                flipCount += 1
                
                sender.setImage(cards[cardIndex].cardImage, for: .normal)
                UIView.transition(with: sender, duration: 0.3, options: .transitionFlipFromRight, animations: nil, completion: nil)
            }
            else{
                if let bindingIndex = matchState.bindCardCollectionIndex, bindingIndex !=
                    cardIndex{
                    
                    matchState.isOnBinding = false
                    flipCount += 1
                    //判斷是否相同
                    sender.setImage(cards[cardIndex].cardImage, for: .normal)
                    UIView.transition(with: sender, duration: 0.3, options: .transitionFlipFromRight, animations: nil, completion: nil)
                    
                    if matchState.bindCardIdentifier == cards[cardIndex].identifier{
                        
                        viewCardChange(for: bindingIndex, withImage: matchImage, transFrom: .transitionFlipFromTop)
                        cards[bindingIndex].isMatch = true
                        viewCardChange(for: cardIndex, withImage: matchImage, transFrom: .transitionFlipFromTop)
                        cards[cardIndex].isMatch = true
                        count = count + 1
                        point = point + 20
                        if (count == 6) {
                            sum = point - flipCount
                            if let controller = storyboard?.instantiateViewController(withIdentifier: "scorepage")as? ScoreViewController {
                                controller.nameText = String(sum)
                                present(controller, animated: true, completion: nil)
                            }
                        }
                    }
                    else{
                        matchState.timeoutHolding = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.viewCardChange(for: bindingIndex, withImage: self.backImage, transFrom: .transitionFlipFromLeft)
                                self.viewCardChange(for: cardIndex, withImage: self.backImage, transFrom: .transitionFlipFromLeft)
                            self.matchState.timeoutHolding = false
                        }
                    }
                }
            }
        }
        }
    
    func viewCardChange (for cardIndex: Int, withImage: UIImage, transFrom: UIView.AnimationOptions){
           
           cardCollections[cardIndex].setImage(withImage, for: .normal)
        UIView.transition(with: cardCollections[cardIndex], duration: 0.8, options: transFrom, animations: nil, completion: nil)
           
       }
    
    let backImage = UIImage(named: "ba")!
    let matchImage = UIImage(named: "ok")!
    var cards = [Card]()
    
    struct Card {
        var cardImage:UIImage
        let identifier: Int
        var isMatch:Bool
        
    }
    
    
    func gameInit() {
        faceArray = [UIImage]()
        cards = [Card]()
        choiceFace()//亂數取出圖案
        
        //將圖案分配給卡片
        for i in cardCollections.indices {
            let btn = cardCollections[i]
            let card = Card(cardImage: faceArray[i], identifier: face.firstIndex(of: faceArray[i])! , isMatch: false)
            
            cards.append(card)
            btn.setImage(backImage, for: .normal)
        }
    }
    
    //取出目前所有卡片二分之一的圖案
    func choiceFace() {
        let randomOfnums = GKShuffledDistribution(lowestValue: 0, highestValue: face.count - 1)
        let numberOfPairsOfCards = Int(cardCollections.count / 2)
        for _ in 0 ..< numberOfPairsOfCards{
            let index = randomOfnums.nextInt()
            if let faceX = face[index] {
                faceArray.append(faceX)
                faceArray.append(faceX)
            }
        }
        faceArray.shuffle()
    }
    

    @IBAction func resetBtn(_ sender: UIButton) {
        gameInit()
        flipCount = 0
        isPlaying = false
        timer?.invalidate()
        timer = nil
        counter = 0.0
        timeLabel.text = String(counter)
        count = 0
    }
}
    extension Array{
        mutating func shuffle() {
            for _ in 0 ..< self.count {
                sort{(_,_) in arc4random() < arc4random()}
            }
        }
    }

