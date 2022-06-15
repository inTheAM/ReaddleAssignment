//
//  FileTreeViewController.swift
//  ReaddleAssignment
//
//  Created by Ahmed Mgua on 11/06/2022.
//

import Combine
import UIKit

class FileTreeViewController: UICollectionViewController {
    private var cancellables = Set<AnyCancellable>()
    /// The data source for the collection view
    private(set)var viewModel: ViewModel
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(file: FileItem = .rootDirectory) {
        viewModel = .init(file: file)
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = false
        title = viewModel.file.value.name
        setUpCollectionView()
        setUpNavigationButtons()
        
        // Subscribing to the file publisher
        viewModel.file
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.error
            .compactMap { $0 }
            .sink { [weak self] error in
                self?.presentErrorAlert(error)
            }
            .store(in: &cancellables)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let file = viewModel.file.value.children?[indexPath.item] {
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
    
    private lazy var addItemButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.frame = .init(x: 0, y: 0, width: 40, height: 40)
        button.accessibilityLabel = "Add a file or folder"
        button.addTarget(self, action: #selector(presentAddItemOptions), for: .touchUpInside)
        button.accessibilityIdentifier = "add-item-button"
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
        let layoutButton = UIBarButtonItem(customView: switchLayoutButton)
        let addButton = UIBarButtonItem(customView: addItemButton)
        navigationController?.navigationItem.rightBarButtonItems = [layoutButton, addButton]
        navigationItem.rightBarButtonItems = navigationController?.navigationItem.rightBarButtonItems
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
    
    @objc func presentAddItemOptions() {
        let alert = UIAlertController(title: "New", message: nil, preferredStyle: .actionSheet)
        let file = UIAlertAction(title: "File", style: .default) { [weak self] _ in
            self?.presentAddItemDetailsAlert(.file)
        }
        let folder = UIAlertAction(title: "Folder", style: .default) { [weak self] _ in
            self?.presentAddItemDetailsAlert(.file)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(file)
        alert.addAction(folder)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    func presentErrorAlert(_ error: ErrorAlert) {
        let alert = UIAlertController(title: error.title, message: error.message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    func presentAddItemDetailsAlert(_ fileType: FileItem.FileType) {
        let title: String
        switch fileType {
        case .file:
            title = "file"
        case .directory:
            title = "folder"
        }
        let alert = UIAlertController(title: "New \(title)", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "\(title.capitalized) name"
        }
        let ok = UIAlertAction(title: "OK", style: .default) { _ in
            if let filename = alert.textFields?.first?.text {
                let newFile: FileItem
                if self.viewModel.file.value == .rootDirectory {
                    newFile = FileItem(id: UUID(), name: filename, fileType: fileType)
                } else {
                    newFile = FileItem(id: UUID(), parentID: self.viewModel.file.value.id, name: filename, fileType: fileType)
                }
                self.viewModel.addNewFileItem(newFile)
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    func showDetailViewController(_ file: FileItem) {
        let viewController = FilesDetailViewController(file: file)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}
