//
//  BaseView.swift
//  Alarm
//
//  Created by 백래훈 on 5/20/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

class BaseView: UIView {
    
    private lazy var viewName = self.className
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyles()
        setLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // 뷰의 bounds가 변경될 때마다 gradient.frame을 갱신
        refreshGradient()
    }

    override func removeFromSuperview() {
        super.removeFromSuperview()
        print("🧵 \(viewName) has been successfully Removed")
    }
    
    /// View 의 Style 을 set 합니다.
    func setStyles() {}
    /// View 의 Layout 을 set 합니다.
    func setLayout() {}
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
