//
//  PlaylistTableViewCell.swift
//  GaanaAssignment
//
//  Created by praveen.agnihotri on 19/12/20.
//

import UIKit

class PlaylistTableViewCell: UITableViewCell {

    @IBOutlet weak var playlistIcon: UIImageView!
    @IBOutlet weak var playlistName: UILabel!
    @IBOutlet weak var selectPlaylistBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override class func description() -> String {
        return "PlaylistTableViewCell"
    }
    
    func configureCell(playlist: PlaylistCellViewModel) {
        playlistName.text = playlist.name
        let imgageUrl = playlist.tracks.first?.imageUrl
        selectPlaylistBtn.isSelected = playlist.isSelected
        guard let imgUrl = imgageUrl else {
            playlistIcon.image = nil
            return
        }
        playlistIcon.getImage(urlString: imgUrl) { [weak self] (url, image) in
            if url == imgUrl {
                self?.playlistIcon.image = image
            }
        }
    }
    
    override func prepareForReuse() {
        playlistIcon.image = nil
        playlistName.text = nil
    }
    
    @IBAction func selectPlaylistBtnClicked(_ sender: UIButton) {
    }
}
