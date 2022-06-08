//
//  ViewController.swift
//  ReaddleAssignment
//
//  Created by Ahmed Mgua on 06/06/2022.
//

import UIKit

class ViewController: UIViewController {
    private let navigationTitle = "Readdle"
    
    /// The data source and delegate for the collection view
    private let viewModel = ViewModel()
    
    private lazy var collectionView: UICollectionView = {
        let layout = FileExplorerLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(FileIcon.self, forCellWithReuseIdentifier: "icon")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.accessibilityIdentifier = "files-collection-view"
        return collectionView
    }()
    
    private lazy var switchLayoutButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        button.addTarget(self, action: #selector(switchLayout), for: .touchUpInside)
        button.frame = .init(x: 0, y: 0, width: 40, height: 40)
        button.accessibilityLabel = "Switch layout from grid to list"
        button.accessibilityIdentifier = "toggle-list-button"
        return button
    }()
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = navigationTitle
        
        setUpCollectionView()
        setUpNavigationButtons()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func updateAccessibilityLabels() {
        switchLayoutButton.accessibilityLabel = "Switch layout from " + (FileExplorerLayout.layoutType == .grid ? "grid to list" : "list to grid")
        switchLayoutButton.accessibilityIdentifier = "toggle-" + (FileExplorerLayout.layoutType == .grid ? "list" : "grid") + "-button"
    }
    
    private func setUpCollectionView() {
        view.addSubview(collectionView)
        collectionView.delegate = viewModel
        collectionView.dataSource = viewModel
        collectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    private func setUpNavigationButtons() {
        let button = UIBarButtonItem(customView: switchLayoutButton)
        navigationItem.rightBarButtonItem = button
    }
    
    /// Toggles the collection view layout between grid and list views
    @objc private func switchLayout() {
        let layout = FileExplorerLayout()
        switch FileExplorerLayout.layoutType {
        case .grid:
            FileExplorerLayout.layoutType = .list
            switchLayoutButton.setImage(UIImage(systemName: "square.grid.2x2"), for: .normal)
        default:
            FileExplorerLayout.layoutType = .grid
            switchLayoutButton.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        }
        collectionView.reloadData()
        
        updateAccessibilityLabels()
        self.collectionView.setCollectionViewLayout(layout, animated: true)
    }
}

