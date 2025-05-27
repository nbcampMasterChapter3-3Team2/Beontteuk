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
        case viewWillAppear
        case addCity(SelectCityEntity)
        case editButtonTapped
        case rowDeleteCity(WorldClockEntity)
        case editDeleteCity(WorldClockEntity, IndexPath)
    }
    
    struct State {
        let items = BehaviorRelay<[WorldClockEntity]>(value: [])
        let status = BehaviorRelay<Bool>(value: false)
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
                case .viewWillAppear:
                    return owner.fetchWorldClock()
                case .addCity(let city):
                    return owner.createWorldClock(city)
                case .editButtonTapped:
                    return owner.toggleEditButtonStatus()
                case .rowDeleteCity(let city):
                    return owner.rowDeleteWorldClock(city)
                case .editDeleteCity(let city, let indexPath):
                    return owner.editDeleteWorldClock(city, indexPath)
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
        // 중복 방지 로직 추가
        if useCase.exists(timeZoneIdentifier: city.timeZoneIdentifier) {
            return
        }

        let newCity = useCase.createCity(
            cityName: city.cityName,
            cityNameKR: city.cityNameKR,
            timeZoneIdentifier: city.timeZoneIdentifier
        )
        useCase.saveCity(newCity)
        self.state.items.accept(useCase.fetchAll())
    }
    
    private func editDeleteWorldClock(_ city: WorldClockEntity, _ indexPath: IndexPath) {
        useCase.deleteCity(city)
        var items = state.items.value
        items.remove(at: indexPath.row)
        state.items.accept(items)
    }
    
    private func rowDeleteWorldClock(_ city: WorldClockEntity) {
        useCase.deleteCity(city)
        state.items.accept(useCase.fetchAll())
    }
    
    private func toggleEditButtonStatus() {
        let isEditing = !state.status.value
        state.status.accept(isEditing)
        
        // 강제 트리거 없이, 상태값을 포함한 새로운 배열로 교체
        let newItems = state.items.value.map {
            var updated = $0
            updated.isEditing = isEditing
            return updated
        }
        state.items.accept(newItems)
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
