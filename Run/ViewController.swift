//
//  ViewController.swift
//  Run
//
//  Created by Adrian Avram on 6/9/19.
//  Copyright © 2019 Adrian Avram. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var monthNames = ["January","February","March","April","May","June","July",
                      "August","September","October","November","December"]
    var dateFormat = DateFormatter()
    var months = [31,28,31,30,31,30,31,31,30,31,30,31]
    var date: Date = Date()
    var firstDayOfMonth: Int = 0
    var animationDuration: Double = 0.3
    
    let cellId = "Date"
    
    let selectedColor: UIColor = UIColor(red:0.00, green:0.70, blue:1.00, alpha:1.0)
    
    var collectionViewFlowLayout: UICollectionViewFlowLayout!
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormat.dateFormat = "MM YYYY"
        navigationItem.title = monthNames[date.month() - 1]
        firstDayOfMonth = date.startOfMonth()!
        setupView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupCollectionViewItemSize()
    }
    
    func setupView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: cellId)
    }
    
    func setupCollectionViewItemSize() {
        if collectionViewFlowLayout == nil {
            let numberPerRow: CGFloat = 7
            let lineSpacing: CGFloat = 5
            let interItemSpacing: CGFloat = 5
            
            let width = (collectionView.frame.width - (numberPerRow - 1) * interItemSpacing) / numberPerRow
            let height = width
            
            collectionViewFlowLayout = UICollectionViewFlowLayout()
            collectionViewFlowLayout.itemSize = CGSize(width: width, height: height)
            collectionViewFlowLayout.sectionInset = UIEdgeInsets.zero
            collectionViewFlowLayout.scrollDirection = .vertical
            collectionViewFlowLayout.minimumLineSpacing = lineSpacing
            collectionViewFlowLayout.minimumInteritemSpacing = interItemSpacing
            
            collectionView.setCollectionViewLayout(collectionViewFlowLayout, animated: true)
        }
    }
    
    
    @IBAction func nextMonth(_ sender: Any) {
        date = Calendar.current.date(byAdding: .month, value: 1, to: date)!
        updateDate()
    }
    
    @IBAction func previousMonth(_ sender: Any) {
        date = Calendar.current.date(byAdding: .month, value: -1, to: date)!
        updateDate()
    }
    
    func updateDate() {
        navigationItem.title = monthNames[date.month() - 1]
        firstDayOfMonth = date.startOfMonth()!
        collectionView.reloadData()
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 42
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CollectionViewCell
        let month = date.month() - 1
        if (indexPath.item < firstDayOfMonth) {
            cell.label.text = String(months[abs((month - 1)%12)] - firstDayOfMonth + indexPath.item + 1)
            cell.label.textColor = .gray
            cell.isUserInteractionEnabled = false
        } else if (indexPath.item - firstDayOfMonth + 1 <= months[month % 12]) {
            cell.label.text = String(indexPath.item - firstDayOfMonth + 1)
            cell.label.textColor = .black
            cell.isUserInteractionEnabled = true
        } else {
            cell.label.text = String(indexPath.item - months[month%12] + 1 - firstDayOfMonth)
            cell.label.textColor = .gray
            cell.isUserInteractionEnabled = false
        }
        cell.label.backgroundColor = .clear
        cell.label.layer.backgroundColor = UIColor.clear.cgColor
        cell.label.layer.masksToBounds = true
        cell.label.layer.cornerRadius = cell.bounds.width / 2
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
        print(dateFormat.string(from: date) + " " + cell.label.text!)
        UIView.animate(withDuration: animationDuration, animations: {
            cell.label.layer.backgroundColor = self.selectedColor.cgColor
        })
        cell.label.textColor = .white
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
        UIView.transition(with: cell.label, duration: animationDuration, options: .transitionCrossDissolve, animations: {
            cell.label.textColor = .black
        }, completion: nil)
        UIView.animate(withDuration: animationDuration, animations: {
            cell.label.layer.backgroundColor = UIColor.clear.cgColor
        })
    }
}

extension Date {
    
    func startOfMonth() -> Int? {
        let currentDateComponents = Calendar.current.dateComponents([.year, .month], from: self)
        let startOfMonth = Calendar.current.component(.weekday, from: Calendar.current.date(from: currentDateComponents)!)
        return startOfMonth - 1
    }
    
    func month() -> Int {
        return Calendar.current.component(.month, from: self)
    }
}
