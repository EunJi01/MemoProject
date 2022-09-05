//
//  MemoListViewController.swift
//  MemoProject
//
//  Created by 황은지 on 2022/08/31.
//

import UIKit
import RealmSwift
import Toast

final class MemoListViewController: BaseViewController {
    let mainView = MemoListView()
    let repository = UserMemoRepository()
    
    var fixMemoTasks: Results<UserMemo>!
    var memoTasks: Results<UserMemo>!
    var searchResults: [UserMemo] = []
    var searchText: String?
    
    private var isSearch: Bool { // MARK: 서치뷰로 옮기기?
        let searchController = navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }
    
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Realm is located at:", repository.localRealm.configuration.fileURL!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil) // Space 구성
        toolbarItems = [flexibleSpace, writeButton] // 배열에 Space를 먼저 넣어주면 버튼이 오른쪽으로 붙게 된다
    }
    
    @objc private func writeButtonTapped() {
        transition(WriteViewController(), transitionStyle: .push)
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        DispatchQueue.main.async {
            let memoCount = self.memoTasks.count + self.fixMemoTasks.count
            guard let count = self.numberFormatter.string(from: memoCount as NSNumber) else { return }
            self.navigationItem.title = "\(count)개의 메모"
        }
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
    
    private func fetchRealm() {
        memoTasks = repository.fetchMemo()
        fixMemoTasks = repository.fetchFixedMemo()
        mainView.tableView.reloadData()
    }
    
    private func regdateFormat(regdate: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd" // 초 단위로 비교하지 않도록 포맷
        
        let startDate = formatter.date(from: formatter.string(from: regdate)) ?? Date()
        let endDate = formatter.date(from: formatter.string(from: Date())) ?? Date()
        guard let interval = Calendar.current.dateComponents([.day], from: startDate, to: endDate).day else { return "" }

        switch interval {
        case 0:formatter.dateFormat = "a hh:mm"
        case 1...6: formatter.dateFormat = "E요일"
        default: formatter.dateFormat = "yyyy.MM.dd a hh:mm"
        }
        
        return formatter.string(from: regdate)
    }
}

extension MemoListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) { // 검색어를 입력할 때마다 호출되는 코드
        mainView.tableView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag // 스크롤로 키보드 내리기
        
        if !isSearch {
            searchResults = [] // 검색중이 아닐 때 검색결과 배열 비워주기
            print("searchResults 삭제")
        }
        
        guard let text = searchController.searchBar.text else { return }
        searchResults = repository.fetchFilter(text: text) // 검색중일 때 결과 배열에 담기
        searchText = text
        mainView.tableView.reloadData()
    }
}

extension MemoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? { // 메모 고정/해제 스와이프
        let task: UserMemo?
        
        if indexPath.section == 0 {
            if isSearch {
                task = searchResults[indexPath.row]
            } else {
                if fixMemoTasks != nil {
                    task = fixMemoTasks[indexPath.row]
                } else {
                    task = memoTasks[indexPath.row]
                }
            }
        } else {
            task = memoTasks[indexPath.row]
        }
        
        guard let task = task else { return UISwipeActionsConfiguration() }
        let image = task.isFix ? "pin.slash.fill" : "pin.fill"
        
        let fix = UIContextualAction(style: .normal, title: nil) { action, view, completionHandler in
            print("fix Button Tapped") // 스와이프 버튼 눌렀을 때 실행되는 코드
            
            if (self.fixMemoTasks.count >= 5) && (task.isFix == false) {
                self.view.makeToast("메모는 최대 5개까지 고정 가능합니다")
            } else {
                self.repository.updateFix(item: task)
                self.fetchRealm()
            }
        }
        
        fix.image = UIImage(systemName: image)
        fix.backgroundColor = ColorSet.shared.buttonColor
        
        return UISwipeActionsConfiguration(actions: [fix])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? { // 메모 삭제 스와이프

        let delete = UIContextualAction(style: .normal, title: nil) { action, view, completionHandler in
            self.showDeleteAlert { _ in
                if indexPath.section == 0 {
                    if self.isSearch {
                        self.repository.deleteItem(item: self.searchResults[indexPath.row])
                        self.searchResults.remove(at: indexPath.row)
                    } else {
                        if self.fixMemoTasks != nil {
                            self.repository.deleteItem(item: self.fixMemoTasks[indexPath.row])
                        } else {
                            self.repository.deleteItem(item: self.memoTasks[indexPath.row])
                        }
                    }
                } else {
                    self.repository.deleteItem(item: self.memoTasks[indexPath.row])
                }
                self.fetchRealm()
            }
        }
        
        delete.image = UIImage(systemName: "trash.fill")
        delete.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = WriteViewController()
        
        if indexPath.section == 0 {
            if fixMemoTasks != nil {
                vc.task = fixMemoTasks[indexPath.row]
            } else {
                vc.task = memoTasks[indexPath.row]
            }
        } else {
            vc.task = memoTasks[indexPath.row]
        }
        transition(vc, transitionStyle: .push)
    }
    
      // MARK: 버그 - 메모가 없어도 헤더가 보이는 현상
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = UIView() // 헤더 갯수만큼 필요하기 때문에 MemoListView 에서 선언 불가
            let headerLabel = UILabel()

            headerLabel.frame = CGRect(x: 10, y: 10, width: 500, height: 30)
            headerLabel.font = UIFont.boldSystemFont(ofSize: 22)

            if isSearch {
                headerLabel.text = "\(searchResults.count)개 찾음"
                headerView.addSubview(headerLabel)
                return headerView
            } else {
                if section == 0 {
                    if fixMemoTasks != nil {
                        headerLabel.text = "고정된 메모"
                    } else {
                        headerLabel.text = "메모"
                    }
                } else {
                    headerLabel.text = "메모"
                }
                headerView.addSubview(headerLabel)
                return headerView
            }
        }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoListTableViewCell.reuseIdentifier) as? MemoListTableViewCell else { return UITableViewCell() }
        
        // MARK: [UserMemo] 타입에도 사용 가능하게 하고 싶은데ㅠㅠ
//        func setupCell<T>(tasks: T) {
//            let task = (tasks as? Results<UserMemo>) ?? (tasks as? [UserMemo])
//        // 이게 왜 안되는지 모르겠어요ㅠㅠ 타입 캐스팅은 두개 동시에 선택적으로는 불가능한가요?
          // 앞 캐스팅이 실패했을 때 다음 캐스팅을 수행하는... 그런걸 기대했는데ㅜ
          // if문으로 구현하려니 어차피 코드가 중복돼서 안하느니만 못하더라구요ㅠ
//        }
        
        func setupCell(tasks: Results<UserMemo>) {
            cell.dateLabel.text = regdateFormat(regdate: tasks[indexPath.row].regdate)
            cell.titleLabel.text = tasks[indexPath.row].memoTitle
            let cuttingLine = tasks[indexPath.row].memoContent?.components(separatedBy: "\n") // 내용에 줄바꿈이 있어도
            let str = cuttingLine?.filter { $0.count > 0 } // 글자만 가져오고
            cell.contentLabel.text = str?.first ?? "추가 텍스트 없음" // 확실하게 아무 내용도 없을 때만 기본텍스트 표시
        }

        func searchTextColor(str: String?) {
            guard let searchText = searchText else { return }
            guard let str = str else { return }
            
            let attributeStr = NSMutableAttributedString(string: str)
            attributeStr.addAttribute(.foregroundColor, value: ColorSet.shared.buttonColor, range: (str.lowercased() as NSString).range(of: searchText.lowercased()))
            
            if searchResults[indexPath.row].memoTitle.contains(str) {
                cell.titleLabel.attributedText = attributeStr
            }
            
            guard let content = searchResults[indexPath.row].memoContent else { return }
            if content.contains(str) {
                cell.contentLabel.attributedText = attributeStr
            }
        }
        
        if isSearch {
            cell.dateLabel.text = regdateFormat(regdate: searchResults[indexPath.row].regdate)
            cell.titleLabel.text = searchResults[indexPath.row].memoTitle
            let cuttingLine = searchResults[indexPath.row].memoContent?.components(separatedBy: "\n")
            let str = cuttingLine?.filter { $0.count > 0 }
            cell.contentLabel.text = str?.first ?? "추가 텍스트 없음"
            searchTextColor(str: searchResults[indexPath.row].memoTitle)
            searchTextColor(str: searchResults[indexPath.row].memoContent)
        } else {
            if indexPath.section == 0 {
                if fixMemoTasks != nil {
                    setupCell(tasks: fixMemoTasks)
                } else {
                    setupCell(tasks: memoTasks)
                }
            } else {
                setupCell(tasks: memoTasks)
            }
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isSearch {
            return 1
        } else {
            if memoTasks == nil && fixMemoTasks == nil {
                return 0
            } else if memoTasks == nil || fixMemoTasks == nil {
                return 1
            } else {
                return 2
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            return searchResults.count
        } else {
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
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
