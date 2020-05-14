//
//  OnBoardingViewController.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 07/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit

class OnBoardingViewController: UIViewController {

    @IBOutlet weak var OnBoardingButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        OnBoardingButton.addTextSpacing(3.0)
        OnBoardingButton.layer.cornerRadius = 4.0

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}
