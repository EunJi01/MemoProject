//
//  ListConfigutationCoellectionViewController.swift
//  MemoProject
//
//  Created by 황은지 on 2022/10/18.
//

import UIKit
import RealmSwift

final class ListConfigutationCoellectionViewController: UICollectionViewController {
    
    let localRealm = try! Realm()
    var tasks: Results<UserMemo>!
    var cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, UserMemo>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tasks = localRealm.objects(UserMemo.self)

        configration()
        setCellRegistration()
    }
    
    private func configration() {
        var configration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configration.showsSeparators = false
        configration.backgroundColor = .systemIndigo
        
        let layout = UICollectionViewCompositionalLayout.list(using: configration)
        collectionView.collectionViewLayout = layout
    }
    
    private func setCellRegistration() {
        cellRegistration = UICollectionView.CellRegistration(handler: { cell, indexPath, itemIdentifier in
            var content = cell.defaultContentConfiguration()
            
            content.text = itemIdentifier.memoTitle
            content.secondaryText = "\(itemIdentifier.regdate)"
            
            cell.contentConfiguration = content
        })
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = tasks[indexPath.item]
        let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        
        var backgroundConfig = UIBackgroundConfiguration.listGroupedCell()
        backgroundConfig.backgroundColor = .yellow
        cell.backgroundConfiguration = backgroundConfig

        return cell
    }
}
