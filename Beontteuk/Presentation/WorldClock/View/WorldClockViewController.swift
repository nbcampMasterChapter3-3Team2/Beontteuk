//
//  WorldClockViewController.swift
//  Beontteuk
//
//  Created by 백래훈 on 5/23/25.
//

import UIKit

import RxSwift
import RxCocoa

final class WorldClockViewController: BaseViewController {
    //MARK: - Instances
    private let worldClockView = WorldClockView()
    private let headerView = WorldClockTableHeaderView()
    
    private let worldClockViewModel = WorldClockViewModel(useCase: WorldClockUseCase(repository: CoreDataWorldClockRepository()))
    
    //MARK: - View Life Cycles
    override func loadView() {
        view = worldClockView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindAction()
        setupHeaderView()
    }
    
    private func setupHeaderView() {
        let targetSize = CGSize(width: view.bounds.width, height: 0)
        let height = headerView.systemLayoutSizeFitting(targetSize).height
        headerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: height)
        
        headerView.addButton.rx.tap
            .bind(with: self) { owner, _ in
                let vc = SelectCityViewController()
                let nav = UINavigationController(rootViewController: vc)
                vc.modalPresentationStyle = .pageSheet
                vc.onCitySelected = { [weak self] selectedCity in
                    guard let self else { return }
                    print("✅ 선택된 도시: \(selectedCity.cityName)")
                    self.worldClockViewModel.action.onNext(.addCity(selectedCity))
                }
                owner.present(nav, animated: true)
            }
            .disposed(by: disposeBag)
        
        worldClockView.getWorldClockTableView().tableHeaderView = headerView
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        worldClockViewModel.state.items
            .do(onNext: { [weak self] items in
                guard let self else { return }
                self.worldClockView.getWorldClockTableView().backgroundView = items.isEmpty ? self.worldClockView.makeEmptyView() : nil
            })
            .bind(to: worldClockView.getWorldClockTableView().rx.items(
                cellIdentifier: WorldClockTableViewCell.className,
                cellType: WorldClockTableViewCell.self)
            ) { row, model, cell in
                cell.configureCell(with: model)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindAction() {
        worldClockViewModel.action.onNext(.viewDidLoad)
    }
    
    override func setStyles() {
        super.setStyles()
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func setLayout() {
        super.setLayout()
        
    }
}
