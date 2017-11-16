//
//  GuideCollectionViewCell.swift
//  Astro
//
//  Created by Michael Abadi on 11/6/17.
//  Copyright © 2017 Michael Abadi Santoso. All rights reserved.
//

import UIKit

/**
 * @discussion View Class for Guide Cell
 */
class GuideCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var channelNumber: UILabel!
    @IBOutlet weak var channelTitle: UILabel!
    @IBOutlet weak var channelDate: UILabel!
    @IBOutlet weak var channelProgram: UILabel!
    @IBOutlet weak var liveOn: UILabel!
    
    // reference to the collection controller
    weak var guideChannelController: GuideCollectionViewController?
    
    // guidechannel of current index cell
    var guideChannel: GuideChannel? {
        didSet{
            if let _channel = guideChannel {
                channelTitle.text = _channel.channelTitle
                channelNumber.text = String(describing: _channel.channelStbNumber)
                channelDate.text = _channel.displayDateTime
                channelProgram.text = _channel.programmeTitle
                let onIn = guideChannelController!.viewModel!.getRangeTime(currentProgramDate: _channel.displayDateTime)
                liveOn.text = "Live "+onIn
            }else{
                channelTitle.text = ""
                channelNumber.text = ""
                channelDate.text = ""
                channelProgram.text = ""
                liveOn.text = "Loading"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    

}
