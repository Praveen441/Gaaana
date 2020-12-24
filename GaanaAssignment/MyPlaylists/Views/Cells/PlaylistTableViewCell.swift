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
    
    var imageUrl: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
        imageUrl = imgUrl
        ImageDownloadManager.getImage(urlString: imgUrl) { [weak self] (url, image) in
            DispatchQueue.main.async {
                if url == imgUrl {
                    self?.playlistIcon.image = image
                } else {
                    self?.playlistIcon.image = nil
                }
            }
        }
    }
    
    override func prepareForReuse() {
        playlistIcon.image = nil
        playlistName.text = nil
        ImageDownloadManager.cancelRequestWith(url: imageUrl ?? "")
    }
    
    @IBAction func selectPlaylistBtnClicked(_ sender: UIButton) {
        print("select playlist button tapped")
    }
}
