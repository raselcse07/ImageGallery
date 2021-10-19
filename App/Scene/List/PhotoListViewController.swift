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
    
    lazy private var activityIndicator: UIActivityIndicatorView = {
        return UIActivityIndicatorView(style: .medium)
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
        
        searchController
            .searchBar
            .rx
            .cancelButtonClicked
            .map { _ in Const.SEARCH_INITIAL }
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
            .bind(to: viewModel.input.fetchNextPage)
            .disposed(by: disposeBag)

        // Output
        viewModel
            .output
            .photos
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] photo in
                guard let self = self else { return }
                let currentStart = self.viewModel.output.currentStartIndex.value
                let currentEnd = self.viewModel.output.currentEndIndex.value
                let indexPath = self.viewModel.createIndexPathToReload(start: currentStart, end: currentEnd)
                self.activityIndicator.startAnimating()
                self.rootView.collectionView.insertItems(start: currentStart, end: currentEnd, indexPath: indexPath) {
                    self.activityIndicator.stopAnimating()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel
            .output
            .detail
            .bind { [weak self] photo in
                guard let self = self else { return }
                self.coordinator?.detail(with: photo)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Configure
extension PhotoListViewController {
    
    private func configure() {
        
        navigationItem.searchController = searchController
        navigationItem.title = Const.NAV_TITLE_PHOTO_LIST
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.prefersLargeTitles = true
        // Collection View Setup
        rootView.collectionView.keyboardDismissMode = .onDrag
        rootView.collectionView.dataSource = self
        // Regsiter CollectionView Cell & Supplementary View
        rootView.collectionView.register(PhotoListCell.self)
        rootView.collectionView.register(view: UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter)

    }
}

// MARK: - UICollectionViewDataSource
extension PhotoListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.output.photos.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: PhotoListCell.self, indexPath: indexPath)
        let photo = viewModel.output.photos.value[indexPath.row]
        cell.setup(model: photo)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(with: UICollectionReusableView.self, kind: kind, indexPath: indexPath)
            footer.addSubview(activityIndicator)
            activityIndicator.frame = CGRect(x: 0, y: 0, width: collectionView.bounds.width, height: 50)
            return footer
        }
        return UICollectionReusableView()
    }
}
