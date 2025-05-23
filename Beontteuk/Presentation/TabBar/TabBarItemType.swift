//
//  TabBarItemType.swift
//  Beontteuk
//
//  Created by 백래훈 on 5/23/25.
//

import UIKit

enum TabBarItemType: Int, CaseIterable {
    case alarm
    case stopWatch
    case timer
    case worldClock
}

extension TabBarItemType {
    var title: String {
        switch self {
        case .worldClock:
            return "세계 시계"
        case .alarm:
            return "알람"
        case .stopWatch:
            return "스톱워치"
        case .timer:
            return "타이머"
        }
    }
    
    var unSelectedIcon: UIImage {
        switch self {
        case .alarm:
            return UIImage(named: "alarmDefault")?.resize(to: CGSize(width: 25, height: 25)) ?? UIImage()
        case .stopWatch:
            return UIImage(named: "stopwatchDefault")?.resize(to: CGSize(width: 25, height: 25)) ?? UIImage()
        case .timer:
            return UIImage(named: "timerDefault")?.resize(to: CGSize(width: 25, height: 25)) ?? UIImage()
        case .worldClock:
            return UIImage(named: "worldclockDefault")?.resize(to: CGSize(width: 25, height: 25)) ?? UIImage()
        }
    }
    
    var selectedIcon: UIImage {
        switch self {
        case .alarm:
            return UIImage(named: "alarmSelected")?.resize(to: CGSize(width: 25, height: 25)) ?? UIImage()
        case .stopWatch:
            return UIImage(named: "stopwatchSelected")?.resize(to: CGSize(width: 25, height: 25)) ?? UIImage()
        case .timer:
            return UIImage(named: "timerSelected")?.resize(to: CGSize(width: 25, height: 25)) ?? UIImage()
        case .worldClock:
            return UIImage(named: "worldclockSelected")?.resize(to: CGSize(width: 25, height: 25)) ?? UIImage()
        }
    }
    
    func setTabBarItem() -> UITabBarItem {
        return UITabBarItem(title: self.title, image: unSelectedIcon, selectedImage: selectedIcon)
    }
}
