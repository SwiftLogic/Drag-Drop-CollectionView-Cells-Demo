//
//  PhotoGridCollectionViewController.swift
//  DragDropCollectionViewDemo
//
//  Created by Osaretin Uyigue on 7/24/22.
//

import UIKit

class PhotoGridCollectionViewController: UICollectionViewController {

    
    //MARK: - View's LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        collectionView.backgroundColor = .white
        setUpCollectionView()
        configureNavBar()
    }
    
    
    //MARK: - Properties
    private var colors = [UIColor]()

    
    //MARK: - Methods
    fileprivate func setUpCollectionView() {
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.cellReuseIdentifier)
                
        for _ in 0 ... 20 {
            colors.append(generateRandomColor())
        }
        
    }

    
    fileprivate func configureNavBar() {
        navigationItem.title = "Drag & Drop Demo"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddItem))
    }

    
    
    private func generateRandomColor() -> UIColor {
        let hue : CGFloat = CGFloat(arc4random() % 256) / 256 // use 256 to get full range from 0.0 to 1.0
        let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from white
        let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from black
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
    
    
    
    //MARK: - Target Selectors
    @objc fileprivate func didTapAddItem() {
        let colorItem = generateRandomColor()
        colors.insert(colorItem, at: 0)
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.insertItems(at: [indexPath])
    }
}


//MARK: - CollectionView Delegates
extension PhotoGridCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.cellReuseIdentifier, for: indexPath) as! PhotoCell
        cell.backgroundColor = colors[indexPath.item].withAlphaComponent(0.8)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dimen = view.frame.width / 3 - 1
        return CGSize(width: dimen, height: dimen)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    
}




