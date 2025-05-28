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
    
    private let diContainer: BeontteukDIContainerInerface
    private let worldClockViewModel: WorldClockViewModel
    
    //MARK: - init
    init(diContainer: BeontteukDIContainerInerface) {
        self.diContainer = diContainer
        self.worldClockViewModel = diContainer.makeWorldClockViewModel()
        
        super.init(nibName: nil, bundle: nil)
        
        self.addCustomObserver()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        bindEditButtonTapped()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        bindViewWillAppear()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        lazy var dataSource = RxTableViewSectionedAnimatedDataSource<WorldClockSection>(
            configureCell: { dataSource, tableView, indexPath, item in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: WorldClockTableViewCell.className, for: indexPath) as? WorldClockTableViewCell else { return UITableViewCell() }
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
            .bind(to: worldClockView.getWorldClockTableView().rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        worldClockViewModel.state.status
            .bind(with: self) { owner, value in
                let buttonType = value == true ? CustomUIBarButtonItem.NavigationButtonType.check : CustomUIBarButtonItem.NavigationButtonType.edit
                owner.worldClockView.getEditButton().updateType(buttonType)
                owner.worldClockView.getWorldClockTableView().setEditing(value, animated: true)
            }
            .disposed(by: disposeBag)
        
        worldClockView.getWorldClockTableView().rx.itemDeleted
            .withLatestFrom(worldClockViewModel.state.status) { indexPath, status in
                return (indexPath, status)
            }
            .bind(with: self) { owner, value in
                let (indexPath, status) = value
                let item = dataSource[indexPath]
                status ? owner.worldClockViewModel.action.onNext(.editDeleteCity(item, indexPath)) : owner.worldClockViewModel.action.onNext(.rowDeleteCity(item))
            }
            .disposed(by: disposeBag)
        
        worldClockView.getWorldClockTableView().rx.itemMoved
            .bind(with: self) { owner, movement in
                owner.worldClockViewModel.action.onNext(.moveCity(movement.sourceIndex, movement.destinationIndex))
            }
            .disposed(by: disposeBag)
    }
    
    override func setStyles() {
        super.setStyles()
        
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
                let vc = SelectCityViewController(selectCityViewModel: owner.diContainer.makeWorldCityViewModel())
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
