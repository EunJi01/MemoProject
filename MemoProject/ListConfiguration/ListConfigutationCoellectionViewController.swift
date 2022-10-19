//
//  ListConfigutationCoellectionViewController.swift
//  MemoProject
//
//  Created by 황은지 on 2022/10/18.
//

import UIKit
import RealmSwift

final class ListConfigutationCoellectionViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let localRealm = try! Realm()
    let repository = UserMemoRepository()
    var tasks: Results<UserMemo>!
    private var dataSource: UICollectionViewDiffableDataSource<Int, UserMemo>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tasks = localRealm.objects(UserMemo.self)
        collectionView.delegate = self
        searchBar.delegate = self

        collectionView.collectionViewLayout = createLayout()
        configureDataSource()
        
        print("Realm is located at:", repository.localRealm.configuration.fileURL!)
    }
}

extension ListConfigutationCoellectionViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        
        try! localRealm.write {
            let newTask = UserMemo(memoTitle: text, memoContent: nil)
            repository.localRealm.add(newTask)
            snapshotApply()
        }
    }
}

extension ListConfigutationCoellectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("선택")
    }
}

extension ListConfigutationCoellectionViewController {
    private func createLayout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.showsSeparators = false
        configuration.backgroundColor = .systemIndigo
        configuration.trailingSwipeActionsConfigurationProvider = { indexPath in
            let del = UIContextualAction(style: .destructive, title: "Delete") {
                [weak self] action, view, completion in
                self?.repository.deleteItem(item: (self?.tasks[indexPath.row])!)
                // MARK: 인덱스 에러 발생
                self?.snapshotApply()
                completion(true)
            }
            return UISwipeActionsConfiguration(actions: [del])
        }
        
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, UserMemo>(handler: { cell, indexPath, itemIdentifier in
            var content = cell.defaultContentConfiguration()
            
            content.text = itemIdentifier.memoTitle
            content.secondaryText = "\(itemIdentifier.regdate)"
            
            cell.contentConfiguration = content
        })
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, UserMemo>()
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
