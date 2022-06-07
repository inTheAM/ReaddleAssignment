//
//  FileExplorerLayout.swift
//  ReaddleAssignment
//
//  Created by Ahmed Mgua on 06/06/2022.
//

import UIKit

final class FileExplorerLayout: UICollectionViewFlowLayout {
    /// The type of layout in the collection view.
    enum LayoutType {
        
        /// Displays items in a one-column collection view.
        case list
        
        /// Displays items in a three-column collection view.
        case grid
    }
    
    /// Determines the layout of collection view cells.
    static var layoutType = LayoutType.grid
    
    /// The delegate of the layout class.
    weak var delegate: UICollectionViewDelegate?
    
    /// The inset around the content in the collection view cells.
    private let cellPadding: CGFloat = 8
    
    /// Cache for layout attributes.
    private var attributes: [UICollectionViewLayoutAttributes] = []
    
    /// The height of the content in the collection view using this layout.
    private var contentHeight: CGFloat!
    
    /// The width of the content in the collection view using this layout.
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    /// The content size of the collection view using this layout.
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    /// Creates the layout of collection view cells based on layout type and content size.
    override func prepare() {
        guard attributes.isEmpty,
              let collectionView = collectionView
        else { return }
        
        let numberOfColumns: Int = Self.layoutType == .grid ? 3 : 1
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        
        #warning("columnHeight in grid mode below this value breaks scrolling if collection view is showing few items")
        let gridColumnHeight = columnWidth+48
        let columnHeight: CGFloat = Self.layoutType == .grid ? gridColumnHeight : 60
        
        
        var xOffsets: [CGFloat] = []
        for column in 0..<numberOfColumns {
            xOffsets.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var yOffsets: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        
        // Calculating offset for each item in the collection view.
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            // Getting the frame
            let frame = CGRect(x: xOffsets[column],
                               y: yOffsets[column],
                               width: columnWidth,
                               height: columnHeight)
            
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            // Caching attributes using calculated frame
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            self.attributes.append(attributes)
            
            // Setting vertical offset for each row and content height for the collection view
            contentHeight = frame.maxY
            yOffsets[column] = yOffsets[column] + columnHeight
            
            // Updating current column
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attributes[indexPath.item]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributes.filter { $0.frame.intersects(rect) }
    }
}
