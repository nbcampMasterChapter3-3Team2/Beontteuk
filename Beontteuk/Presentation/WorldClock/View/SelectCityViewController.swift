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
        $0.obscuresBackgroundDuringPresentation = false
        $0.searchResultsUpdater = self
    }
    
    //MARK: Instances
    private let selectCityView = SelectCityView()
    private let selectCityViewModel: SelectCityViewModel
    
    var onCitySelected: ((SelectCityEntity) -> Void)?
    
    init(selectCityViewModel: SelectCityViewModel,
         onCitySelected: ((SelectCityEntity) -> Void)? = nil) {
        self.selectCityViewModel = selectCityViewModel
        self.onCitySelected = onCitySelected
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        self.selectCityViewModel.action.onNext(.viewDidLoad)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        selectCityViewModel.state.items
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
        selectCityViewModel.action.onNext(.searchQuery(query))
    }
}
