# 🔍 Beonttuek

- 

---

## 📸 화면 미리보기

<p align="center">
  <img src="https://github.com/user-attachments/assets/95a0720d-1671-4466-acb2-6b1a9310595c"/>
</p>


---

## 🗓 프로젝트 일정

- **시작일:** 2025년 5월 20일
- **종료일:** 2025년 5월 28일

---

## 📂 폴더 구조
```
─── Beontteuk  
    ├── .gitignore  
    ├── Beontteuk.xcodeproj  
    ├── Beontteuk  
    │   ├── App                                 # 앱 전역에서 사용되는 설정 관련 디렉토리
    │   │   ├── DIContainer  
    │   │   ├── Data                            # 비즈니스 로직의 중심이 되는 계층, 외부와의 의존이 없는 순수 로직 정의
    │   │   │   ├── CoreData  
    │   │   │   └── Entity  
    │   │   │       ├── CDAlarm  
    │   │   │       ├── CDTimer  
    │   │   │       ├── LapRecord  
    │   │   │       ├── StopWatchSession  
    │   │   │       └── WorldClock  
    │   │   └── Repository  
    │   │       ├── Implementation  
    │   │       └── Interface  
    │   ├── Domain                              # 외부 데이터 소스와의 연결 및 구체적인 비즈니스 로직 구현 담당
    │   │   ├── Entity  
    │   │   └── Repository  
    │   │   │   └── Interface  
    │   │   ├── UseCase  
    │   │   │   ├── Implementation  
    │   │   │   └── Interface  
    │   ├── Presentation                         # UI와 관련된 로직을 관리하는 계층
    │   │   ├── Alarm  
    │   │   │   ├── BottomSheetView  
    │   │   │   │   ├── Call  
    │   │   │   │   ├── Model  
    │   │   │   │   ├── View  
    │   │   │   │   └── ViewModel  
    │   │   │   ├── Cell  
    │   │   │   ├── View  
    │   │   │   └── ViewModel  
    │   │   ├── StopWatch  
    │   │   │   ├── Model  
    │   │   │   ├── View  
    │   │   │   └── ViewModel  
    │   │   ├── TabBar  
    │   │   │   └── View  
    │   │   ├── Timer  
    │   │   │   ├── Model  
    │   │   │   ├── View  
    │   │   │   │   ├── Subview  
    │   │   │   └── ViewModel  
    │   │   └── WorldClock  
    │   │       ├── Cell   
    │   │       ├── View  
    │   │       └── ViewModel  
    │   ├── DIContainerInterface  
    │   └── Shared  
    │       ├── Base  
    │       ├── Extension  
    │       ├── NotificationService  
    │       └── ViewComponent  
    ├── DIContainerInterface  
    │
    ├── Resources                                  # 프로젝트의 리소스를 관리하는 디렉토리
    ├── BeontteukTests  
    ├── BeontteukUITests  
    └── Frameworks  
```

---

## 🛠 사용 기술

- **Swift 5**
- **UIKit**
- **MVVM Pattern**
- **Clean Architecture**
- **RxSwift & RxCocoa & RxDataSources**
- **SnapKit**
- **Then**
- **DI & DIP**

---

## 🌟 주요 기능

- 
  
---

## 🧩 Trouble Shooting

### 🔍 SearchController를 통한 API 다중 구독 이슈
- **문제**
   - ?
- **원인**
  - ?
- **해결**
  - ?

```swift
Trouble Shooting
```

---

## 📝 클린 아키텍처를 적용해본 내용
### ✅ 모듈화 (Modularity)
- ?
  - ?

### ✅ 의존성 주입 (Dependency Injection)
- ?
  - ?

- 사용 방식
```swift
Dependency Injection
```

- ?

### ✅ 의존성 역전 원칙
- ?
  - ?

---

## 💦 메모리 이슈 디버깅 및 경험
###  사용 경험
- ?

<p align="center">
</p>

---
