//
//  Cell.swift
//  InstagramScraper
//
//  Created by Raul Mena on 7/6/19.
//  Copyright © 2019 Raul Mena. All rights reserved.
//

import UIKit
import SDWebImage

class Cell: UICollectionViewCell{
    
    var url: URL?{
        didSet{
            imageView.sd_setImage(with: url) { (image, error, cache, url) in
                
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(){
        layer.cornerRadius = 12
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        imageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1).isActive = true
    }
    
    let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "picture"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
}
