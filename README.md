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
- **SwiftUI**
- **ActivityKit**

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
  - 앱이 foreground로 진입하거나 viewWillAppear 시점에서 12/24시간제 또는 1분 단위 시간이 변했음에도 테이블 뷰의 시각 정보가 갱신되지 않음
- **원인**
  - 초기에 RxCocoa의 `.bind(to:)` 방식으로 단일 섹션을 구성하여 동작에는 문제가 없었음
  - 하지만 삭제/정렬 기능 구현을 위해 RxDataSources로 전환
  - RxDataSources는 내부적으로 `==` 연산자를 기준으로 diff를 계산함
  - `WorldClockEntity`에서 id와 `isEditing`만을 기준으로 비교하던 `==` 연산자에서는 시각 정보인 `hourMinuteString`, `amPmString`의 변화는 셀 변화로 인식되지 않음
    - → 그 결과 `configureCell()`이 호출되지 않아 셀 내용이 갱신되지 않음
- **해결**
  - `WorldClockEntity`의 `==` 연산자 구현을 수정하여 비교 기준에 `hourMinuteString`, `amPmString`도 포함시킴
    - → 셀의 시간 시각이 변할 경우에도 RxDataSources가 셀을 갱신 대상으로 판단
    - → 시각 정보 및 12/24시간제가 정상적으로 분 단위로 실시간 반영됨을 확인함

```swift
struct WorldClockEntity: Equatable, Identifiable {
    let id: UUID?
    let cityName: String?
    let cityNameKR: String?
    let timeZoneIdentifier: String?
    let createdAt: Date?
    let orderIndex: Int16
    let hourMinuteString: String
    let amPmString: String?
    let hourDifferenceText: String
    let dayLabelText: String
    var isEditing: Bool
}

extension WorldClockEntity: IdentifiableType {
    var identity: String { return id?.uuidString ?? UUID().uuidString }

    static func == (lhs: WorldClockEntity, rhs: WorldClockEntity) -> Bool {
        return lhs.id == rhs.id &&
               lhs.isEditing == rhs.isEditing &&
               lhs.hourMinuteString == rhs.hourMinuteString &&
               lhs.amPmString == rhs.amPmString
    }
}

typealias WorldClockSection = AnimatableSectionModel<String, WorldClockEntity>
```


### 곽다은
- **문제**
   - 여러 타이머 동시 실행 시 남은 시간이 일괄 갱신되어 UI가 부자연스러움
- **원인**
  - 타이머 ViewModel이 단일 RxTimer를 공유하며 모든 타이머가 동일 시간 흐름으로 작동함
- **해결**
  - 타이머마다 고유의 RxTimer를 생성하고, 각 타이머에 전용 disposeBag을 할당해 개별적으로 구독을 관리함
  - 타이머가 종료되면 해당 구독도 자동으로 해제되어 메모리 누수 방지
  - 각 타이머는 1초마다 개별적으로 ticker(PublishRelay)를 통해 UI 업데이트를 트리거함
  - UITableView의 보이는 셀만 업데이트하여 불필요한 스냅샷 연산을 줄이고 성능을 최적화함
- **코드**
  - ViewModel
  ```swift
  private func startTicking(timer: ActiveTimer) {
      guard let id = timer.id else { return }
  
      let timer = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
          .filter { _ in timer.isRunning }
          .asDriver(onErrorDriveWith: .empty())
          .drive(with: self) { owner, _ in
              if timer.isExpired {
                  guard let row = owner.state.activeTimers.value
                      .map({ $0.active! }).firstIndex(of: timer) else { return }
                  owner.deleteTimer(for: IndexPath(row: row, section: 0))
              } else {
                  owner.state.tick.accept(())
                  LiveActivityManager.shared.update(for: id, remainTime: timer.remainTime)
              }
          }
  
      timerBag[id] = timer
  }
  ```

  - ViewController
  ```swift
  viewModel.state.tick
      .asDriver(onErrorDriveWith: .empty())
      .drive(with: self) { owner, _ in
          owner.timerView.updateVisibleTimerCells()
      }
      .disposed(by: disposeBag)
  ```

  - View
  ```swift
  func updateVisibleTimerCells() {
      let visibleIndexPaths = tableView.indexPathsForVisibleRows ?? []
  
      for indexPath in visibleIndexPaths {
          guard let item = dataSource?.itemIdentifier(for: indexPath),
                let cell = tableView.cellForRow(at: indexPath) as? TimerActiveCell,
                let timer = item.active else { continue }
  
          cell.configureCell(
              time: timer.timeString,
              timeKR: timer.localizedTimeString,
              progress: timer.progress
          )
          cell.updateState(to: timer.isRunning ? .running : .pause)
      }
  }
  ```

### 손하경
- **문제**
   - Action-State 패턴 사용 중 action이 두 번 호출되는 현상 발생
- **원인**
  - 공통 부모 클래스에서 viewDidLoad에 bindViewModel()을 이미 호출 중이었으나, 하위 클래스에서 불필요하게 중복 오버라이드 함
- **해결**
  - 상속받은 클래스의 viewDidLoad에서 작성한 bindViewModel()을 제거하여 중복 호출 문제 해결

  ```swift
  final class StopWatchViewController: BaseViewController {
    // ...
    override func viewDidLoad() {
      super.viewDidLoad()
      setDataSource()
      viewModel.action.viewDidLoad.accept(())
    }
    // ...
  }
  
  // BaseViewController
  class BaseViewController: UIViewController {
    // ...
    override func viewDidLoad() {
      super.viewDidLoad()
      self.view.applyGradient()
      bindViewModel()
      setStyles()
      setLayout()
      setDelegates()
      setRegister()
    }
    // ...
  }
  ```

### 이세준
- **문제**
   - 알람 Notificatoin에서 길게 소리가 재생되지 않는 현상 (Notification에다가 알람 소리를 넣게 되면 6초 가량 소리만 남)
- **원인**
  - 공식 문서상 30초 내의 음원 파일을 재생이 가능하다라고 나와 있지만, 알림이 떠있는 시간 동안만 소리가 발생
  - 알람 속성은 개발단이 아닌 사용자 입장에서 설정해야하기 떄문에 사용자 의존성 필요
- **해결**
  - UNUserNotificationCenterDelegate에서 아래 코드를 사용하고 foreground에서의 이벤트 처리 때 AVPlayer로 음원 무한 루프 실행

  ```swift
    func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) 
  ```

  ```swift
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
#### ✅ 12/24시간제 자동 반영
- `DateFormatter.dateFormat(fromTemplate:)`를 활용해서 사용자 기기 설정에 따라 시간 포맷 자동 전환
- 앱이 background → foreground로 진입했을 때도 NotificationCenter + Rx 흐름으로 자동 업데이트 처리
- `hourMinuteString`, `amPmString`을 분리하여 label에 개별적으로 표현 (폰트 스타일 분리 가능)

```swift
private func addCustomObserver() {
    NotificationCenter.default.addObserver(
        self,
        selector: #selector(appWillEnterForeground),
        name: UIApplication.willEnterForegroundNotification,
        object: nil
    )
}

private func bindViewWillAppear() {
    worldClockViewModel.action.onNext(.viewWillAppear)
}

@objc private func appWillEnterForeground() {
    bindViewWillAppear()
}
```
```swift
private func fetchWorldClock() {
    Observable.just(useCase.fetchAll())
        .subscribe(with: self) { owner, items in
            owner.state.items.accept(items)
        }
        .disposed(by: disposeBag)
}
```

#### 🔁 분 단위 시계 실시간 갱신
- `Timer(fireAt:interval:)`를 사용하여 **다음 정각(분의 0초)**에 맞춰 타이머 시작
- `RunLoop.main.add(timer, forMode: .common)`으로 메인 런루프에 등록하여 UI 업데이트와 충돌 없이 동작
- `updateClock()`이 호출되면 `fetchWorldClock()` 메서드를 통해 현재 시간 데이터를 다시 불러옴
```swift
private func startClockTimer() {
    let now = Date()
    let intervalToNextMinute = 60 - now.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 60)
    let nextFullMinute = now.addingTimeInterval(intervalToNextMinute)
    timer = Timer(fireAt: nextFullMinute, interval: 60, target: self, selector: #selector(updateClock), userInfo: nil, repeats: true)
    RunLoop.main.add(timer!, forMode: .common)
}

@objc private func updateClock() {
    fetchWorldClock()
}
```

### 곽다은
#### ✅ 타이머 Live Activity
- 실행중인 타이머를 알림센터 및 잠금 화면에서 실시간 카운팅을 확인할 수 있습니다.
- 타이머를 생성하여 실행하거나, 일시정지 상태였던 타이머를 재개하는 usecase 메서드에서 `start(for:endAfter)`을 호출하여 시작합니다.
- 타이머가 종료, 삭제 또는 일시정지하는 usecase 메서드에서 `stop(for:)`를 호출하여 멈출 수 있습니다.
- 각 RxTimer에서 `update(for:remainTime)`을 호출하여 상태를 업데이트합니다.
- 작동 방식
```swift
final class LiveActivityManager: ObservableObject {
    static let shared = LiveActivityManager()

    private var activityMap: [UUID: Activity<BeontteukWidgetAttributes>] = [:]

    private init() {}

    // ...
}
```
`[UUID: Activity<CustomAttributes>]` 타입인 `activityMap`로 업데이트 또는 멈출 Activity를 찾아 작업을 수행합니다.

### 이세준
#### 알람 기능 (UNUserNotificationCenter)
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
