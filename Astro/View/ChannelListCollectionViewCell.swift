//
//  ChannelListCollectionViewCell.swift
//  Astro
//
//  Created by Michael Abadi on 11/1/17.
//  Copyright © 2017 Michael Abadi Santoso. All rights reserved.
//

import UIKit

/**
 * @discussion View Class for Collection of channel list cell
 */
class ChannelListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var layerView: UIView!
    @IBOutlet weak var channelNumber: UILabel!
    @IBOutlet weak var channelName: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    
    weak var homeController: HomeCollectionViewController!
    
    var cellIndexPath: Int!
    var channel: Channel? {
        didSet{
            if let _channel = channel {
                channelName.text = _channel.channelTitle
                channelNumber.text = String(describing: _channel.channelStbNumber)
            }else{
                channelName.text = "Loading"
                channelNumber.text = ""
            }
        }
    }
    
    // all image name
    let favouriteImageName = "Favourite"
    let unfavouriteImageName = "Unfavourite"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    /**
     * @discussion function for initial setup view
     */
    private func setupView(){
        layer.backgroundColor = UIColor.clear.cgColor
        layerView.layer.cornerRadius = 10
        layerView.layer.masksToBounds = true
    }

    /**
     * @discussion function for handle the fav button
     */
    @IBAction func handleFavourite(_ sender: Any) {
        guard let channel = channel else {
            return
        }
        
        if channel.markedAsFavorite {
            homeController.viewModel.deleteCurentIndexToFavourite(indexPath: cellIndexPath)
            homeController.homeCollectionView.reloadData()
        }else{
            homeController.viewModel.addCurentIndexToFavourite(indexPath: cellIndexPath)
            homeController.homeCollectionView.reloadData()
        }
    }
}
