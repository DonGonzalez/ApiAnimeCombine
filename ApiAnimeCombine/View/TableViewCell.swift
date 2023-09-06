//
//  TableViewCell.swift
//  ApiAnimeCombine
//
//  Created by Robert B on 28/05/2023.
//

import Foundation
import UIKit

class TableViewCell: UITableViewCell {

   
    @IBOutlet weak var AnimeImageView: UIImageView!
    @IBOutlet weak var AnimeSeason: UILabel!
    @IBOutlet weak var AnimeTitle: UILabel!
    
    var identif: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //imageURL: String?
    func config(title: String, season: Int, imageURL: String?){
        AnimeTitle.text = title
        AnimeSeason.text = String(season)
        AnimeImageView.loadImage(url: imageURL)
    }
}

