//
//  CategoriesView.swift
//  ZAMAShop
//
//  Created by zyad Baset on 02/09/2024.
//

import UIKit

class CategoriesViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    
    @IBOutlet weak var segmentType: UISegmentedControl!
    @IBOutlet weak var segmentGender: UISegmentedControl!
    var viewModel = CategoriesViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
        setupFlowLayout()
        let nib = UINib(nibName: "ProductItem", bundle: nil)
        categoriesCollectionView.register(nib, forCellWithReuseIdentifier: "ProductItem")
    }
    
    @IBAction func tagSegmentAct(_ sender: UISegmentedControl) {
        viewModel.filterData(type: segmentType.titleForSegment(at: segmentType.selectedSegmentIndex)!, tag: segmentGender.titleForSegment(at: segmentGender.selectedSegmentIndex)!)
        //print(sender.titleForSegment(at: sender.selectedSegmentIndex)!)
        print("///called///")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getData()
        segmentType.selectedSegmentIndex = 3
        segmentGender.selectedSegmentIndex = 3
        viewModel.ReloadCV={
            self.categoriesCollectionView.reloadData()
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.products.count
    }
    func setupFlowLayout(){
        let flowLayout = UICollectionViewFlowLayout()
        let itemWidth = (view.bounds.width - 20) / 2
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth+80)
        categoriesCollectionView.collectionViewLayout = flowLayout
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductItem", for: indexPath) as! ProductItem
        cell.viewModel = ProductCellViewModel(product: viewModel.products[indexPath.row])
        cell.putData()
        cell.layer.cornerRadius = 20
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productDetailsVC = UIStoryboard(name: "Main3", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailsView") as! ProductDetailsView
        //productDetailsVC.viewModel.productID = viewModel.products[indexPath.item].id
        productDetailsVC.viewModel.product = viewModel.products[indexPath.item]
        self.navigationController?.pushViewController(productDetailsVC, animated: true)
    }

}
