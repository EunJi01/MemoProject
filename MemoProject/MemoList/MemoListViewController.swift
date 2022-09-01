//
//  MemoListViewController.swift
//  MemoProject
//
//  Created by 황은지 on 2022/08/31.
//

import UIKit

final class MemoListViewController: BaseViewController {
    let mainView = MemoListView()
    var memoList = ["메모1", "메모2", "메모3", "메모4", "메모5"] // 임시
    var searchResults: [String] = [] // 임시
    var isSearch: Bool {
        let searchController = navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy.MM.dd a hh:mm"
        return formatter
    }()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentPopup()
    }
    
    override func configure() {
        configureNavigationBar()
        configureToolbar()
        configureSearchBar()
    }
    
    private func configureToolbar() {
        navigationController?.isToolbarHidden = false // 툴바 꺼내주기
        let writeButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(writeButtonTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbarItems = [flexibleSpace, writeButton]
    }
    
    @objc private func writeButtonTapped() {
        transition(WriteViewController(), transitionStyle: .push)
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        guard let number = numberFormatter.string(from: 1234) else { return }
        navigationItem.title = "\(number)개의 메모"
    }
    
    private func presentPopup() {
        if UserDefaults.standard.bool(forKey: "popupOff") == false {
            transition(FirstPopupViewController(), transitionStyle: .presentOverFull)
        }
    }
    
    private func configureSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "검색"
        searchController.hidesNavigationBarDuringPresentation = false // 검색하는 동안 네비게이션에 가려지지 않게
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText") // cancel을 취소로 변경
        searchController.searchResultsUpdater = self // 프로토콜 채택
        
        navigationItem.hidesSearchBarWhenScrolling = false // 스크롤 할때 사라지지 않게 (+ 뷰 떴을 떄 바로바로 보이게)
        navigationItem.searchController = searchController
    }
}

extension MemoListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) { // 검색어를 입력할 때마다 호출되는 코드
        guard let text = searchController.searchBar.text else { return }
        searchResults = self.memoList.filter { $0.localizedCaseInsensitiveContains(text) } // 대소문자 구분X
        mainView.tableView.reloadData()
    }
}

extension MemoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Realm 정보 넘겨서 수정 모드 돌입
        transition(WriteViewController(), transitionStyle: .push)
    }
    
    //    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //        let sectionLabel = UILabel()
    //        sectionLabel.font = .boldSystemFont(ofSize: 24)
    //        if section == 0 {
    //            if starredMemoList.count != 0 {
    //                sectionLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
    //            }
    //        } else {
    //            if memoList.count != 0 {
    //                sectionLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
    //            }
    //
    //        }
    //        headerView.addSubview(sectionLabel)
    //        return headerView
    //    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoListTableViewCell.reuseIdentifier) as? MemoListTableViewCell else { return UITableViewCell() }
        
        cell.dateLabel.text = dateFormatter.string(from: Date())
        cell.titleLabel.text = memoList[indexPath.row]
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return isSearch ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearch ? searchResults.count : memoList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
