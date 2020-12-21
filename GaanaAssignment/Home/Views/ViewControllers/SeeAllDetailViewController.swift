//
//  SeeAllDetailViewController.swift
//  GaanaAssignment
//
//  Created by praveen.agnihotri on 19/12/20.
//

import UIKit

class SeeAllDetailViewController: UIViewController {

    @IBOutlet weak var tracksList: UITableView!
    
    var homeVM: HomeViewModel?
    var selectedHomeSection: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureAllDetailList()
    }
    
    private func configureAllDetailList() {
        tracksList.register(UINib(nibName: TrackTableViewCell.description(), bundle: Bundle.main),
                            forCellReuseIdentifier: TrackTableViewCell.description())
        
        tracksList.delegate = self
        tracksList.dataSource = self
        tracksList.tableFooterView = UIView()
        tabBarController?.tabBar.tintColor = .red
        guard let homeVM = homeVM, let section = selectedHomeSection else {return}
        title = homeVM.homeCellVMs[section].name
    }
    
    private func getAddToPlaylistVC() -> AddToPlaylistViewController? {
        guard let vc = UIStoryboard.instantiateViewController(type: AddToPlaylistViewController.self) else {return nil}
        return vc
    }
}

extension SeeAllDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let homeVM = homeVM, let selectedSection = selectedHomeSection else {
            return 0
        }
        return homeVM.homeCellVMs[selectedSection].tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrackTableViewCell.description(),
                                                       for: indexPath) as? TrackTableViewCell else {
            return UITableViewCell()
        }
        if let section = selectedHomeSection, let alltracks = homeVM?.getTracksForSection(index: section) {
            cell.configureCell(trackVM: alltracks[indexPath.row])
        }
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.AllDetails.trackCellHeight
    }
}

extension SeeAllDetailViewController: TrackTableViewCellProtocol {
    func addToPlaylist(cell: TrackTableViewCell) {
        if let vc = getAddToPlaylistVC() {
        
            if let homeVM = homeVM, let selectedHomeSection = selectedHomeSection,
               let selectedCellIndex = tracksList.indexPath(for: cell) {
                let sectionTracks = homeVM.homeCellVMs[selectedHomeSection].tracks
                vc.track = sectionTracks[selectedCellIndex.row]
            }
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            present(navVC, animated: true, completion: nil)
        }
    }
}
