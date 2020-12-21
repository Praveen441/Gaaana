//
//  MyPlaylistsViewController.swift
//  GaanaAssignment
//
//  Created by praveen.agnihotri on 18/12/20.
//

import UIKit

class MyPlaylistsViewController: UIViewController {

    @IBOutlet weak var playlistTable: UITableView!
    
    lazy var playlistVM: PlaylistViewModel = {
        let playlistManager = PlaylistManager(networkManager: NetworkManager())
        let playlistVM = PlaylistViewModel(playlistManager: playlistManager)
        return playlistVM
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurePlaylistTable()
        fetchPlaylists()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchPlaylists()
    }
    
    private func configurePlaylistTable() {
        playlistTable.register(UINib(nibName: PlaylistTableViewCell.description(), bundle: Bundle.main),
                               forCellReuseIdentifier: PlaylistTableViewCell.description())
        playlistTable.delegate = self
        playlistTable.dataSource = self
        playlistTable.tableFooterView = UIView()
        tabBarController?.tabBar.tintColor = .red
        title = "My Playlists"
    }
    
    @IBAction func addPlaylistAction(sender: UIBarButtonItem) {
        showAddListAlert()
    }
    
    private func showAddListAlert() {
        let alertVC = UIAlertController(title: "New Playlist Name", message: "Enter a playlist name", preferredStyle: .alert)
        
        alertVC.addTextField { (textfield) in
            textfield.placeholder = "Playlist name"
        }
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] (action) in
            guard let textfield = alertVC.textFields, let name = textfield.first?.text else {return}
            if let status = self?.playlistVM.savePlaylist(playlist: PlaylistCellViewModel(name: name, tracks: [])), status {
                print("created playlists successfully")
                self?.reloadTable()
            } else {
                print("error saving playlist")
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { [weak self] (action) in
            self?.dismiss(animated: true, completion: nil)
        }
        
        alertVC.addAction(saveAction)
        alertVC.addAction(cancelAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    private func getTracksVC() -> TracksViewController? {
        guard let vc = UIStoryboard.instantiateViewController(type: TracksViewController.self) else {return nil}
        return vc
    }
    
    private func reloadTable() {
        DispatchQueue.main.async { [weak self] in
            self?.playlistTable.reloadData()
        }
    }
    
    private func fetchPlaylists() {
        playlistVM.fetchAllPlaylists()
        reloadTable()
    }
}

extension MyPlaylistsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlistVM.playlistCellVMs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlaylistTableViewCell.description(),
                                                       for: indexPath) as? PlaylistTableViewCell else {
            return UITableViewCell()
        }
        cell.selectPlaylistBtn.isHidden = true
        cell.configureCell(playlist: playlistVM.playlistCellVMs[indexPath.row])
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.PlaylistTable.playlistCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let vc = getTracksVC() {
            vc.playlist = playlistVM.playlistCellVMs[indexPath.row]
            vc.playlistVM = playlistVM
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}


