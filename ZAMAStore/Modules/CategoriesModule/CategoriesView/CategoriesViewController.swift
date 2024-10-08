//
//  CategoriesView.swift
//  ZAMAShop
//
//  Created by zyad Baset on 02/09/2024.
//

import UIKit

class CategoriesViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UISearchResultsUpdating {
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
                // Reset to all products if search text is empty
            self.viewModel.isSearching = false
            self.viewModel.searchingText = ""
            self.viewModel.filterData(type: segmentType.titleForSegment(at: segmentType.selectedSegmentIndex)!, tag: segmentGender.titleForSegment(at: segmentGender.selectedSegmentIndex)!) // Assuming you have all products stored
                return
            }
            self.viewModel.isSearching = true
           self.viewModel.searchingText = searchText
            self.viewModel.filterData(type: segmentType.titleForSegment(at: segmentType.selectedSegmentIndex)!, tag: segmentGender.titleForSegment(at: segmentGender.selectedSegmentIndex)!)
    }
    
     
    
    let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    
    @IBOutlet weak var segmentType: UISegmentedControl!
    @IBOutlet weak var segmentGender: UISegmentedControl!
    var viewModel = CategoriesViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.setupActivityIndicator(in: view)
        
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
        setupFlowLayout()
        let nib = UINib(nibName: "ProductItem", bundle: nil)
        categoriesCollectionView.register(nib, forCellWithReuseIdentifier: "ProductItem")
    }
    
    @IBAction func tagSegmentAct(_ sender: UISegmentedControl) {
        viewModel.filterData(type: segmentType.titleForSegment(at: segmentType.selectedSegmentIndex)!, tag: segmentGender.titleForSegment(at: segmentGender.selectedSegmentIndex)!)

    }
    override func viewWillAppear(_ animated: Bool) {
        self.activityIndicator.showActivityIndicator()
        self.tabBarController?.title="Products"
        if viewModel.isBrand {
            viewModel.getData(param: ["vendor":viewModel.BrandOfDataString])
            self.tabBarController?.title=viewModel.BrandOfDataString
        }else {
            viewModel.getData()
            self.tabBarController?.title="Products"
        }
        searchController.searchBar.text = ""
        viewModel.searchingText = ""
        segmentType.selectedSegmentIndex = 3
        segmentGender.selectedSegmentIndex = 3
        viewModel.ReloadCV={
            self.categoriesCollectionView.reloadData()
            self.activityIndicator.hideActivityIndicator()
            self.categoriesCollectionView.isHidden = false
        }
    }
    
    func setupSearchNavBar(){
        self.tabBarController?.navigationItem.leftBarButtonItems = []
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search items"
        self.tabBarController?.navigationItem.searchController = searchController
        self.tabBarController?.navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
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
        cell.vc = self
        cell.layer.cornerRadius = 20
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productDetailsVC = UIStoryboard(name: "Main3", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailsView") as! ProductDetailsView
        productDetailsVC.viewModel.product = viewModel.products[indexPath.item]
        self.navigationController?.pushViewController(productDetailsVC, animated: true)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.viewModel.isSearching = false
        self.viewModel.isBrand = false
        self.categoriesCollectionView.isHidden = true
        print("disappear")
    }
}
