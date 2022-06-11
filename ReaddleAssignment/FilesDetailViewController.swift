//
//  FilesDetailViewController.swift
//  ReaddleAssignment
//
//  Created by Ahmed Mgua on 09/06/2022.
//

import UIKit

final class FilesDetailViewController: FileTreeViewController {
    var files: [FileItem]!
    weak var viewController: FileTreeViewController? = nil
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = false
        
        setUpCollectionView(dataSource: self)
        setUpNavigationButtons()
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return files.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "icon", for: indexPath) as! FileIcon
        let file = files[indexPath.item]
        if CommandLine.arguments.contains("MockData") {
            // Return mock data
            switch FileExplorerLayout.layoutType {
            case .grid:
                cell.configure(axis: .vertical, image: "doc.text", name: "file.pdf")
            default:
                cell.configure(axis: .horizontal, image: "folder", name: "folder")
            }
        } else {
            // Return actual data
            let image = file.fileType == "f" ? "doc.text" : "folder"
            switch FileExplorerLayout.layoutType {
            case .grid:
                cell.configure(axis: .vertical, image: image, name: file.name)
                print("CONFIGURED CELL VVVVVV")
            default:
                cell.configure(axis: .horizontal, image: image, name: file.name)
                print("CONFIGURED CELL HHHHHH")
            }
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let file = files[indexPath.item]
        showDetailViewController(file)
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
