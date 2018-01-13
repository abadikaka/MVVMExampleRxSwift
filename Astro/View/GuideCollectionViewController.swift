//
//  GuideCollectionViewController.swift
//  Astro
//
//  Created by Michael Abadi on 11/6/17.
//  Copyright © 2017 Michael Abadi Santoso. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

/**
 * @discussion View Class for Guide class
 */
class GuideCollectionViewController: UICollectionViewController {

    @IBOutlet var guideCollectionView: UICollectionView!
    
    // variable for top filter bar
    lazy var filterBar: SortBar = {
        let mb = SortBar()
        mb.guideController = self
        return mb
    }()
    
    // all image name
    let favouriteImageName = "Favourite"
    let unfavouriteImageName = "Unfavourite"
    
    // all cell identifier
    let guideCellIdentifier = "guideCellId"
    
    // all nib identifier
    let guideCellNibName = "GuideCollectionViewCell"
    
    // collection view setting for inset and the row position
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 10.0, right: 0.0)
    let itemsPerRow: CGFloat = 1
    
    // all neccesarry properties
    var currentAiringChannelList: Variable<GuideChannelList?> = Variable(nil)
    var profileInfo: ProfileInfo?
    
    // viewModel of current view
    var viewModel : GuideChannelViewModel?
    var disposeBag = DisposeBag()
    
    // channels from home view
    var channels: [Channel] = [] {
        didSet {
            viewModel = GuideChannelViewModel(profileName: "Michael", channels: channels)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFilterBar()
        setupCell()
        populateAiringChannelList()
    }
    
    /**
     * @discussion function for setup filter bar
     */
    private func setupFilterBar(){
        view.addSubview(filterBar)
        view.addConstraintsWithFormat("H:|[v0]|", views: filterBar)
        view.addConstraintsWithFormat("V:[v0(50)]", views: filterBar)
        filterBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
    }
    
    /**
     * @discussion function for setup the guide list cell
     */
    private func setupCell(){
        guideCollectionView!.register(UINib(nibName: guideCellNibName, bundle: nil), forCellWithReuseIdentifier: guideCellIdentifier)
        guideCollectionView!.contentInset = UIEdgeInsetsMake(120, 0, 0, 0)
        guideCollectionView!.scrollIndicatorInsets = UIEdgeInsetsMake(120, 0, 0, 0)
        guideCollectionView!.backgroundColor = UIColor(rgb: 0xf1c40f)
        guideCollectionView!.contentInsetAdjustmentBehavior = .never
    }
    
    /**
     * @discussion function for populate the current airing channel from API
     */
    private func populateAiringChannelList() {
        let observableGuideChannelList = viewModel!.guideChannels.asObservable()
        observableGuideChannelList.bind(to: currentAiringChannelList).disposed(by: disposeBag)
        observableGuideChannelList.bind { [unowned self] (response) in
            self.guideCollectionView.reloadData()
            }.disposed(by: disposeBag)
    }

}

// MARK: UICollectionViewDataSource
extension GuideCollectionViewController {
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  currentAiringChannelList.value != nil ? currentAiringChannelList.value!.guideChannels.count : 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: guideCellIdentifier, for: indexPath) as! GuideCollectionViewCell
        
        guard currentAiringChannelList.value != nil else {
            cell.guideChannel = nil
            cell.guideChannelController = nil
            return cell
        }
        cell.guideChannelController = self
        cell.guideChannel = currentAiringChannelList.value?.guideChannels[indexPath.item]
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout delegate
extension GuideCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let screenRect = UIScreen.main.bounds
        let screenWidth = screenRect.size.width - paddingSpace
        let cellWidth = screenWidth / itemsPerRow
        let size = CGSize(width: cellWidth - 20, height: 144)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.top
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
}

