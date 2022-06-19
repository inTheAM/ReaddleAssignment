//
//  FileTreeViewController.swift
//  ReaddleAssignment
//
//  Created by Ahmed Mgua on 11/06/2022.
//

import Combine
import UIKit

/// The main view controller for displaying a file tree.
class FileTreeViewController: UICollectionViewController {
    
    /// The subscriptions this view will create.
    private var cancellables = Set<AnyCancellable>()
    
    /// The data source for the collection view
    private(set)var viewModel: ViewModel
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Initializes the view controller and view model with a specific file if provided or the root directory.
    init(file: FileItem = .root()) {
        viewModel = .init(file: file)
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: - ViewController Lifecycle
    
    /// Loads the view into memory.
    ///
    /// The title is set to the name of the current directory;
    /// The collection view is set up using the datasource and a custom layout;
    /// The navigation buttons are set up (add file, change layout, sign in/out);
    override func loadView() {
        view = UIView()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = false
        title = viewModel.file.value.name
        setUpCollectionView()
        setUpNavigationButtons()
    }
    
    /// Runs when the view has loaded into memory.
    ///
    /// Sets up the subscriptions for this view.
    /// The view controller thus reacts to any changes in the datasource automatically.
    override func viewDidLoad() {
        
        // Subscribing to the file publisher.
        // On change of the current directory, reload the collection view.
        viewModel.file
            .sink { [weak self] file in
                self?.reloadCollectionView()
            }
            .store(in: &cancellables)
        
        // Subscribing to the error publisher.
        // On receipt of an error, show an alert explaining to the user.
        viewModel.error
            .compactMap { $0 }
            .sink { [weak self] error in
                self?.presentErrorAlert(error)
            }
            .store(in: &cancellables)
        
        // Subscribing to the sign-in state publisher.
        // On change of sign-in state, update the appearance of the sign-in button
        // and the enabled state of the add item button.
        // This change should be applied to every view controller currently on the navigation stack.
        viewModel.isSignedIn
            .sink { [weak self] isSignedIn in
                if let viewControllers = self?.navigationController?.viewControllers {
                    for controller in viewControllers {
                        if let vc = controller as? FileTreeViewController {
                            vc.updateUIForSignInState(isSignedIn)
                        }
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    /// Checks for the correct sign-in state when the view appears to maintain consistency across viewControllers.
    override func viewDidAppear(_ animated: Bool) {
        viewModel.validateSignInState()
    }
    
    // MARK: - UI Setup
    
    /// The navigation button to change the view's layout from grid to list and vice versa.
    private lazy var switchLayoutButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: buttonIcon), for: .normal)
        button.frame = .init(x: 0, y: 0, width: 40, height: 40)
        button.accessibilityLabel = "Switch layout from grid to list"
        button.addTarget(self, action: #selector(changeLayoutForAllViewControllers), for: .touchUpInside)
        button.accessibilityIdentifier = "toggle-list-button"
        return button
    }()
    
    /// The button to add an item or folder.
    /// Enabled or disabled based on user's sign-in state.
    private lazy var addItemButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.frame = .init(x: 0, y: 0, width: 40, height: 40)
        button.accessibilityLabel = "Add a file or folder"
        button.addTarget(self, action: #selector(presentAddItemOptions), for: .touchUpInside)
        button.isEnabled = viewModel.isSignedIn.value
        button.accessibilityIdentifier = "add-item-button"
        return button
    }()
    
    /// The button for signing in or out
    private lazy var signInButton: UIButton = {
        let button = UIButton()
        let name = viewModel.isSignedIn.value ? "person.crop.circle.badge.checkmark.fill" : "person.crop.circle.badge.exclamationmark.fill"
        let config = UIImage.SymbolConfiguration(paletteColors: viewModel.isSignedIn.value ? [.systemGreen, .tintColor] : [.systemRed, .tintColor])
        let buttonImage = UIImage(systemName: name)?.applyingSymbolConfiguration(config)
        button.setImage(buttonImage, for: .normal)
        button.frame = .init(x: 0, y: 0, width: 40, height: 40)
        button.accessibilityLabel = "Add a file or folder"
        button.addTarget(self, action: #selector(presentSignInWithGooglePrompt), for: .touchUpInside)
        button.accessibilityIdentifier = "sign-in-button"
        return button
    }()
    
    /// The image name for the layout toggle button.
    /// Should change to show list or grid when appropriate.
    private var buttonIcon: String {
        switch FileExplorerLayout.layoutType {
        case .list:
            return "square.grid.2x2"
        case .grid:
            return "list.bullet"
        }
    }
    
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
    
    
    /// Sets up the navigation buttons in the view controller.
    func setUpNavigationButtons() {
        let layoutButton = UIBarButtonItem(customView: switchLayoutButton)
        let addButton = UIBarButtonItem(customView: addItemButton)
        let signInButton = UIBarButtonItem(customView: signInButton)
        navigationController?.navigationItem.rightBarButtonItems = [signInButton, layoutButton, addButton]
        navigationItem.rightBarButtonItems = navigationController?.navigationItem.rightBarButtonItems
    }
    
    /// Reloads the collection view maintaining scroll offset.
    func reloadCollectionView() {
        let contentOffset = collectionView.contentOffset
        collectionView.reloadData()
        collectionView.setContentOffset(contentOffset, animated: false)
    }
}

// MARK: - UICollectionViewDelegate conformance

extension FileTreeViewController {
    
    /// Navigates to the children files view controller.
    /// - Parameter file: The file whose children to show.
    private func showChildrenFilesViewController(_ file: FileItem) {
        let viewController = FileTreeViewController(file: file)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let file = viewModel.file.value.children?[indexPath.item] {
            showChildrenFilesViewController(file)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let context = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] (action) -> UIMenu? in
            let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), identifier: nil, discoverabilityTitle: nil,attributes: .destructive, state: .off) {  _ in
                self?.viewModel.delete(at: indexPath.item)
            }
            return UIMenu(title: "", image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: [delete])
        }
        return context
    }
}

// MARK: - Error handling

extension FileTreeViewController {
    
    /// Presents an alert for the user in case of an error.
    /// - Parameter error: The error containing the details to show the user.
    func presentErrorAlert(_ error: ErrorAlert) {
        let alert = UIAlertController(title: error.title, message: error.message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
    }
}
    
// MARK: - Signing in and out

extension FileTreeViewController {
    /// Presents the alert to confirm that the user would like to sign in or out of their account.
    @objc func presentSignInWithGooglePrompt() {
        let title = viewModel.isSignedIn.value ? "Sign out?" : "Sign in to your Google account?"
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard let self = self else { return }
            if self.viewModel.isSignedIn.value {
                self.viewModel.signOut()
            } else {
                self.viewModel.signIn(presenting: self)
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
}

// MARK: - Layout change

extension FileTreeViewController {
    
    /// Changes the layout of the current view controller
    func changeLayout() {
        let layout = FileExplorerLayout()
        reloadCollectionView()
        updateUIForLayoutChange()
        self.collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    /// Changes the layout for all FileTree view controllers currently on the navigation stack
    @objc func changeLayoutForAllViewControllers() {
        FileExplorerLayout.toggle()
        changeLayout()
        if let viewControllers = navigationController?.viewControllers {
            for controller in viewControllers {
                if let vc = controller as? FileTreeViewController {
                    vc.changeLayout()
                }
            }
        }
    }
}
    
// MARK: - Adding items

extension FileTreeViewController {
    
    /// Presents an action sheet to choose between a file or folder when creating a new file.
    @objc func presentAddItemOptions() {
        let alert = UIAlertController(title: "New", message: nil, preferredStyle: .actionSheet)
        let file = UIAlertAction(title: "File", style: .default) { [weak self] _ in
            self?.presentAddItemDetailsAlert(.file)
        }
        let folder = UIAlertAction(title: "Folder", style: .default) { [weak self] _ in
            self?.presentAddItemDetailsAlert(.directory)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(file)
        alert.addAction(folder)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    /// Presents an alert for the user to type in a file name when creating a new file/folder.
    /// - Parameter fileType: The type of file being created ie file or folder.
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
                
                self.viewModel.addNewFileItem(filename, type: fileType)
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
}

// MARK: - UI state updates

extension FileTreeViewController {
    
    /// Updates the properties of UI elements associated with the user's sign-in state.
    /// - Parameter isSignedIn: The current state of the user's session.
    func updateUIForSignInState(_ isSignedIn: Bool) {
        let name = isSignedIn ? "person.crop.circle.badge.checkmark.fill" : "person.crop.circle.badge.exclamationmark.fill"
        let config = UIImage.SymbolConfiguration(paletteColors: isSignedIn ? [.systemGreen, .tintColor] : [.systemRed, .tintColor])
        let buttonImage = UIImage(systemName: name)?.applyingSymbolConfiguration(config)
        
        signInButton.setImage(buttonImage, for: .normal)
        addItemButton.isEnabled = isSignedIn
    }
    
    /// Updates the UI elements associated with the layout of the collection view.
    func updateUIForLayoutChange() {
        switchLayoutButton.setImage(UIImage(systemName: buttonIcon), for: .normal)
        switchLayoutButton.accessibilityLabel = "Switch layout from " + (FileExplorerLayout.layoutType == .grid ? "grid to list" : "list to grid")
        switchLayoutButton.accessibilityIdentifier = "toggle-" + (FileExplorerLayout.layoutType == .grid ? "list" : "grid") + "-button"
    }
}

