//
//  TimerViewController.swift
//  Beontteuk
//
//  Created by 곽다은 on 5/21/25.
//

import UIKit
import SnapKit
import Then

final class TimerViewController: BaseViewController {

    // MARK: - UI Components

    private let timerView = TimerView()

    // MARK: - View Life Cycle

    override func loadView() {
        view = timerView
    }
}
