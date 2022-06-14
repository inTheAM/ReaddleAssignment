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

}
