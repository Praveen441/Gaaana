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
        trackIcon.getImage(urlString: imgUrl) { [weak self] (url, image) in
            if url == imgUrl {
                self?.trackIcon.image = image
            }
        }
    }
    
    override func prepareForReuse() {
        trackIcon.image = nil
        trackName.text = nil
    }
    
    @IBAction func addToPlaylistAction(_ sender: UIButton) {
        delegate?.addToPlaylist(cell: self)
    }
}
