//
//  InternetGalleryViewController.swift
//  ChatApp
//
//  Created by Иван Лебедев on 15/04/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import UIKit
import Foundation

class InternetGalleryViewController: UIViewController {
    
    var gallery: [(UIImage, Bool)] = []
    var model: IInternetGalleryModel!
    var position: Int = 0
    var imagesList: [PBImage] = []
    
    let columnLayout = ColumnFlowLayout(
        cellsPerRow: 3,
        minimumInteritemSpacing: 10,
        minimumLineSpacing: 10,
        sectionInset: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    )
    
    func setDependencies(model: IInternetGalleryModel) {
        self.model = model
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.collectionViewLayout = columnLayout
        gallery = [(UIImage, Bool)].init(repeating: (UIImage(named: "placeholder-image") ?? UIImage(), false), count: self.model.takeImagesCount())
        self.collectionView.reloadData()
        self.loadImages()
    }
    
    func loadImages() {
        self.model.loadImages(batch: 5, batchHandler: { [weak self] (imageBatch, list: [PBImage]?) in
            DispatchQueue.main.async {
                if (self?.imagesList ?? []).count == 0 {
                    if let nnlist = list {
                        self?.imagesList = nnlist
                    }
                }
                var indexPaths: [IndexPath] = []
                for image in imageBatch {
                    if let pos = self?.position {
                        self?.gallery[pos] = (image, true)
                        indexPaths.append(IndexPath(row: pos, section: 0))
                    }
                    self?.position += 1
                }
                self?.collectionView.reloadItems(at: indexPaths)
            }
        })
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
