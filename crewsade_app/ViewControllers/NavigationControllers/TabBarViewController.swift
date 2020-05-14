//
//  TabBarViewController.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 30/04/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    @IBOutlet weak var TabBar: UITabBar!
    override func viewDidLoad() {
        super.viewDidLoad()
//        addCenterButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true

    }

//    private func addCenterButton() {
//        let button = UIButton(type: .custom)
//        let widthTabBar = TabBar.frame.size.width
//
//        button.frame = CGRect(x: (widthTabBar / 2) - 30, y: -30, width: 60, height: 60)
//        button.setTitle("+", for: .normal)
//        button.titleLabel?.font = UIFont(name: "Polly-Regular",size: 45)
//        button.layer.cornerRadius = 0.5 * button.bounds.size.width
//        button.backgroundColor = UIColor.CrewSade.mainColor
//
//        TabBar.addSubview(button)
//       // view.bringSubviewToFront(button)
//
//        button.addTarget(self, action: #selector(didTouchCenterButton(_:)), for: .touchUpInside)
//    }

    @objc private func didTouchCenterButton(_ sender: AnyObject) {
        print("!!")
    }
 

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
