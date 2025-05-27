//
//  WorldClockViewController.swift
//  Beontteuk
//
//  Created by 백래훈 on 5/23/25.
//

import UIKit

import RxCocoa
import RxDataSources
import RxSwift

final class WorldClockViewController: BaseViewController {
    //MARK: - Instances
    private let worldClockView = WorldClockView()
    private let headerView = WorldClockTableHeaderView()
    
    private let worldClockViewModel = WorldClockViewModel(useCase: WorldClockUseCase(repository: CoreDataWorldClockRepository()))
    
    //MARK: - Deinit
    deinit {
        removeCustomObserver()
    }
    
    //MARK: - View Life Cycles
    override func loadView() {
        view = worldClockView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupHeaderView()
        addCustomObserver()
        bindEditButtonTapped()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        bindViewWillAppear()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        lazy var dataSource = RxTableViewSectionedAnimatedDataSource<WorldClockSection>(
            configureCell: { ds, tv, indexPath, item in
                guard let cell = tv.dequeueReusableCell(withIdentifier: WorldClockTableViewCell.className, for: indexPath) as? WorldClockTableViewCell else { return UITableViewCell() }
                cell.configureCell(with: item)
                return cell
            },
            canEditRowAtIndexPath: { _, _ in true },
            canMoveRowAtIndexPath: { _, _ in true }
        )
        
        worldClockViewModel.state.items
            .do(onNext: { [weak self] items in
                guard let self else { return }
                self.worldClockView.getWorldClockTableView().backgroundView = items.isEmpty ? self.worldClockView.makeEmptyView() : nil
            })
            .map { [WorldClockSection(model: "WorldClock", items: $0)] }
            .asDriver(onErrorJustReturn: [])
            .drive(worldClockView.getWorldClockTableView().rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        worldClockViewModel.state.status
            .bind(with: self) { owner, value in
                let buttonType = value == true ? CustomUIBarButtonItem.NavigationButtonType.check : CustomUIBarButtonItem.NavigationButtonType.edit
                owner.worldClockView.getEditButton().updateType(buttonType)
                owner.worldClockView.getWorldClockTableView().isEditing = value
            }
            .disposed(by: disposeBag)
        
        worldClockView.getWorldClockTableView().rx.itemDeleted
            .bind(with: self) { owner, indexPath in
                let item = dataSource[indexPath]
                owner.worldClockViewModel.action.onNext(.deleteCity(item))
            }
            .disposed(by: disposeBag)
    }
    
    override func setStyles() {
        super.setStyles()
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func setLayout() {
        super.setLayout()
        
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
    
    private func bindViewWillAppear() {
        worldClockViewModel.action.onNext(.viewWillAppear)
    }
    
    private func bindEditButtonTapped() {
        (worldClockView.getEditButton().customView as? UIButton)?.rx.tap
            .bind(with: self) { owner, _ in
                owner.worldClockViewModel.action.onNext(.editButtonTapped)
            }
            .disposed(by: disposeBag)
    }
    
    private func addCustomObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appWillEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }
    
    private func removeCustomObserver() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }
    
    @objc private func appWillEnterForeground() {
        bindViewWillAppear()
    }
}
