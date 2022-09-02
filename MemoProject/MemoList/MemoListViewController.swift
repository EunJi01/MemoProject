//
//  MemoListViewController.swift
//  MemoProject
//
//  Created by 황은지 on 2022/08/31.
//

import UIKit
import RealmSwift

final class MemoListViewController: BaseViewController {
    let mainView = MemoListView()
    let repository = UserMemoRepository()
    
    var isSearch: Bool { // MARK: 서치뷰로 옮기기
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
        // MARK: if 7일 내 수정되었다면 -> calendar 사용해서 며칠 차이인지 구하고, 결과에 따라 요일 설정
        // MARK: 주의! 초 단위로 구분하지 않도록 Realm에 저장하는 Date는 00:00:00 기준일 것
        // MARK: else 아래 코드 실행
        formatter.dateFormat = "yyyy.MM.dd a hh:mm"
        return formatter
    }()
    
    //    var tasks: Results<UserMemo>! {
    //        didSet {
    //            mainView.tableView.reloadData()
    //            print("Tasks Changed")
    //        }
    //    }
    
    var fixMemoTasks: Results<UserMemo>! {
        didSet {
            mainView.tableView.reloadData()
            print("FixMemo Tasks Changed")
        }
    }
    
    var memoTasks: Results<UserMemo>! {
        didSet {
            mainView.tableView.reloadData()
            print("Memo Tasks Changed")
        }
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Realm is located at:", repository.localRealm.configuration.fileURL!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
        fetchRealm()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentPopup()
    }
    
    override func configure() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
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
    
    private func configureSearchBar() { // MARK: 아예 다른 화면에서 검색할 수 있도록 코드 개선하기
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "검색"
        searchController.hidesNavigationBarDuringPresentation = false // 검색하는 동안 네비게이션에 가려지지 않게
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText") // cancel을 취소로 변경
        //searchController.searchResultsUpdater = self // 프로토콜 채택
        
        navigationItem.hidesSearchBarWhenScrolling = false // 스크롤 할때 사라지지 않게 (+ 뷰 떴을 떄 바로바로 보이게)
        navigationItem.searchController = searchController
    }
    
    func fetchRealm() {
        memoTasks = repository.fetchMemo()
        fixMemoTasks = repository.fetchFixedMemo()
    }
}

//extension MemoListViewController: UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) { // 검색어를 입력할 때마다 호출되는 코드
//        guard let text = searchController.searchBar.text else { return }
//        searchResults = self.memoList.filter { $0.localizedCaseInsensitiveContains(text) } // 대소문자 구분X
//        mainView.tableView.reloadData()
//    }
//}

extension MemoListViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//
//        func updateFix(tasks: Results<UserMemo>) {
//            let image = tasks[indexPath.row].isFix ? "pin.slash.fill" : "pin.fill"
//            fix.image = UIImage(systemName: image)
//            fix.backgroundColor = ColorSet.shared.buttonColor
//            self.repository.updateFix(item: tasks[indexPath.row])
//        }
//
//        let fix = UIContextualAction(style: .normal, title: nil) { action, view, completionHandler in
//            print("fix Button Tapped")
//
//            if indexPath.section == 0 {
//                if self.fixMemoTasks != nil {
//                    updateFix(tasks: self.fixMemoTasks)
//                } else {
//                    updateFix(tasks: self.memoTasks)
//                }
//            } else {
//                updateFix(tasks: self.memoTasks)
//            }
//            self.fetchRealm()
//        }
//        return UISwipeActionsConfiguration(actions: [fix])
//    }
    
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let delete = UIContextualAction(style: .normal, title: "삭제") { action, view, completionHandler in
//            let task = self.tasks[indexPath.row]
//
//            self.repository.deleteItem(item: self.tasks[indexPath.row])
//            self.fetchRealm()
//        }
//        return UISwipeActionsConfiguration(actions: [delete])
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // MARK: Realm 정보 넘겨서 수정 모드 돌입
//        if indexPath.section == 0 {
//            if fixMemoTasks != nil {
//                fixMemoTasks[indexPath.row]
//            } else {
//                memoTasks[indexPath.row]
//            }
//        } else {
//            memoTasks[indexPath.row]
//        }
        transition(WriteViewController(), transitionStyle: .push)
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let sectionLabel = UILabel()
//        sectionLabel.font = .boldSystemFont(ofSize: 24)
//
//        if section == 0 {
//            if fixedMemo.count != 0 {
//                sectionLabel.text = "고정된 메모"
//            }
//        } else {
//            if normalMemo.count != 0 {
//                sectionLabel.text = "메모"
//            }
//
//        }
//        headerView.addSubview(sectionLabel)
//        return headerView
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoListTableViewCell.reuseIdentifier) as? MemoListTableViewCell else { return UITableViewCell() }
        
        func setupCell(tasks: Results<UserMemo>) {
            cell.dateLabel.text = dateFormatter.string(from: tasks[indexPath.row].regdate)
            cell.titleLabel.text = tasks[indexPath.row].memoTitle
            cell.contentLabel.text = tasks[indexPath.row].memoContent ?? "추가 텍스트 없음"
        }
        
        if indexPath.section == 0 {
            if fixMemoTasks != nil {
                setupCell(tasks: fixMemoTasks)
            } else {
                setupCell(tasks: memoTasks)
            }
        } else {
            setupCell(tasks: memoTasks)
        }

        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if memoTasks == nil && fixMemoTasks == nil {
            return 0
        } else if memoTasks == nil || fixMemoTasks == nil {
            return 1
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if memoTasks == nil && fixMemoTasks == nil {
            return 0
        } else if memoTasks == nil {
            return fixMemoTasks.count
        } else if fixMemoTasks == nil {
            return memoTasks.count
        } else {
            return section == 0 ? fixMemoTasks.count : memoTasks.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
