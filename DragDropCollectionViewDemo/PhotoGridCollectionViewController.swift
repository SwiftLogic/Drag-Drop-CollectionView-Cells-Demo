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
        setUpGestureRecognizers()
    }
    
    
    //MARK: - Properties
    private var items = [ItemViewModel]()
    private var longPressedEnabled = false


    
    //MARK: - Methods
    fileprivate func setUpCollectionView() {
        collectionView.register(ColoredCell.self, forCellWithReuseIdentifier: ColoredCell.cellReuseIdentifier)
        collectionView.register(SectionTitleHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionTitleHeader.cellReuseIdentifier)
                
        for number in 0 ... 20 {
            let item = ItemViewModel(color: generateRandomColor(), number: number)
            items.append(item)
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
    
    
    private func setUpGestureRecognizers() {

        // SET UP HERE
        
        let longGestureGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture))
        collectionView.addGestureRecognizer(longGestureGesture)
        
    }
    
    
    

    
    
    //MARK: - Target Selectors
    @objc fileprivate func didTapAddItem() {
        let number = items.count 
        let item = ItemViewModel(color: generateRandomColor(), number: number)
        items.insert(item, at: 0)
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.insertItems(at: [indexPath])
    }
    
    
    @objc fileprivate func handleLongPressGesture(gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            guard let targetIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {return}
            collectionView.beginInteractiveMovementForItem(at: targetIndexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: collectionView))
        case .ended:
            collectionView.endInteractiveMovement()
         default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
}
    

//MARK: - CollectionView Delegates
extension PhotoGridCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColoredCell.cellReuseIdentifier, for: indexPath) as! ColoredCell
        cell.bindDataToCell(with: items[indexPath.item])
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dimen = view.frame.width / 3.5 //- 1
        return CGSize(width: dimen, height: dimen)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 8, bottom: 0, right: 8)
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    fileprivate func setUpHeaderTitleLabel(imageName: String, title: String) -> NSAttributedString {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: imageName)?.withTintColor(.black)
        let fullString = NSMutableAttributedString(string: "")
        fullString.append(NSAttributedString(attachment: imageAttachment))
        fullString.append(NSAttributedString(string: " \(title) "))
        return fullString
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionTitleHeader.cellReuseIdentifier, for: indexPath) as! SectionTitleHeader
        
        switch indexPath.section {
        case 0:
            let attributedText = setUpHeaderTitleLabel(imageName: "rectangle.grid.3x2.fill", title: "Section 0")
            header.titleLabel.attributedText = attributedText
            
        case 1:
            let attributedText = setUpHeaderTitleLabel(imageName: "rectangle.grid.3x2.fill", title: "Section 1")
            header.titleLabel.attributedText = attributedText
            
        default:
            break
        }
        return header
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 60)

    }
    
    
    
    
    // Responsible for collectionView Re-order
    override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        switch indexPath.section {
        case 0:
            return true
        case 1:
            return true
        default:
            return true
        }
    }
   
    
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath,
                                 to destinationIndexPath: IndexPath) {
        
        // first grab and remove item at sourceIndex
        let item = items.remove(at: sourceIndexPath.item)
        items.insert(item, at: destinationIndexPath.item)
        
    }
    
    
}




struct ItemViewModel {
    let color: UIColor
    let number: Int
}
