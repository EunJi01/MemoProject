//
//  ListConfigutationCoellectionViewController.swift
//  MemoProject
//
//  Created by 황은지 on 2022/10/18.
//

import UIKit
import RealmSwift

final class ListConfigutationCoellectionViewController: UIViewController {
    
    lazy var collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: createLayout())
    let searchBar = UISearchBar()
    
    let localRealm = try! Realm()
    let repository = UserMemoRepository()
    var tasks: List<UserMemo>!
    private var dataSource: UICollectionViewDiffableDataSource<Int, UserMemo>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setConfigure()
        configureDataSource()
        
        print("Realm is located at:", repository.localRealm.configuration.fileURL!)
    }
    
    func setConfigure() {
        view.backgroundColor = .white
        searchBar.delegate = self
        
        view.addSubview(collectionView)
        view.addSubview(searchBar)
        
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.bottom.horizontalEdges.equalToSuperview()
        }
    }
}

extension ListConfigutationCoellectionViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        guard let task = localRealm.objects(Folder.self).filter("folderTitle = '2번 폴더'").first else { return }
        let memo = UserMemo(memoTitle: text, memoContent: nil)
        
        try! localRealm.write {
            task.memo.append(memo)
            snapshotApply()
        }
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
                
                try! self?.localRealm.write {
                    self?.tasks.remove(at: indexPath.row)
                }
                
                // MARK: 갱신이 제대로 안되는 버그 있음ㅜ
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
