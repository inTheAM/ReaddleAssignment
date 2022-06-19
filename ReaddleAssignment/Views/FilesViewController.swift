//
//  FilesViewController.swift
//  ReaddleAssignment
//
//  Created by Ahmed Mgua on 06/06/2022.
//

import UIKit

final class FilesViewController: FileTreeViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.restorePreviousSessionIfExists()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.fetchSpreadsheet()
        
    }
}


