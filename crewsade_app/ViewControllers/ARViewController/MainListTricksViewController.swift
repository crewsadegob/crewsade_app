//
//  MainListTricksViewController.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 01/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class MainListTricksViewController: ViewController {
    
// MARK: - VARIABLES
    
    @IBOutlet weak var carouselTrick: UICollectionView!
    @IBOutlet weak var mainListTricksTable: UITableView!
    @IBOutlet weak var ctaButton: UIButton!
    
    let db = Firestore.firestore()
    
    var tricksSaved = [Trick]()
    var tricks = [Trick]()
    
// MARK: - LIFECYCLE & OVERRIDES
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.topItem?.title = "TRAINING";

        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background.png")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        ctaButton.layer.cornerRadius = 4.0
        ctaButton.addTextSpacing(6.0)
        
        mainListTricksTable.dataSource = self
        mainListTricksTable.delegate = self
        
        carouselTrick.dataSource = self
        carouselTrick.delegate = self
        
        UserService().getTricksSaved(){ result in
            if let tricksSaved = result{
                self.tricksSaved = tricksSaved
                self.mainListTricksTable.reloadData()

            }
        }
        
        TrickService().getTricks(){ result in
            if let tricks = result{
                self.tricks = tricks
                let screenSize = UIScreen.main.bounds.size

                let cellWidth = CGFloat(160.0)
                let cellHeight = CGFloat(240.0)
                
                let layout = self.carouselTrick.collectionViewLayout as! UICollectionViewFlowLayout
                   layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
                self.carouselTrick.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                   
                self.carouselTrick.reloadData()
            }
        }
    }
    
// MARK: - ACTIONS
    
    @objc private func buttonSaveClicked(_ sender: UIButton) {
        
        if let trickClicked = tricksSaved[sender.tag].reference{
            UserService().deleteTrick(trick: trickClicked)
            mainListTricksTable.reloadData()
        }
        
    }
    
    @objc private func emptyList(_ sender: UIButton) {
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "AR", bundle: nil)
        let mainViewController = mainStoryboard.instantiateViewController(identifier: "ListTricksViewController")
        self.show(mainViewController, sender: nil)
         
    }
}

// MARK: - EXTENSIONS

extension MainListTricksViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tricksSaved.count > 0 {
            return tricksSaved.count
        }
        else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainListTricksCell",for: indexPath) as! MainListTrickTableViewCell
        
        cell.contentView.backgroundColor = UIColor.clear
        
        let roundedView : UIView = UIView(frame: CGRect(x: 0, y: 10, width: cell.frame.size.width, height: 100))
        roundedView.layer.backgroundColor = UIColor.CrewSade.secondaryColorLight.cgColor
        roundedView.layer.masksToBounds = false
        roundedView.layer.cornerRadius = 15.0

        
        cell.contentView.addSubview(roundedView)
        cell.contentView.sendSubviewToBack(roundedView)
    

        
        if tricksSaved.count > 0 {
            cell.nameLabel?.text = tricksSaved[indexPath.row].name?.uppercased()
            cell.saveButton.isHidden = false
            cell.saveButton.tag = indexPath.row
            cell.saveButton.addTarget(self, action: #selector(self.buttonSaveClicked(_:)), for: .touchUpInside)
            cell.addTrick.isHidden = true

        }else{
            cell.nameLabel?.text = ""
            cell.saveButton.isHidden = true
            cell.learnTrick.isHidden = true
            cell.addTrick.isHidden = false
        }
        
    

        return cell
    }
    
}

extension MainListTricksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

extension MainListTricksViewController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tricks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrickCell", for: indexPath) as! CarouselTricksCollectionViewCell
        
        cell.trick = tricks[indexPath.item]
        cell.contentView.backgroundColor = UIColor.CrewSade.secondaryColorLight
        cell.contentView.layer.cornerRadius = 15.0
        
        return cell
        
    }
}

extension MainListTricksViewController: UIScrollViewDelegate, UICollectionViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let layout = self.carouselTrick.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
        
    }
}
