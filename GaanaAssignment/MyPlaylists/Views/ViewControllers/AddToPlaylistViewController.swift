//
//  AddToPlaylistViewController.swift
//  GaanaAssignment
//
//  Created by praveen.agnihotri on 19/12/20.
//

import UIKit

class AddToPlaylistViewController: UIViewController {

    @IBOutlet weak var addToPlaylistTable: UITableView!
    @IBOutlet weak var createListStack: UIStackView!
    @IBOutlet weak var createListbtn: UIButton!
    @IBOutlet weak var chooseExistingLbl: UILabel!
    @IBOutlet weak var createNewListView: UIView!
    @IBOutlet weak var chooseExistingListView: UIView!
    
    var playlistVM: PlaylistViewModel?
    
    var track: TrackCellViewModel?
    var playlistsSelectedToAddTrack = [PlaylistCellViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchPlaylists()
    }
    
    private func fetchPlaylists() {
        playlistVM?.fetchAllPlaylists()
        DispatchQueue.main.async { [weak self] in
            self?.reloadTable()
        }
    }
    
    private func reloadTable() {
        addToPlaylistTable.reloadData()
    }
    
    private func configureNavigationBar() {
        let closeButton = UIBarButtonItem(image: UIImage(named: "close"), style: .plain,
                                          target: self, action: #selector(closeButtonAction))
        
        navigationItem.leftBarButtonItem = closeButton
    }
    
    @objc private func closeButtonAction() {
        dismiss(animated: true, completion: nil)
    }
   
    private func setUp() {
        addToPlaylistTable.register(UINib(nibName: PlaylistTableViewCell.description(), bundle: Bundle.main),
                            forCellReuseIdentifier: PlaylistTableViewCell.description())
        addToPlaylistTable.delegate = self
        addToPlaylistTable.dataSource = self
        addToPlaylistTable.tableFooterView = UIView()
        
        createListbtn.layer.cornerRadius = 20
        createListbtn.layer.borderWidth = 1.0
        createListbtn.layer.borderColor = UIColor.systemRed.cgColor
        
        title = "Add To Playlist"
        
        if playlistVM == nil {
            let playlistManager = PlaylistManager(networkManager: NetworkManager())
            playlistVM = PlaylistViewModel(playlistManager: playlistManager)
        }
    }

    private func showAddListAlert() {
        let alertVC = UIAlertController(title: "New Playlist Name", message: "Enter a playlist name", preferredStyle: .alert)
        
        alertVC.addTextField { (textfield) in
            textfield.placeholder = "Playlist name"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] (action) in
            guard let textfield = alertVC.textFields, let name = textfield.first?.text else {return}
            if let status = self?.playlistVM?.savePlaylist(playlist: PlaylistCellViewModel(name: name, tracks: [])), status {
                print("playlist saved successfully")
                self?.reloadTable()
            } else {
                print("error saving playlist")
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            alertVC.dismiss(animated: true, completion: nil)
        }
        
        alertVC.addAction(saveAction)
        alertVC.addAction(cancelAction)
        present(alertVC, animated: true, completion: nil)
    }

    @IBAction func createNewPlaylistClicked(_ sender: UIButton) {
        showAddListAlert()
    }
    
    @IBAction func doneButtonAction(_ sender: UIButton) {
        guard let track = track else {return}
        playlistVM?.add(track: track, playlist: playlistsSelectedToAddTrack)
        fetchPlaylists()
        self.dismiss(animated: true, completion: nil)
    }
}

extension AddToPlaylistViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlistVM?.playlistCellVMs.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlaylistTableViewCell.description(),
                                                       for: indexPath) as? PlaylistTableViewCell else {
            return UITableViewCell()
        }
        if let playlist = playlistVM?.playlistCellVMs[indexPath.row] {
            cell.configureCell(playlist: playlist)
        }
        cell.selectPlaylistBtn.isHidden = false
        cell.accessoryType = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.PlaylistTable.playlistCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        playlistVM?.playlistCellVMs[indexPath.row].isSelected.toggle()
        let currentState = playlistVM?.playlistCellVMs[indexPath.row].isSelected
        if let playlistVM = playlistVM, let state = currentState, state {
            playlistsSelectedToAddTrack.append(playlistVM.playlistCellVMs[indexPath.row])
        } else {
            playlistsSelectedToAddTrack.removeAll { [weak self] (playlist) -> Bool in
                return playlist.name == self?.playlistVM?.playlistCellVMs[indexPath.row].name
            }
        }
        addToPlaylistTable.beginUpdates()
        addToPlaylistTable.reloadRows(at: [indexPath], with: .automatic)
        addToPlaylistTable.endUpdates()
    }
}

