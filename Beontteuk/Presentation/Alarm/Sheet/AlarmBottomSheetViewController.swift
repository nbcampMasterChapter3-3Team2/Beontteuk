//
//  AlarmBottomSheetViewController.swift
//  Beontteuk
//
//  Created by yimkeul on 5/21/25.
//

import UIKit

import SnapKit
import Then
import RxSwift

final class AlarmBottomSheetViewController: BaseViewController {


    private let bottomSheetView = AlarmBottomSheetView()

    override func loadView() {
        view = bottomSheetView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = NavigationItemType.title.view()
        // cancel 버튼에 didTapCancel(_:) 연결
          navigationItem.leftBarButtonItem = UIBarButtonItem(
              customView: NavigationItemType.cancel(
                  target: self,
                  action: #selector(didTapCancel)
              ).view()
          )

          // save 버튼에 didTapSave(_:) 연결
          navigationItem.rightBarButtonItem = UIBarButtonItem(
              customView: NavigationItemType.save(
                  target: self,
                  action: #selector(didTapSave)
              ).view()
          )
    }



    @objc
        private func didTapCancel() {
            dismiss(animated: true)
        }

        @objc
        private func didTapSave() {
            // 저장 로직 호출
        }
}

extension AlarmBottomSheetViewController {

    enum NavigationItemType {
        case title
        case cancel(target: Any, action: Selector)
        case save(target: Any, action: Selector)

        func view() -> UIView {
            switch self {
            case .title:
                return UILabel().then {
                    $0.font = .systemFont(ofSize: 16, weight: .semibold)
                    $0.textColor = .neutral1000
                    $0.text = "알람 추가"
                }
            case .cancel(let target, let action):
                return UIButton().then {
                    $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
                    $0.setTitle("취소", for: .normal)
                    $0.setTitleColor(.primary500, for: .normal)
                    $0.addTarget(target, action: action, for: .touchUpInside)
                }
            case .save(let target, let action):
                return UIButton().then {
                    $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
                    $0.setTitle("저장", for: .normal)
                    $0.tintColor = .primary500
                    $0.setTitleColor(.primary500, for: .normal)
                    $0.addTarget(target, action: action, for: .touchUpInside)
                }
            }
        }
    }
}
