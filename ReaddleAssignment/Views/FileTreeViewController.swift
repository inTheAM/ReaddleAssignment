//
//  FileTreeViewController.swift
//  ReaddleAssignment
//
//  Created by Ahmed Mgua on 11/06/2022.
//

import UIKit

class FileTreeViewController: UICollectionViewController {
    
    /// The data source for the collection view
    var viewModel = ViewModel()
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .systemBackground
        title = viewModel.file.name
        setUpCollectionView()
        setUpNavigationButtons()
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let file = viewModel.file.children?[indexPath.item] {
            showDetailViewController(file)
        }
    }
    
    /// The navigation button to change the view's layout from grid to list and vice versa.
    private lazy var switchLayoutButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: FileExplorerLayout.buttonIcon), for: .normal)
        button.frame = .init(x: 0, y: 0, width: 40, height: 40)
        button.accessibilityLabel = "Switch layout from grid to list"
        button.addTarget(self, action: #selector(switchLayout), for: .touchUpInside)
        button.accessibilityIdentifier = "toggle-list-button"
        return button
    }()
    
    
    /// Set's up the view controller's collection view using the given datasource.
    /// - Parameters:
    ///   - dataSource: The data source for the collection view.
    func setUpCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: FileExplorerLayout())
        collectionView.alwaysBounceVertical = true
        collectionView.dataSource = viewModel
        collectionView.register(FileIcon.self, forCellWithReuseIdentifier: FileIcon.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.accessibilityIdentifier = "files-collection-view"
        
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    
    func setUpNavigationButtons() {
        let button = UIBarButtonItem(customView: switchLayoutButton)
        navigationController?.navigationItem.rightBarButtonItem = button
        navigationItem.rightBarButtonItem = navigationController?.navigationItem.rightBarButtonItem
    }
    
    func reloadCollectionView() {
        let contentOffset = collectionView.contentOffset
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
        collectionView.setContentOffset(contentOffset, animated: false)
    }
    
    func updateLayoutButtonAccessibilityDetails() {
        switchLayoutButton.accessibilityLabel = "Switch layout from " + (FileExplorerLayout.layoutType == .grid ? "grid to list" : "list to grid")
        switchLayoutButton.accessibilityIdentifier = "toggle-" + (FileExplorerLayout.layoutType == .grid ? "list" : "grid") + "-button"
    }
    
    func prepareLayoutChange() {
        let layout = FileExplorerLayout()
        switchLayoutButton.setImage(UIImage(systemName: FileExplorerLayout.buttonIcon), for: .normal)
        reloadCollectionView()
        updateLayoutButtonAccessibilityDetails()
        self.collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    @objc func switchLayout() {
        FileExplorerLayout.toggle()
        prepareLayoutChange()
        if let viewControllers = navigationController?.viewControllers {
            for controller in viewControllers {
                if let vc = controller as? FileTreeViewController {
                    vc.prepareLayoutChange()
                }
            }
        }
    }
    
    func showDetailViewController(_ file: FileItem) {
        let viewController = FilesDetailViewController()
        viewController.viewModel = ViewModel(file: file)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}
