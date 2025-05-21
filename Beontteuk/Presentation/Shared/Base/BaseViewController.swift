//
//  BaseViewController.swift
//  Alarm
//
//  Created by 백래훈 on 5/20/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

class BaseViewController: UIViewController {
    
    private lazy var viewControllerName = self.className
    
    var disposeBag = DisposeBag()
    
    deinit {
        print("🧶 \(viewControllerName) is deinited")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.applyGradient()
        bindViewModel()
        setStyles()
        setLayout()
        setDelegates()
        setRegister()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    /// Data 와 UI 를 bind 합니다.
    func bindViewModel() {}
    /// View 의 Style 을 set 합니다.
    func setStyles() {}
    /// View 의 Layout 을 set 합니다.
    func setLayout() {}
    /// View 의 Delegate 을 set 합니다.
    func setDelegates() {}
    /// View 의 Register 를 set 합니다.
    func setRegister() {}
}

