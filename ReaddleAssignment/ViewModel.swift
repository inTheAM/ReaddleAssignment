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
            if CommandLine.arguments.contains("MockData") {
                // Return mock data
                return 1
            } else {
                // Return actual data
                return 0
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "icon", for: indexPath) as! FileIcon
            
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
                switch FileExplorerLayout.layoutType {
                case .grid:
                    cell.configure(axis: .vertical, image: "doc.text", name: "file asdnskandoa.pdf")
                default:
                    cell.configure(axis: .horizontal, image: "folder", name: "folder sldfndkfnodf")
                }
            }
            
            
            return cell
        }
    }
}
