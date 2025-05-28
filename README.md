# 🔍 Beonttuek

### “하루의 시작을 번뜩이게”
- 번뜩(Beontteuk)은 사용자에게 필요한 다양한 시간 기능(알람, 타이머, 스톱워치, 세계시계)을 제공하는 올인원 시간 관리 앱입니다.
  - 알람: 시간, 레이블 기능을 제공하며 직관적인 편집 UX 구성
  - 스톱워치: 랩타임 저장 및 재시작 기능 포함, 앱 종료 후에도 상태 복구 가능
  - 타이머: 남은 시간 및 전체 시간 기반의 구조 설계, 최근 타이머 기록 저장
  - 세계시계: 도시 간 시간차, 날짜 구분(어제/오늘/내일) 및 12/24시간제 반영

---

## 📸 화면 미리보기 [영상](https://www.youtube.com/shorts/52VOri7DYiE)

<p align="center">
  <img src="https://github.com/user-attachments/assets/bc55aed7-b0f5-45f4-addd-bd1a5c5379fc"/>
</p>

---


## 🗓 프로젝트 일정

- **시작일:** 2025년 5월 20일
- **종료일:** 2025년 5월 28일

---

## 📂 폴더 구조
```
 Beontteuk  
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
 │   │   ├── Repository  
 │   │   │   └── Interface  
 │   │   ├── UseCase  
 │   │   │   ├── Implementation  
 │   │   │   └── Interface  
 │   ├── Presentation                        # UI와 관련된 로직을 관리하는 계층
 │   │   ├── DIContainerInterface  
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
 │   └── Shared  
 │       ├── Base  
 │       ├── Extension  
 │       ├── NotificationService  
 │       └── ViewComponent
 ├── Resources                                # 프로젝트의 리소스를 관리하는 디렉토리
 ├── BeontteukTests  
 ├── BeontteukUITests  
 └── Frameworks  
```

---

## 🛠 사용 기술

- **Swift 5**
- **UIKit**
- **CoreData**
- **MVVM Pattern**
- **Clean Architecture**
- **RxSwift & RxCocoa & RxDataSources**
- **SnapKit**
- **Then**
- **DI & DIP**

---

## 🌟 주요 기능
- **공통**
  - 사용자 경험을 고려한 지속적 상태 유지 기능 구현
- **알람**
  - 24시간제 / 12시간제 UI 제공
  - 시간, 분, 레이블(없은 겨우 알람 저장), 다시 알림(현재 1분 뒤) 기능 제공
  - 알람 스와이프로 삭제 및 좌측 상단 버튼으로 알람 삭제 기능 제공
  - 토글을 통한 알람 on/off 제공
  - 저장된 알람 선택 시 편집 기능 제공
  - 활성화된 알람 유무에 따른 상단 이미지, 텍스트 변경 UX 제공
- **스톱워치**
  - 스톱워치 시작, 일시정지, 랩 기록, 초기화 기능 제공
  - 랩 버튼을 탭하면 각 랩 간 경과 시간과 해당 랩까지의 누적 시간을 함께 기록
  - 앱 재실행 시 마지막 실행 시점의 누적 시간, 랩 기록을 자동으로 복원
- **타이머**
  - 시간을 선택하여 타이머 추가, 0초 설정 시 시작 비활성화
  - 최근 사용한 타이머 추가 시 중복 시간 추가 방지
  - 최근 항목으로부터 타이머 추가 기능
  - 타이머 일시정지, 재개 기능
  - 남은 시간을 시각적으로 확인할 수 있는 인디케이터 제공
  - 좌측 상단 버튼을 통한 편집 기능
  - 타이머 종료 시 포그라운드/백그라운드에서 푸시 알림 제공
  - 알림센터 및 잠금화면에서 실행중인 타이머에 대한 Live Activity 제공
- **세계시간**
  - 세계 시간 탭에서 추가된 도시의 현지 시간 확인 가능
  - 도시 추가 버튼을 통해 세계 도시 추가 가능
  - 검색창을 통해 도시 검색 가능
  - 단일 도시 삭제 기능 제공
  - 좌측 상단의 편집 버튼으로 도시 삭제 및 정렬 기능 제공
  - 앱 사용 기기의 12/24시간제 설정에 따라 실시간으로 세계 시계 탭에도 적용
  - 분 단위 시간 업데이트
---

## 🧩 Trouble Shooting

### 백래훈
- **문제**
   - ?
- **원인**
  - ?
- **해결**
  - ?

```swift
Trouble Shooting
```

### 곽다은
- **문제**
   - ?
- **원인**
  - ?
- **해결**
  - ?

```swift
Trouble Shooting
```

### 손하경
- **문제**
   - ?
- **원인**
  - ?
- **해결**
  - ?

```swift
Trouble Shooting
```

### 이세준
- **문제**
   - 알람 Notificatoin에서 길게 소리가 재생되지 않는 현상 (Notification에다가 알람 소리를 넣게 되면 6초 가량 소리만 남)
- **원인**
  - 공식 문서상 30초 내의 음원 파일을 재생이 가능하다라고 나와 있지만, 알림이 떠있는 시간 동안만 소리가 발생
  - 알람 속성은 개발단이 아닌 사용자 입장에서 설정해야하기 떄문에 사용자 의존성 필요
- **해결**
  - UNUserNotificationCenterDelegate에서 아래 코드를 사용하고 foreground에서의 이벤트 처리 때 AVPlayer로 음원 무한 루프 실행

  ```
    func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) 
  ```

  ```
      do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1 // 무한루프
            audioPlayer?.play()
        } catch {
            print("[NotificationService] AudioPlayer error: \(error)")
        }
  ```

  또한 해당 방식을 사용하면 background에서는 소리가 재생되지 않는 문제가 발생합니다.
  때문에 해당 Notification을 받을때 AVPlayer를 재생해야 하는 방식을 고려중입니다.

---

## 📝 공유하고 싶은 개발 내용
### 백래훈
#### ✅ 모듈화 (Modularity)
- ?
  - ?

- 사용 방식
```swift
Dependency Injection
```

### 곽다은
#### ✅ 의존성 주입 (Dependency Injection)
- ?
  - ?

- 사용 방식
```swift
```

### 손하경
### ✅ 의존성 역전 원칙
- ?
  - ?

- 사용 방식
```swift
Dependency Injection
```

### 이세준
### 알람 기능 (UNUserNotificationCenter)
- 앱의 알림 기능을 구현하고, 반복 재생을 구현하는 방법을 공유합니다.
- 사용 방식
```swift
/// 알람 스케줄 요청
    /// - Parameters:
    ///   - date: 알람이 발생할 정확한 날짜/시간
    ///   - snooze: 스누즈 여부 (true면 저장된 시간부터 1분 뒤에 자동 재알림)
    ///   - title: 알림 제목
    ///   - notificationId: 고유 식별자
    func scheduleAlarm(
        at date: Date,
        snooze: Bool,
        title: String,
        notificationId: String
    ) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.categoryIdentifier = NotificationService.alarmCategoryIdentifier

        let center = UNUserNotificationCenter.current()

        // 1) 원래 알람 스케줄
        let comps = Calendar.current.dateComponents([.hour, .minute,.second], from: date)
        let originalTrigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
        let originalRequest = UNNotificationRequest(
            identifier: notificationId,
            content: content,
            trigger: originalTrigger
        )
        center.removePendingNotificationRequests(withIdentifiers: [notificationId])
        center.add(originalRequest)

        // 2) 스누즈 자동 재알림 (1분 뒤)
        if snooze {
            let snoozeDate = date.addingTimeInterval(60)
            let snoozeComps = Calendar.current.dateComponents([.hour, .minute, .second], from: snoozeDate)
            let snoozeTrigger = UNCalendarNotificationTrigger(dateMatching: snoozeComps, repeats: false)
            let snoozeId = "\(notificationId)_snooze"
            content.title = "다시알림  \(title)"
            let snoozeRequest = UNNotificationRequest(
                identifier: snoozeId,
                content: content,
                trigger: snoozeTrigger
            )
            center.removePendingNotificationRequests(withIdentifiers: [snoozeId])
            center.add(snoozeRequest)
        }
    }

```
---
