//
//  SelectCityViewModel.swift
//  Beontteuk
//
//  Created by 백래훈 on 5/26/25.
//

import Foundation

import RxSwift
import RxRelay

final class SelectCityViewModel: ViewModelProtocol {
    //MARK: Action
    enum Action {
        case viewDidLoad
        case searchQuery(String)
    }
    //MARK: State
    struct State {
        let items = BehaviorRelay<[SelectCityEntity]>(value: [])
    }
    
    var action: AnyObserver<Action> { actionSubject.asObserver() }
    
    private let actionSubject = PublishSubject<Action>()
    
    let state = State()
    let disposeBag = DisposeBag()
    
    private let useCase: WorldCityUseCaseProtocol
    
    init(useCase: WorldCityUseCase) {
        self.useCase = useCase
        
        bind()
    }
    
    private func bind() {
        actionSubject
            .subscribe(with: self) { owner, action in
                switch action {
                case .viewDidLoad:
                    return owner.fetchWorldClock()
                case .searchQuery(let query):
                    return owner.searchWorldClock(query: query)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func fetchWorldClock() {
        useCase.fetchCityList()
            .subscribe(with: self) { owner, items in
                owner.state.items.accept(items)
            } onFailure: { owner, error in
                print("Single Zip Error: \(error)")
            }
            .disposed(by: disposeBag)
    }
    
    private func searchWorldClock(query: String) {
        useCase.fetchCityList()
            .map { items in
                guard !query.isEmpty else { return items }
                return items.filter {
                    $0.cityNameKR.lowercased().contains(query.lowercased())
                }
            }
            .subscribe(with: self) { owner, items in
                owner.state.items.accept(items)
            } onFailure: { owner, error in
                print("Single Zip Error: \(error)")
            }
            .disposed(by: disposeBag)
    }
}
