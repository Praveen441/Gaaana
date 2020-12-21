//
//  TracksViewController.swift
//  GaanaAssignment
//
//  Created by praveen.agnihotri on 19/12/20.
//

import UIKit

class TracksViewController: UIViewController {

    @IBOutlet weak var tracksTable: UITableView!
    
    var playlist: PlaylistCellViewModel?
    var playlistVM: PlaylistViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        setUp()
        title = playlist?.name
    }
    
    private func configureNavigationBar() {
        let deleteButton = UIBarButtonItem(image: UIImage(named: "brand"), style: .plain,
                                           target: self, action: #selector(deletePlaylist))
        
        navigationItem.rightBarButtonItem = deleteButton
    }
    
    private func setUp() {
        tracksTable.register(UINib(nibName: TrackTableViewCell.description(), bundle: Bundle.main),
                            forCellReuseIdentifier: TrackTableViewCell.description())
        tracksTable.delegate = self
        tracksTable.dataSource = self
        tracksTable.tableFooterView = UIView()
    }
    
    @objc private func deletePlaylist() {
        showDeletePlaylistAlert()
    }
    
    private func showDeletePlaylistAlert() {
        let alertVC = UIAlertController(title: "Playlist Name \n",
                                        message: "Do you want to delete this playlist ? \n \n", preferredStyle: .alert)
        
        let OkAction = UIAlertAction(title: "OK", style: .default) { [weak self] (action) in
            if let playlist = self?.playlist {
                self?.playlistVM?.delete(playlist: playlist)
            }
            self?.navigationController?.popViewController(animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            alertVC.dismiss(animated: true, completion: nil)
        }
        
        alertVC.addAction(OkAction)
        alertVC.addAction(cancelAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    private func getAddToPlaylistVC() -> AddToPlaylistViewController? {
        guard let vc = UIStoryboard.instantiateViewController(type: AddToPlaylistViewController.self) else {return nil}
        return vc
    }
}

extension TracksViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlist?.tracks.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrackTableViewCell.description(),
                                                       for: indexPath) as? TrackTableViewCell else {
            return UITableViewCell()
        }
        if let tracks = playlist?.tracks {
            cell.configureCell(trackVM: tracks[indexPath.row])
        }
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.AllDetails.trackCellHeight
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            guard var playlist = playlist else {return}
            playlistVM?.delete(track: playlist.tracks[indexPath.row], from: playlist)
            playlist.tracks.remove(at: indexPath.row)
            self.playlist = playlist
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension TracksViewController: TrackTableViewCellProtocol {
    func addToPlaylist(cell: TrackTableViewCell) {
        if let vc = getAddToPlaylistVC() {
            vc.playlistVM = playlistVM
        
            if let playlist = playlist, let selectedCellIndex = tracksTable.indexPath(for: cell) {
                vc.track = playlist.tracks[selectedCellIndex.row]
            }
        
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            present(navVC, animated: true, completion: nil)
        }
    }
}
