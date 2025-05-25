//
//  StopWatchViewModel.swift
//  Alarm
//
//  Created by 백래훈 on 5/20/25.
//

import RxSwift
import RxRelay

enum TimeState {
    case initial
    case progress
    case pause
}

final class StopWatchViewModel {

    // MARK: - Action, State

    enum StopWatchAction {
        case leftButton
        case rightButton
    }

    struct StopWatchState {
        let timeSubject = BehaviorRelay<TimeState>(value: .initial)
    }

    // MARK: - Properties

    var action = PublishRelay<StopWatchAction>()
    var state = StopWatchState()
    private let disposeBag = DisposeBag()

    // MARK: - Initializer, Deinit, requiered

    init() {
        bindAction()
    }

    // MARK: - Bind

    private func bindAction() {
        action
            .bind { [weak self] action in
                guard let self else { return }

                let timeState = state.timeSubject.value

                switch action {
                case .leftButton:
                    switch timeState {
                    case .initial:
                        // TODO: CoreData
                        self.state.timeSubject.accept(.progress)
                    case .progress:
                        // TODO: 랩 활성화 -> CoreData
                        print("랩 찍힘")
                    case .pause:
                        // TODO: CoreData
                        self.state.timeSubject.accept(.initial)
                    }

                case .rightButton:

                    let timeState = state.timeSubject.value

                    switch timeState {
                    case .initial:
                        // TODO: CoreData
                        self.state.timeSubject.accept(.progress)
                    case .progress:
                        // TODO: CoreData
                        self.state.timeSubject.accept(.pause)
                    case .pause:
                        // TODO: CoreData
                        self.state.timeSubject.accept(.progress)
                    }
                }
            }.disposed(by: disposeBag)
    }
}
