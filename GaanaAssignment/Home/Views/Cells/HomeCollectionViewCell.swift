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
    
    var imageUrl: String?
    
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
        imageUrl = imgURL
        ImageDownloadManager.getImage(urlString: imgURL) { [weak self] (url, image) in
            DispatchQueue.main.async {
                if url == imgURL {
                    self?.trackImage.image = image
                } else {
                    self?.trackImage.image = nil
                }
            }
        }
    }
    
    override func prepareForReuse() {
        trackName.text = nil
        trackImage.image = nil
        ImageDownloadManager.cancelRequestWith(url: imageUrl ?? "")
    }
}
