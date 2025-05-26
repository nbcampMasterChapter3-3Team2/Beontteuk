//
//  WorldClockViewModel.swift
//  Alarm
//
//  Created by 백래훈 on 5/20/25.
//

import Foundation

import RxSwift

final class WorldClockViewModel: ViewModelProtocol {
    
    enum Action {
        case viewDidLoad
    }
    
    struct State {
        
    }
    
    var action: AnyObserver<Action> { actionSubject.asObserver() }
    
    private let actionSubject = PublishSubject<Action>()
    
    let state = State()
    let disposeBag = DisposeBag()
    
    init() {
        bind()
    }
    
    private func bind() {
        actionSubject
            .subscribe(with: self) { owner, action in
                switch action {
                case .viewDidLoad:
                    return
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func fetchWorldClock() {
        
    }
    
}
