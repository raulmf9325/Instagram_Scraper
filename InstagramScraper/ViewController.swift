//
//  ViewController.swift
//  InstagramScraper
//
//  Created by Raul Mena on 7/6/19.
//  Copyright © 2019 Raul Mena. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController{
    
    // images URLs
    var imagesURLs = [URL]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        collectionView.register(Cell.self, forCellWithReuseIdentifier: "CellId")
    }
    

    override func viewDidAppear(_ animated: Bool) {
        let alert = UIAlertController(title: "Please provide Instagram username (must be public account)", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Instagram account name"
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
            if let name = alert.textFields?.first?.text {
                self.fetchURL(username: name)
            }
        }))
        
        self.present(alert, animated: true)
    }
    
    private func fetchURL(username: String){
        let urlString = "https://www.instagram.com/\(username)/"
        guard let url = URL(string: urlString) else {return}
        var html = ""
        do{
            html = try String(contentsOf: url)
        }
        catch let error{
            print(error.localizedDescription)
        }
        
        // let regex = "window._sharedData = (.*);</script>"
        
        if let jsonString = html.slice(from: "window._sharedData = ", to: ";</script>"){
            //print(jsonString)
            
            let data = Data(jsonString.utf8)
            do {
                // make sure this JSON is in the format we expect
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    // try to read out a string array
                    if let entry = json["entry_data"] as? [String: Any] {
                        if let profile = entry["ProfilePage"] as? [[String: Any]]{
                            if let graphql = profile[0]["graphql"] as? [String: Any]{
                                if let user = graphql["user"] as? [String: Any]{
                                    if let owner = user["edge_owner_to_timeline_media"] as? [String: Any]{
                                        if let edges = owner["edges"] as? [[String: Any]]{
                                            edges.forEach { (edge) in
                                                if let node = edge["node"] as? [String: Any]{
                                                    let image = node["display_url"] as! String
                                                    if let url = URL(string: image){
                                                        self.imagesURLs.append(url)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                collectionView.reloadData()
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }
    }

}

extension ViewController: UICollectionViewDelegateFlowLayout{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesURLs.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellId", for: indexPath) as! Cell
        cell.imageView.image = UIImage(named: "picture")
        cell.url = self.imagesURLs[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width - (40)) / 2, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 60, left: 10, bottom: 0, right: 10)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageDetails = ImageDetails()
        imageDetails.url = imagesURLs[indexPath.item]
        navigationController?.pushViewController(imageDetails, animated: true)
    }
}

extension String {
    
    func slice(from: String, to: String) -> String? {
        
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}
