//
//  WorldClockViewModel.swift
//  Alarm
//
//  Created by 백래훈 on 5/20/25.
//

import Foundation

import RxSwift
import RxRelay

final class WorldClockViewModel: ViewModelProtocol {
    
    enum Action {
        case viewDidLoad
        case addCity(SelectCityEntity)
    }
    
    struct State {
        let items = PublishRelay<[WorldClockEntity]>()
    }
    
    var action: AnyObserver<Action> { actionSubject.asObserver() }
    
    private let actionSubject = PublishSubject<Action>()
    
    let state = State()
    let disposeBag = DisposeBag()
    
    private let useCase: WorldClockUseCase
    private var timer: Timer?
    
    init(useCase: WorldClockUseCase) {
        self.useCase = useCase
        
        bind()
        startClockTimer()
    }
    
    private func bind() {
        actionSubject
            .subscribe(with: self) { owner, action in
                switch action {
                case .viewDidLoad:
                    return owner.fetchWorldClock()
                case .addCity(let city):
                    return owner.createWorldClock(city)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func fetchWorldClock() {
        Observable.just(useCase.fetchAll())
            .subscribe(with: self) { owner, items in
                owner.state.items.accept(items)
            }
            .disposed(by: disposeBag)
    }
    
    private func createWorldClock(_ city: SelectCityEntity) {
        let newCity = useCase.createCity(
            cityName: city.cityName,
            cityNameKR: city.cityNameKR,
            timeZoneIdentifier: city.timeZoneIdentifier
        )
        useCase.saveCity(newCity)
        self.state.items.accept(useCase.fetchAll())
    }
    
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
    
}
