//
//  HomeCollectionViewCell.swift
//  GaanaAssignment
//
//  Created by praveen.agnihotri on 18/12/20.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var trackImage: UIImageView!
    @IBOutlet weak var trackName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override class func description() -> String {
        return "HomeCollectionViewCell"
    }
    
    func configureCell(trackVM: TrackCellViewModel?) {
        trackName.text = trackVM?.name
        guard let imgURL = trackVM?.imageUrl else {return}
        trackImage.getImage(urlString: imgURL) { [weak self] (url, image) in
            if url == imgURL {
                self?.trackImage.image = image
            }
        }
    }

    override func prepareForReuse() {
        trackName.text = nil
        trackImage.image = nil
    }
}
