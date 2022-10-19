//
//  FolderListCollectionViewController.swift
//  MemoProject
//
//  Created by 황은지 on 2022/10/20.
//

import UIKit
import RealmSwift

class FolderListCollectionViewController: UICollectionViewController {
    // MARK: 화면 전환 쪽 버그 있음!!!!!!! 현재 안쓰는 상태

    let localRealm = try! Realm()
    var tasks: Results<Folder>!
    private var dataSource: UICollectionViewDiffableDataSource<Int, Folder>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationController?.title = "폴더 리스트"
        print("Realm is located at:", UserMemoRepository().localRealm.configuration.fileURL!)
        
        tasks = localRealm.objects(Folder.self)
        collectionView.delegate = self
        
        collectionView.collectionViewLayout = createLayout()
        configureDataSource()
    }
}

extension FolderListCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ListConfigutationCoellectionViewController()
        vc.tasks = localRealm.objects(UserMemo.self)
        present(vc, animated: true)
    }
}

extension FolderListCollectionViewController {
    private func createLayout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.showsSeparators = false
        configuration.backgroundColor = .systemIndigo
        
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Folder>(handler: { cell, indexPath, itemIdentifier in
            var content = cell.defaultContentConfiguration()
            content.text = itemIdentifier.folderTitle
            cell.contentConfiguration = content
        })
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, Folder>()
        snapshot.appendSections([0])
        snapshot.appendItems(Array(tasks))
        dataSource.apply(snapshot)
    }
    
    private func snapshotApply() {
        var snapshot = dataSource.snapshot()
        snapshot.appendItems(Array(tasks))
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
