//
//  ScoreViewController.swift
//  animat
//
//  Created by 潘政杰 on 2020/1/7.
//  Copyright © 2020 潘政杰. All rights reserved.
//

import UIKit

class ScoreViewController: UIViewController {
    var nameText:String = " "


    @IBOutlet weak var myPoint: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        myPoint.text = nameText

    }
    @IBAction func backButton(_ sender: Any) {
               dismiss(animated: false)
        }
    }
