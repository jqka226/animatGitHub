//
//  ViewController.swift
//  animat
//
//  Created by 潘政杰 on 2020/1/7.
//  Copyright © 2020 潘政杰. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func tap(_ sender: Any) {
        
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 5, delay: 0, animations: {self.image.frame.origin = CGPoint(x: self.image.center.x, y: 0)
            
        })
    
    }
}

