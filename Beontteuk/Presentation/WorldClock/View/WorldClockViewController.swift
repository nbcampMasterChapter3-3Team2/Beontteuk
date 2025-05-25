//
//  WorldClockViewController.swift
//  Beontteuk
//
//  Created by 백래훈 on 5/23/25.
//

import UIKit

import RxSwift
import RxRelay

struct WorldClockDummy {
    let city: String
    let timeDifference: String
    let time: String
}

final class WorldClockViewController: BaseViewController {
    
    private let worldClockView = WorldClockView()
    
    override func loadView() {
        super.loadView()
        
        view = worldClockView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dummyData = BehaviorRelay<[WorldClockDummy]>(value: [
            WorldClockDummy(city: "런던", timeDifference: "오늘, -8시간", time: "09:00"),
            WorldClockDummy(city: "도쿄", timeDifference: "오늘, +0시간", time: "17:00"),
            WorldClockDummy(city: "뉴욕", timeDifference: "어제, -13시간", time: "04:00"),
            WorldClockDummy(city: "서울", timeDifference: "오늘, +0시간", time: "17:00"),
            WorldClockDummy(city: "런던", timeDifference: "오늘, -8시간", time: "09:00"),
            WorldClockDummy(city: "도쿄", timeDifference: "오늘, +0시간", time: "17:00"),
            WorldClockDummy(city: "뉴욕", timeDifference: "어제, -13시간", time: "04:00"),
            WorldClockDummy(city: "서울", timeDifference: "오늘, +0시간", time: "17:00"),
            WorldClockDummy(city: "런던", timeDifference: "오늘, -8시간", time: "09:00"),
            WorldClockDummy(city: "도쿄", timeDifference: "오늘, +0시간", time: "17:00"),
            WorldClockDummy(city: "뉴욕", timeDifference: "어제, -13시간", time: "04:00"),
            WorldClockDummy(city: "서울", timeDifference: "오늘, +0시간", time: "17:00")
        ])
        
        dummyData
            .do(onNext: { [weak self] items in
                guard let self else { return }
                self.worldClockView.getWorldClockTableView().backgroundView = items.isEmpty ? self.worldClockView.makeEmptyView() : nil
            })
            .bind(to: worldClockView.getWorldClockTableView().rx.items(
                cellIdentifier: WorldClockTableViewCell.className,
                cellType: WorldClockTableViewCell.self)
            ) { row, model, cell in
                cell.configureCell(with: model)
            }
            .disposed(by: disposeBag)
    }
    
    override func setStyles() {
        super.setStyles()
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func setLayout() {
        super.setLayout()
        
    }
}
