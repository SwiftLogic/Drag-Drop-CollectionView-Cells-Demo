//
//  ColoredCell.swift
//  DragDropCollectionViewDemo
//
//  Created by Osaretin Uyigue on 7/24/22.
//

import UIKit
class ColoredCell: UICollectionViewCell {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    //MARK: - Properties
    static let cellReuseIdentifier = String(describing: ColoredCell.self)
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    
    //MARK: - Methods
    fileprivate func setUpViews() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    
    func bindDataToCell(with item: ItemViewModel) {
        layer.cornerRadius = 8
        titleLabel.text = item.alphabet
        backgroundColor = item.color.withAlphaComponent(0.8)
    }
    
    
    
}
