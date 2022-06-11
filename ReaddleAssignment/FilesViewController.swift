//
//  FilesViewController.swift
//  ReaddleAssignment
//
//  Created by Ahmed Mgua on 06/06/2022.
//

import UIKit

final class FilesViewController: FileTreeViewController {
    
    private let navigationTitle = "Files"
    
    /// The data source for the collection view
    private let viewModel = ViewModel()
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = navigationTitle
        
        setUpCollectionView(dataSource: viewModel)
        setUpNavigationButtons()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchSpreadsheet { [weak collectionView] in
            collectionView?.reloadData()
        }
    }
}


extension FilesViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let file = viewModel.files[indexPath.item]
        showDetailViewController(file)
    }
}

