//
//  ViewController.swift
//  GaanaAssignment
//
//  Created by praveen.agnihotri on 18/12/20.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var homeList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHomeList()
        fetchTracks()
    }
    
    lazy var homeVM: HomeViewModel = {
        let homeManager = HomeManager(networkManager: NetworkManager())
        let viewModel = HomeViewModel(homeManager: homeManager)
        return viewModel
    }()
    
    private func fetchTracks() {
        homeVM.fetchResponse { [weak self] status,error  in
            DispatchQueue.main.async {
                self?.homeList.reloadData()
            }
        }
    }
    
    private func configureHomeList() {
        homeList.register(UINib(nibName: HomeTableViewCell.description(), bundle: Bundle.main),
                          forCellReuseIdentifier: HomeTableViewCell.description())
        
        homeList.register(UINib(nibName: HomeSectionHeaderView.description(), bundle: Bundle.main), forHeaderFooterViewReuseIdentifier: HomeSectionHeaderView.description())
        
        homeList.delegate = self
        homeList.dataSource = self
        homeList.tableFooterView = UIView()
        homeList.showsVerticalScrollIndicator = false
        tabBarController?.tabBar.tintColor = .red
        title = "Home"
    }
    
    private func getAllDetailVC() -> SeeAllDetailViewController? {
        guard let vc = UIStoryboard.instantiateViewController(type: SeeAllDetailViewController.self) else {return nil}
        return vc
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return homeVM.sectionCellVMs.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.description(),
                                                       for: indexPath) as? HomeTableViewCell else {
            return UITableViewCell()
        }
        cell.sectionCellVM = homeVM.sectionCellVMs[indexPath.section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.HomeList.homeListCellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HomeSectionHeaderView.description())
                as? HomeSectionHeaderView else {return nil}
        header.delegate = self
        header.configureView(sectionCellVM: homeVM.sectionCellVMs[section], section: section)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constants.HomeList.homeListSectionHeaderHeight
    }
}

extension HomeViewController: HomeSectionHeaderViewProtocol {
    func seeAllActionClicked(sectionIndex: Int?) {
        if let vc = getAllDetailVC() {
            vc.homeVM = homeVM
            vc.selectedHomeSection = sectionIndex
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
