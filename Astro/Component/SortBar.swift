//
//  SortBar.swift
//  Astro
//
//  Created by Michael Abadi on 11/1/17.
//  Copyright © 2017 Michael Abadi Santoso. All rights reserved.
//

import Foundation
import UIKit

/**
 * @discussion class for the custom sort bar
 */
class SortBar: UIView {
    
    // variable that defines the cell of sort bar collection view
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    // all cell identifier goes here
    let cellId = "menuCellId"
    
    // all nib identifier name
    let menuCellNibName = "MenuCell"
    
    // all filter title name for the cell
    let sortTitle = ["No Sort","Sort By Name", "Sort By Number"]
    
    //
    // variable to set the homecontroller of the owner.
    // use weak to avoid retain cycle
    //
    weak var homeController: HomeCollectionViewController?
    weak var guideController: GuideCollectionViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
    }
    
    /**
     * @discussion function for setup the collection view of this class
     */
    private func setupCollectionView(){
        collectionView.register(UINib(nibName: menuCellNibName, bundle: nil), forCellWithReuseIdentifier: cellId)
        addSubview(collectionView)
        
        addConstraintsWithFormat("H:|[v0]|", views: collectionView)
        addConstraintsWithFormat("V:|[v0]|", views: collectionView)
        
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: UICollectionViewScrollPosition())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - UICollectionViewDataSource delegate
extension SortBar: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
        
        cell.backgroundColor = UIColor(rgb: 0xecf0f1)
        cell.tag = indexPath.item
        cell.titleLabel.text = sortTitle[indexPath.item]
        cell.leftBorder.isHidden = indexPath.item == 0  ? true : false
        cell.rightBorder.isHidden = indexPath.item == 2  ? true : false
        cell.bottomBorder.isHidden = indexPath.item != 0 ? true : false
        return cell
    }
}

// MARK: - UICollectionViewDelegate delegate
extension SortBar: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            if homeController != nil {
                homeController!.viewModel.noSort()
            }else if guideController != nil {
                guideController!.viewModel!.noSort()
            }
        }else if indexPath.item ==  1 {
            if homeController != nil {
                homeController!.viewModel.sortByName()
            }else if guideController != nil {
                guideController!.viewModel!.sortByName()
            }
        }else {
            if homeController != nil {
                homeController!.viewModel.sortByNumber()
            }else if guideController != nil {
                guideController!.viewModel!.sortByNumber()
            }
        }
        if homeController != nil {
            homeController!.homeCollectionView.reloadData()
        }else if guideController != nil {
            guideController!.guideCollectionView.reloadData()
        }
    }
}


// MARK: - UICollectionViewDelegateFlowLayout delegate
extension SortBar: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 3, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

/**
 * @discussion class for determine Menu bar cell
 */
class MenuCell: BaseCell {
    
    @IBOutlet weak var leftBorder: UIView!
    @IBOutlet weak var rightBorder: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bottomBorder: UIView!
    
    override var isSelected: Bool {
        didSet {
            bottomBorder.isHidden = !isSelected
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            bottomBorder.isHidden = !isHighlighted
        }
    }
    
    override func setupViews() {
        super.setupViews()
    }
}

/**
 * @discussion class for determine base cell of the project
 */
class BaseCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    /**
     * @discussion function for setup the views of cell
     */
    func setupViews() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

