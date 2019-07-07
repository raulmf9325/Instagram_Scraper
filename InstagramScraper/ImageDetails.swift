//
//  ImageDetails.swift
//  InstagramScraper
//
//  Created by Raul Mena on 7/6/19.
//  Copyright © 2019 Raul Mena. All rights reserved.
//

import UIKit

class ImageDetails: UIViewController{
    
    var url: URL?{
        didSet{
            imageView.sd_setImage(with: url) { (image, error, cache, url) in }
        }
    }
    
    override func viewDidLoad() {
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1).isActive = true
    }
    
    let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "picture"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
}
