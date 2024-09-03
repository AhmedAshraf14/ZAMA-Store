//
//  BrandView.swift
//  ZAMAShop
//
//  Created by zyad Baset on 02/09/2024.
//

import UIKit
import SDWebImage
class BrandView: UIViewController {
  
    @IBOutlet weak var discountCollectionView: UICollectionView!
    @IBOutlet weak var homeCollectionView: UICollectionView!
    let viewModel = BrandsViewModel()
    override func viewDidLoad() {
       
        super.viewDidLoad()
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        setupFlowLayout()
        let nib = UINib(nibName: "BrandCollectionViewCell", bundle: nil)
        homeCollectionView.register(nib, forCellWithReuseIdentifier: "cell")
    }
}


extension BrandView : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.brandsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! BrandCollectionViewCell
        cell.brandImage.image = UIImage(named: viewModel.brandsArray[indexPath.row].brandImage)
        cell.brandName.text = viewModel.brandsArray[indexPath.row].brandName
        cell.layer.cornerRadius = 20
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 10, bottom: 10, right: 10)
    }
    func setupFlowLayout(){
        let flowLayout = UICollectionViewFlowLayout()
        let itemWidth = (view.bounds.width - 30) / 2
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        homeCollectionView.collectionViewLayout = flowLayout
        
    }
    
    
}
