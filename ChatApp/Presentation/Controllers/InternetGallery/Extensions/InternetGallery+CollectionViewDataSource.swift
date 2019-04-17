//
//  InternetGallery+CollectionViewDataSource.swift
//  ChatApp
//
//  Created by Иван Лебедев on 16/04/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import UIKit
import Foundation

extension InternetGalleryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gallery.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? ImageCell else {
            fatalError("Can't cast imageCell to ImageCell class")
        }
        cell.configure(image: self.gallery[indexPath.row].0)
        return cell
    }
    
}
