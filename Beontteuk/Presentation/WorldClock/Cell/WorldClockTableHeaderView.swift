//
//  WorldClockTableHeaderView.swift
//  Beontteuk
//
//  Created by 백래훈 on 5/23/25.
//

import UIKit

import RxSwift
import SnapKit
import Then

final class WorldClockTableHeaderView: BaseView {
    //MARK: UI Components
    private let worldClockImage = UIImageView().then {
        $0.image = UIImage(resource: .worldclock)
        $0.contentMode = .scaleAspectFit
    }
    
    let addButton = AddButton(type: .city).then {
        $0.setShadow(type: .large)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        addButton.updateShadowPath()
    }
    
    override func setStyles() {
        super.setStyles()
    }
    
    override func setLayout() {
        super.setLayout()
        
        self.addSubviews(worldClockImage, addButton)
        
        worldClockImage.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.size.equalTo(200)
        }
        
        addButton.snp.makeConstraints {
            $0.top.equalTo(worldClockImage.snp.bottom).offset(16)
            $0.directionalHorizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(60)
            $0.bottom.equalToSuperview().offset(-16)
        }
    }
}
