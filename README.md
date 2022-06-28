# MovieSearch
- 네이버 영화 API를 활용한 영화 검색 어플리케이션
### 개발 환경
- 프로그램 <img src="https://img.shields.io/badge/xcode-v13.4.1-white?logo=xcode&logoColor=skyblue"/>
- 언어 <img src="https://img.shields.io/badge/Swift-v5-white?style=round-square&logo=swift&logoColor=orange"/>
- 도구 <img src="https://img.shields.io/badge/SPM-F15148?style=round-square">
- Deployment Target <img src="https://img.shields.io/badge/iOS-13.0-white">
- 라이브러리
    - <img src="https://img.shields.io/badge/RxSwift-6.5.0-orange">
    - <img src="https://img.shields.io/badge/SnapKit-5.6.0-skyblue">
    - <img src="https://img.shields.io/badge/SDWebImage-5.9.5-green">


### 구현 화면
|검색 화면|상세 화면|
|:---:|:---:|
|<img src="https://i.imgur.com/a1XTeSi.gif" width="300">|<img src="https://i.imgur.com/8oqS3xZ.gif" width="300">|

|상세 화면 즐겨찾기 취소|즐겨찾기 목록|
|:---:|:---:|
|<img src="https://i.imgur.com/FYnbYjI.gif" width="300">|<img src="https://i.imgur.com/8oqS3xZ.gif" width="300">|



### 구현 내용
- **UICollectionViewDiffableDataSource**
    - 데이터 변화에 따른 자연스러운 변화를 위해 적용
- **CoreData**
    - 데이터를 로컬에 저장하고 불러와서 사용하기 위해 적용
    - 즐겨찾기 누른 영화를 저장하고 앱을 껐다 키더라도 즐겨찾기 목록을 로드할 수 있도록 하기 위해 적용
- **Design 타입**
    - Text, Font, Color, Image, Size를 한 곳에서 관리
    - 유지보수를 고려하여 변경사항을 간편하게 적용할 수 있도록 함
    - 하드코딩을 방지하여 휴먼에러 발생을 줄임
- **CellReusable 프로토콜**
    - 프로토콜 기본구현을 통해 Cell의 등록과 재사용 과정을 간편하게 함
    - 기존 메서드에서의 String타입의 identifier없이 Cell의 class 명으로 identifier의 역할을 할 수 있도록 구현
- **검색 로직**
    - 사용자가 입력후 검색(enter)를 누르면 API를 요청하도록 구현
    - 무분별한 API요청을 하지 않고 사용자의 편의 고려
- **MVVM+CleanArchitecture**
    - MVVM + CleanArchitecture를 적용하여 설계 및 파일 분리
    - 파일트리
    
|View|Domain|
|:---:|:---:|
|<img src="https://i.imgur.com/Xq6Vr1U.png" width="390">|<img src="https://i.imgur.com/Ktid3Rv.png" width="390">|

|Data|etc.|
|:---:|:---:|
|<img src="https://i.imgur.com/EeQCDVB.png" width="390">|<img src="https://i.imgur.com/WDrpw5N.png" width="390">|
