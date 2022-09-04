# MemoProject
### 버그
**NavigationController - 메모를 생성하거나, 수정하고 pop하면 네비게이션 타이틀이 안보이는 현상 (검색모드 고정)**  

MemoListViewController 에서 TableView에 메모가 없어도 HeaderView 가 보이는 현상   
MemoListViewController 에서 검색했을 때, 대소문자가 다르면 키워드 색이 바뀌지 

WriteViewController 에서 메모를 저장했을 때, 마지막 글자가 (ex. 자음 하나) 가 누락되는 현상  
WriteViewController 에서 메모를 저장했을 때, 줄바꿈이 불필요하게 추가되는 현상   
WriteViewController 에서 메모를 수정했을 때, 수정사항이 없어도 regDate가 갱신되는 현상 (\n이 추가되었기 때문) 

-------------
### 개발 공수
| 회차 | 내용 | 세부내용 | 예상시간 | 실제시간 | 날짜 |
| --- | --- | --- | --- | --- | --- |
| **Iteration 1** | 기본 구성 |  |  |  | **~2022.08.31** |
|  | ColorSet | 다크모드 대응 ColorSet 구성 | ~~1h~~ | 2h |  |
|  | MomoListView | Code Base 레이아웃 | 1h | 1h |  |
|  | FirstPopupView | Code Base 레이아웃 | 1h | 1h |  |
|  | FirstPopupView | 최초 실행 구현 | 1h | 1h |  |
|  |  |  |  |  |  |
| **Iteration 2** | 기본 구성 |  |  |  | **~2022.09.01** |
|  | MomoListView | tableViewCell 레이아웃 | 1h | 1h |  |
|  | MomoListView | tableView 기본 구현 | 2h | 2h |  |
|  | MomoListView | 메모 검색 기능 | ~~2h~~ | 4h 중복, 인덱스 이슈 |  |
|  | WriteView | Code Base 레이아웃 | ~~1h~~ | 30m |  |
|  |  |  |  |  |  |
| **Iteration 3** | Realm |  |  |  | **~2022.09.02** |
|  | Realm | Realm 스키마 구성 | 1h | 1h |  |
|  | Realm | Realm 저장 구현 | 2h | 2h |  |
|  | Realm | Realm 수정 구현 | ~~1h~~ | 5h 인덱스 이슈 |  |
|  | Realm | Realm 로드(정렬) 구현 | 1h | 1h |  |
|  | Realm | Realm 삭제 구현 | ~~2h~~ | 3h |  |
|  |  |  |  |  |  |
| **Iteration 4** | MomoListView 디테일 기능 |  |  |  | **~2022.09.03** |
|  | MomoListView | 스와이프 삭제 구현 | 1h | 1h |  |
|  | MomoListView | tableView 헤더 구현 | ~~2h~~ | 2h *버그있음* |  |
|  | MomoListView | 메모 고정 기능 | ~~2h~~ | 3h 클로저 캡쳐 이슈 |  |
|  | MomoListView | 검색결과 텍스트컬러 변경 | ~~2h~~ | 3h 대소문자 대응 X |  |
|  |  |  |  |  |  |
| **Iteration 5** | WriteView 디테일 기능 |  |  |  | **~2022.09.04** |
|  | WriteView | 공유 버튼 구현 | ~~1h~~ | 30m |  |
|  | WriteView | 키보드 띄우기 | ~~1h~~ | 30m |  |
|  | WriteView | 날짜 포멧 | 2h | 2h |  |
|  | WriteView | 리턴키로 제목 구분 | ~~3h~~ | 4h *버그있음* |  |
|  |  |  |  |  |  |
| **Iteration 6** | 버그/구현 못한 기능 |  |  |  | **~2022.09.05** |
|  |  |  |  |  |  |
