//
//  PostCellTableViewTableViewCell.swift
//  Scoop_iOS
//
//  Created by Iván Cayón Palacio on 29/10/16.
//  Copyright © 2016 icapa. All rights reserved.
//

import UIKit

class PostCellTableViewTableViewCell: UITableViewCell {

    static let cellId = "PostCell"
    
    let starOn = UIImage(named: "starOn.png")
    let startOff = UIImage(named: "starOff.png")
    
    
    @IBOutlet weak var rate5: UIImageView!
    @IBOutlet weak var rate4: UIImageView!
    @IBOutlet weak var rate3: UIImageView!
    @IBOutlet weak var rate2: UIImageView!
    @IBOutlet weak var rate1: UIImageView!
    @IBOutlet weak var postDate: UILabel!
    @IBOutlet weak var postAuthor: UILabel!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setRate(_ rate: Int){
        switch rate {
        case 0:
            rate1.image = startOff!
            rate2.image = startOff!
            rate3.image = startOff!
            rate4.image = startOff!
            rate5.image = startOff!
            break;
        case 1:
            rate1.image = starOn!
            rate2.image = startOff!
            rate3.image = startOff!
            rate4.image = startOff!
            rate5.image = startOff!
            break;
        case 2:
            rate1.image = starOn!
            rate2.image = starOn!
            rate3.image = startOff!
            rate4.image = startOff!
            rate5.image = startOff!
            break;
        case 3:
            rate1.image = starOn!
            rate2.image = starOn!
            rate3.image = starOn!
            rate4.image = startOff!
            rate5.image = startOff!
            break;
        case 4:
            rate1.image = starOn!
            rate1.image = starOn!
            rate1.image = starOn!
            rate1.image = starOn!
            rate1.image = startOff!
            break;
        default:
            rate1.image = starOn!
            rate1.image = starOn!
            rate1.image = starOn!
            rate1.image = starOn!
            rate1.image = starOn!
            break;
            
        
        }
    }
}
