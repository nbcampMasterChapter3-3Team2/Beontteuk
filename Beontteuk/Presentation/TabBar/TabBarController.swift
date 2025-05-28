//
//  TabBarController.swift
//  Beontteuk
//
//  Created by 백래훈 on 5/23/25.
//

import UIKit

import SnapKit
import Then

final class TabBarController: UITabBarController {
    //MARK: UI Components
    /// 탭바의 라운드 곡선 처리를 위한 View
    private let tabBackgroundView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 20
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.layer.masksToBounds = true
    }
    
    //MARK: View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayouts()
        setTabBarItems()
    }
    
    //MARK: Methods
    private func setLayouts() {
        tabBar.insertSubview(tabBackgroundView, at: 0)
        
        tabBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func setTabBarItems() {
        let diContainer = BeontteukDIContainer()
        
        let alarmRepository = CoreDataAlarmRepository()
        let alarmUseCase = AlarmUseImp(repository: alarmRepository)
        let alarmViewModel = AlarmViewModel(useCase: alarmUseCase)
        let alarmBottomSheetViewModel = AlarmBottomSheetViewModel(useCase: alarmUseCase)
        let alarmViewController = AlarmViewController(viewModel: alarmViewModel, bottomSheetViewModel: alarmBottomSheetViewModel)

        let stopWatchRepository = CoreDataStopWatchRepository()
        let lapRecordRepository = CoreDataLapRecordRepository()
        let stopWatchUseCase = StopWatchUseImp(repository: stopWatchRepository)
        let lapRecordUseCase = LapRecordUseImp(repository: lapRecordRepository)
        let stopWatchViewModel = StopWatchViewModel(stopWatchUseCase: stopWatchUseCase, lapRecordUseCase: lapRecordUseCase)
        let stopWatchViewController = StopWatchViewController(viewModel: stopWatchViewModel)

        let timerRepository = CoreDataCDTimerRepository()
        let notificationService = NotificationService()
        let timerUseCase = TimerUseImp(repository: timerRepository, notificationService: notificationService)
        let timerViewModel = TimerViewModel(useCase: timerUseCase)
        let timerViewController = UINavigationController(rootViewController: TimerViewController(viewModel: timerViewModel))
        
        let worldClockViewController = WorldClockViewController(diContainer: diContainer)

        let tabControllers = [
            alarmViewController,
            stopWatchViewController,
            timerViewController,
            worldClockViewController
        ]
        
        let appearance = makeTabBarAppearance()
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        
        TabBarItemType.allCases.forEach {
            let tabBarItem = $0.setTabBarItem()
            tabControllers[$0.rawValue].tabBarItem = tabBarItem
            tabControllers[$0.rawValue].tabBarItem.tag = $0.rawValue
        }
        
        setViewControllers(tabControllers, animated: false)
    }
    
    /// iOS 15 이상에서의 탭바 변경을 위한 Appearance 설정
    private func makeTabBarAppearance() -> UITabBarAppearance {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        appearance.shadowImage = nil
        appearance.shadowColor = .clear
        
        appearance.stackedLayoutAppearance.normal.iconColor = .systemGray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.systemGray,
            .font: UIFont.systemFont(ofSize: 14, weight: .bold)
        ]
        
        appearance.stackedLayoutAppearance.selected.iconColor = .primary500
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.primary500,
            .font: UIFont.systemFont(ofSize: 14, weight: .bold)
        ]
        
        return appearance
    }
}
