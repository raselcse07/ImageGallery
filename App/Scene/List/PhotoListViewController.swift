//
//  PhotoListViewController.swift
//  ImageGallery
//
//  Created by Rasel on 2021/10/16.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class PhotoListViewController: BaseViewController, ViewModelable, Coordinatable, RootViewConfigurator {
    
    // MARK: - ViewModel, Coordinator & RootView Type
    typealias ViewModelType = PhotoListViewModel
    typealias CoordinatorType = PhotoListCoordinator
    typealias RootViewType = PhotoListView
    
    // MARK: - Properties
    var viewModel: PhotoListViewModel!
    var coordinator: PhotoListCoordinator?
    
    lazy private var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = Const.SEARCH_BAR_PLACEHOLDER
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        searchController.searchBar.sizeToFit()
        searchController.searchBar.isTranslucent = false
        return searchController
    }()
    
    // MARK: - Life Cycle
    override func loadView() {
        view = RootViewType()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func bindViewModel() {
        
        // Input
        searchController
            .searchBar
            .rx
            .text
            .orEmpty
            .bind(to: viewModel.input.searchText)
            .disposed(by: disposeBag)
        
        rootView
            .collectionView
            .rx
            .itemSelected
            .bind(to: viewModel.input.itemSelected)
            .disposed(by: disposeBag)
        
        rootView
            .collectionView
            .rx
            .toBottom()
            .skip(1)
            .bind(to: viewModel.input.loadMore)
            .disposed(by: disposeBag)
        
        // Output
        viewModel
            .output
            .photos
            .drive(rootView.collectionView.rx.items(cellIdentifier: PhotoListCell.indentifier, cellType: PhotoListCell.self)) { _ , model, cell in
                cell.setup(model: model)
            }
            .disposed(by: disposeBag)
        
        viewModel
            .output
            .detail
            .bind { data in
                print(data) // TODO: Show Detail
            }
            .disposed(by: disposeBag)
        
        searchController
            .searchBar
            .rx
            .searchButtonClicked
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.searchController.searchBar.resignFirstResponder()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Configure
extension PhotoListViewController {
    
    private func configure() {
        
        navigationItem.searchController = searchController
        navigationItem.title = Const.NAV_TITLE_PHOTO_LIST
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationController?.navigationBar.prefersLargeTitles = true

        // Regsiter CollectionView Cell
        rootView.collectionView.register(PhotoListCell.self, forCellWithReuseIdentifier: PhotoListCell.indentifier)
    }
}
