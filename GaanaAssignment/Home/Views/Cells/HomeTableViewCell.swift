//
//  HomeTableViewCell.swift
//  GaanaAssignment
//
//  Created by praveen.agnihotri on 18/12/20.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var homeCollectionList: UICollectionView!
    
    var sectionCellVM: SectionCellViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureCollectionView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override class func description() -> String {
        return "HomeTableViewCell"
    }
    
    private func configureCollectionView() {
        homeCollectionList.register(UINib(nibName: HomeCollectionViewCell.description(), bundle: Bundle.main), forCellWithReuseIdentifier: HomeCollectionViewCell.description())
        
        homeCollectionList.delegate = self
        homeCollectionList.dataSource = self
        homeCollectionList.isDirectionalLockEnabled = true
        homeCollectionList.showsHorizontalScrollIndicator = false
        
        let layout = homeCollectionList.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.scrollDirection = .horizontal
        layout?.sectionInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        layout?.minimumInteritemSpacing = 15
        let height: CGFloat = 205
        let width: CGFloat = 155
        layout?.itemSize = .init(width: width, height: height)
    }
}

extension HomeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sectionCellVM?.tracks.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.description(), for: indexPath) as? HomeCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configureCell(trackVM: sectionCellVM?.tracks[indexPath.row])
        return cell
    }
}
