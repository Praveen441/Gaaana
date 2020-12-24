//
//  SeeAllDetailTableViewCell.swift
//  GaanaAssignment
//
//  Created by praveen.agnihotri on 19/12/20.
//

import UIKit

protocol TrackTableViewCellProtocol: class {
    func addToPlaylist(cell: TrackTableViewCell)
}

class TrackTableViewCell: UITableViewCell {
    
    @IBOutlet weak var trackIcon: UIImageView!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var addToPlaylist: UIButton!
    
    weak var delegate: TrackTableViewCellProtocol?
    var imageUrl: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override class func description() -> String {
        return "TrackTableViewCell"
    }
    
    func configureCell(trackVM: TrackCellViewModel) {
        trackName.text = trackVM.name
        guard let imgUrl = trackVM.imageUrl else {return}
        imageUrl = imgUrl
        ImageDownloadManager.getImage(urlString: imgUrl) { [weak self] (url, image) in
            DispatchQueue.main.async {
                if url == imgUrl {
                    self?.trackIcon.image = image
                } else {
                    self?.trackIcon.image = nil
                }
            }
        }
    }
    
    override func prepareForReuse() {
        trackIcon.image = nil
        trackName.text = nil
        ImageDownloadManager.cancelRequestWith(url: imageUrl ?? "")
    }
    
    @IBAction func addToPlaylistAction(_ sender: UIButton) {
        delegate?.addToPlaylist(cell: self)
    }
}
