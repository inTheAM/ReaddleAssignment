//
//  FileTreeViewController.swift
//  ReaddleAssignment
//
//  Created by Ahmed Mgua on 11/06/2022.
//

import UIKit

class FileTreeViewController: UICollectionViewController {
    
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
    func setUpCollectionView(dataSource: UICollectionViewDataSource) {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: FileExplorerLayout())
        collectionView.alwaysBounceVertical = true
        collectionView.dataSource = dataSource
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
        } else {
            presentAlert()
        }
    }
    
    func presentAlert() {
        let alert = UIAlertController(title: "Internal error", message: "Unable to change layout", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    func showDetailViewController(_ file: FileItem) {
        let viewController = FilesDetailViewController()
        viewController.title = file.name
        viewController.files = file.children ?? []
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}
