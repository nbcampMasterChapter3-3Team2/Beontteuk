//
//  SelectCityViewController.swift
//  Beontteuk
//
//  Created by 백래훈 on 5/26/25.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

final class SelectCityViewController: BaseViewController {
    //MARK: UI Components
    private lazy var searchController = UISearchController().then {
        $0.searchBar.placeholder = "검색"
//        $0.isActive = true
        $0.obscuresBackgroundDuringPresentation = false
        $0.searchResultsUpdater = self
    }
    
    //MARK: Instances
    private let selectCityView = SelectCityView()
    private let viewModel = SelectCityViewModel(useCase: WorldCityUseCase(repository: WorldCityRepository()))
    
    var onCitySelected: ((SelectCityEntity) -> Void)?
    
    override func loadView() {
        view = selectCityView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindAction()
        
    }
    
    override func setStyles() {
        super.setStyles()
        
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "도시 선택"
    }
    
    override func setLayout() {
        super.setLayout()
        
    }
    
    private func bindAction() {
        self.viewModel.action.onNext(.viewDidLoad)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        viewModel.state.items
            .bind(to: selectCityView.cityTableView.rx.items(cellIdentifier: SelectCityTableViewCell.className, cellType: SelectCityTableViewCell.self)) { row, item, cell in
                cell.configureCell(with: item)
            }
            .disposed(by: disposeBag)
        
        selectCityView.cityTableView.rx.modelSelected(SelectCityEntity.self)
            .bind(with: self) { owner, item in
                owner.onCitySelected?(item)
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
}

extension SelectCityViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text else { return }
        viewModel.action.onNext(.searchQuery(query))
    }
}
