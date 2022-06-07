//
//  ViewModel.swift
//  ReaddleAssignment
//
//  Created by Ahmed Mgua on 06/06/2022.
//

import UIKit

extension ViewController {
    final class ViewModel: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            12
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "icon", for: indexPath) as! FileIcon
            
            switch FileExplorerLayout.layoutType {
            case .grid:
                cell.configure(axis: .vertical, image: "doc.text")
            default:
                cell.configure(axis: .horizontal, image: "folder")
            }
            
            return cell
        }
    }
}
