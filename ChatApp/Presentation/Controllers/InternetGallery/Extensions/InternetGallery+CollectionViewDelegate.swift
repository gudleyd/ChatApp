//
//  InternetGallery+CollectionViewDelegate.swift
//  ChatApp
//
//  Created by Иван Лебедев on 16/04/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import UIKit
import Foundation

extension InternetGalleryViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.gallery[indexPath.row].1 {
            self.dismiss(animated: true, completion: {
                self.model.PBPictureHasChosen(pbimage: self.imagesList[indexPath.row])
            })
        }
    }
}
