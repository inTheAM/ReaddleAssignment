//
//  FilesViewController.swift
//  ReaddleAssignment
//
//  Created by Ahmed Mgua on 06/06/2022.
//

import UIKit

final class FilesViewController: FileTreeViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.fetchSpreadsheet { [weak collectionView] in
            collectionView?.reloadData()
        }
    }
}


