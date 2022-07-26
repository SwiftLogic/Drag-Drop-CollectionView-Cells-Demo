//
//  PhotoGridCollectionViewController.swift
//  DragDropCollectionViewDemo
//
//  Created by Osaretin Uyigue on 7/24/22.
//

import UIKit

enum ItemSections: Int {
    case alphabets, emojis
}




class PhotoGridCollectionViewController: UICollectionViewController {

    
    //MARK: - View's LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        collectionView.backgroundColor = .white
        configureNavBar()
        setUpCollectionView()
        setUpDummyData()
        setUpGestureRecognizers()
        
    }
    
    
    //MARK: - Properties
    private var alphabetItems = [ItemViewModel]()
    private var emojiItems = [ItemViewModel]()
    private let allAlphabet: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    fileprivate let itemSections: [ItemSections] = [.alphabets, .emojis]
    



    
    //MARK: - Methods
    fileprivate func setUpCollectionView() {
        collectionView.register(ColoredCell.self, forCellWithReuseIdentifier: ColoredCell.cellReuseIdentifier)
        collectionView.register(SectionTitleHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionTitleHeader.cellReuseIdentifier)
                
    }

    
    fileprivate func configureNavBar() {
        navigationItem.title = "Drag & Drop Demo"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    private func setUpDummyData() {
        // setup alphabet
        for alphabet in allAlphabet {
            let item = ItemViewModel(color: generateRandomColor(), alphabet: String(alphabet))
            alphabetItems.append(item)
        }
        
        // setup emojis. This is mem address of emojis
        for i in 0x1F601...0x1F64F {
            guard let scalar = UnicodeScalar(i) else { continue }
            let emoji = String(scalar)
            let item = ItemViewModel(color: generateRandomColor(), alphabet: emoji)
            emojiItems.append(item)
        }
            
    }

    
    
    private func generateRandomColor() -> UIColor {
        let hue : CGFloat = CGFloat(arc4random() % 256) / 256 // use 256 to get full range from 0.0 to 1.0
        let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from white
        let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from black
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
    
    
    private func setUpGestureRecognizers() {
        let longGestureGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture))
        collectionView.addGestureRecognizer(longGestureGesture)
    }
    
    
    
    
    //MARK: - Target Selectors
      
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
        switch itemSections[indexPath.section] {
        case .alphabets:
            cell.bindDataToCell(with: alphabetItems[indexPath.item])

        case .emojis:
            cell.bindDataToCell(with: emojiItems[indexPath.item])

        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dimen = indexPath.section == 0 ? view.frame.width / 4.5 : view.frame.width / 6.5
        return CGSize(width: dimen, height: dimen)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 8, bottom: 8, right: 8)
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return itemSections.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch itemSections[section] {
        case .alphabets:
            return  alphabetItems.count
        case .emojis:
            return emojiItems.count
        }
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
        
        switch itemSections[indexPath.section] {
        case .alphabets:
            let attributedText = setUpHeaderTitleLabel(imageName: "rectangle.grid.3x2.fill", title: "Alphabets")
            header.titleLabel.attributedText = attributedText
            
        case .emojis:
            let attributedText = setUpHeaderTitleLabel(imageName: "rectangle.grid.3x2.fill", title: "Emojis")
            header.titleLabel.attributedText = attributedText
            
        }
        return header
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 60)

    }
    
    
    
    
    // Responsible for collectionView Re-order
    override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
   
    
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath,
                                 to destinationIndexPath: IndexPath) {
     
        
        // determines which item to remove from data model
        let item = sourceIndexPath.section == 0 ? alphabetItems.remove(at: sourceIndexPath.item)
        : emojiItems.remove(at: sourceIndexPath.item)

        // determines which section to move the item to
        if destinationIndexPath.section == 0 {
            alphabetItems.insert(item, at: destinationIndexPath.item)
        } else {
            emojiItems.insert(item, at: destinationIndexPath.item)

        }
    }
    
    
}




struct ItemViewModel {
    let color: UIColor
    let alphabet: String
}
