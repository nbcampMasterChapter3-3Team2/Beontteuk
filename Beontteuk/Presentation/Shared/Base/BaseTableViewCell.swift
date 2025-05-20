//
//  BaseTableViewCell.swift
//  Alarm
//
//  Created by 백래훈 on 5/20/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

class BaseTableViewCell: UITableViewCell {
    
    private lazy var viewName = self.className
    
    var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setStyles()
        setLayout()
    }
    
    /// 셀 재사용 시 이벤트 중복 바인딩을 막기 위해 선언 UITableVIewCell은 스크롤 시 재사용 되는데
    /// 이전 셀에 바인딩 된 구독이 남아 있으면 의도치 않은 동작이 발생할 수 있어 disposeBag을 초기화 함
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    /// Cell 의 Style 을 set 합니다.
    func setStyles() {}
    /// Cell 의 Layout 을 set 합니다.
    func setLayout() {}

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
