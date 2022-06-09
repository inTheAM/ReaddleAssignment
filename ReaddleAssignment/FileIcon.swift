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
        
        // Adding the label to the label container view
        labelView.addSubview(nameLabel)
        
        // Constraining the name label within the label container view
        nameLabel.centerXAnchor.constraint(equalTo: labelView.layoutMarginsGuide.centerXAnchor).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: labelView.layoutMarginsGuide.bottomAnchor).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: labelView.layoutMarginsGuide.widthAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: labelView.layoutMarginsGuide.heightAnchor).isActive = true
        
        // Constraining width and height of image
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        
        // Adding the image and label to the stack view in order
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(labelView)
        
        // Adding the stack view to the main view
        addSubview(stackView)
        isAccessibilityElement = true
        accessibilityLabel = nameLabel.text
        accessibilityIdentifier = "file-icon-vertical"
    }
    
    /// The padding around the image in the icon
    private let imageInsets = UIEdgeInsets(top: -8, left: -8, bottom: -8, right: -8)
    
    /// The image view for the icon.
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isAccessibilityElement = false
        imageView.accessibilityIdentifier = "file-image"
        return imageView
    }()
    
    /// The file-name label
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .label
        label.allowsDefaultTighteningForTruncation = true
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingMiddle
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isAccessibilityElement = false
        label.accessibilityIdentifier = "file-label"
        return label
    }()
    
    /// The UIView containing the label.
    /// Used to create padding around the text.
    private lazy var labelView: UIView = {
        return UIView()
    }()
    
    
    /// The stack view containing the cell contents
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.layer.backgroundColor = UIColor.white.withAlphaComponent(0.2).cgColor
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layer.cornerRadius = 16
        stackView.layer.masksToBounds = true
        stackView.distribution = .fill
        stackView.accessibilityIdentifier = "file-stackview"
        return stackView
    }()
    
    /// Configures the layout of the cell contents.
    /// - Parameters:
    ///   - axis: The axis to set for the stack view in the view.
    ///   - image: The system image name to display as an icon.
    func configure(axis: NSLayoutConstraint.Axis, image: String, name: String) {
        stackView.axis = axis
        
        // Setting the image on the image view and adding padding
        let configuration = UIImage.SymbolConfiguration(pointSize: 64, weight: .thin)
        let systemImage = UIImage(systemName: image, withConfiguration: configuration)!.withAlignmentRectInsets(imageInsets)
        imageView.image = systemImage
        // Setting the file name on the label
        nameLabel.text = name
        // Constraining the stack view within the view.
        stackView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        stackView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        // Setting the label text alignment based on stack view axis
        switch axis {
        case .horizontal:
            nameLabel.textAlignment = .left
            self.accessibilityIdentifier = "file-icon-horizontal"
        default:
            nameLabel.textAlignment = .center
            self.accessibilityIdentifier = "file-icon-vertical"
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
