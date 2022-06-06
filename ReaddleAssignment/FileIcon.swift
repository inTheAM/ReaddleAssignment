//
//  FileIcon.swift
//  ReaddleAssignment
//
//  Created by Ahmed Mgua on 06/06/2022.
//

import UIKit

/// A custom collection view cell to display files/folders
final class FileIcon: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.systemBackground
        self.layer.cornerRadius = 16
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = .zero
        layer.shadowRadius = 5
    }
    
    /// The padding around the image in the icon
    private let imageInsets = UIEdgeInsets(top: -8, left: -8, bottom: -8, right: -8)
    
    /// The image view for the icon.
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    /// The file-name label
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .label
        label.text = "slnadl ksndladlknaskldnsal.pdf"
        label.allowsDefaultTighteningForTruncation = true
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingMiddle
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// The UIView containing the label.
    /// Used to create padding around the text.
    let labelView: UIView = {
        return UIView()
    }()
    
    
    /// Configures the layout of the cell contents.
    /// - Parameters:
    ///   - axis: The axis to set for the stack view in the view.
    ///   - image: The system image name to display as an icon.
    func configure(axis: NSLayoutConstraint.Axis, image: String) {
        // Creating the stack view
        let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = axis
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.layer.backgroundColor = UIColor.white.withAlphaComponent(0.2).cgColor
            return stackView
        }()
        
        // Setting the image on the image view and adding padding
        imageView.image = UIImage(systemName: image)?.withAlignmentRectInsets(imageInsets)
        
        // Adding the label to the label container view
        labelView.addSubview(nameLabel)
        
        // Adding the stack view to the main view
        addSubview(stackView)
        
        // Adding the image and label to the stack view in order
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(labelView)
        
        // Setting content shape
        stackView.layer.cornerRadius = 16
        stackView.layer.masksToBounds = true
        
        // Constraining the stack view within the view.
        // Stack view fills available space.
        stackView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        stackView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        // Constraining the name label within the label container view
        nameLabel.centerXAnchor.constraint(equalTo: labelView.layoutMarginsGuide.centerXAnchor).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: labelView.layoutMarginsGuide.bottomAnchor).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: labelView.layoutMarginsGuide.widthAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: labelView.layoutMarginsGuide.heightAnchor).isActive = true
        
        // Setting the label text alignment based on stack view axis
        // Constraining the image view size within the stack view based on the axis.
        switch axis {
        case .horizontal:
            nameLabel.textAlignment = .left
            imageView.widthAnchor.constraint(equalTo: labelView.heightAnchor).isActive = true
            imageView.centerYAnchor.constraint(equalTo: labelView.centerYAnchor).isActive = true
            
        default:
            nameLabel.textAlignment = .center
            imageView.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
            imageView.heightAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
            imageView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
