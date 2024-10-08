//
//  BrandView.swift
//  ZAMAShop
//
//  Created by zyad Baset on 02/09/2024.
//

import UIKit
import SDWebImage
class BrandView: UIViewController {
  
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var discountCollectionView: UICollectionView!
    @IBOutlet weak var homeCollectionView: UICollectionView!
    @IBOutlet weak var brandsButton: UILabel!
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    let viewModel = BrandsViewModel()
    var scrollTimer:Timer?
    var count:Int=0
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.setupActivityIndicator(in: view)
        activityIndicator.showActivityIndicator()
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        discountCollectionView.delegate = self
        discountCollectionView.dataSource = self
        setupFlowLayout()
        setupFlowLayout1()
        viewModel.getData()
        viewModel.getBrands()
        viewModel.ReloadCV={
            self.discountCollectionView.reloadData()
            self.homeCollectionView.reloadData()
            self.brandsButton.isHidden = false
            self.activityIndicator.hideActivityIndicator()
        }
        
        let nib = UINib(nibName: "BrandCollectionViewCell", bundle: nil)
        homeCollectionView.register(nib, forCellWithReuseIdentifier: "cell")
        let nib2 = UINib(nibName: "DiscountCell", bundle: nil)
        discountCollectionView.register(nib2, forCellWithReuseIdentifier: "DiscountCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavbar()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(discountSlider), userInfo: nil, repeats: true)
    }
    
    
    
    
    func setupNavbar(){
        let cartButton = UIBarButtonItem.cartButton(target: self)
        let heartButton = UIBarButtonItem.heartButton(target: self)
        let searchButton = UIBarButtonItem.searchButton(target: self)
        self.tabBarController?.navigationItem.rightBarButtonItems = [heartButton, cartButton]
        self.tabBarController?.navigationItem.leftBarButtonItem = searchButton
        self.tabBarController?.title="Home"
        self.tabBarController?.navigationItem.searchController = nil
    }
    func checkCount(){
        if(count>=discountCollectionView.numberOfItems(inSection: 0)){
            count = 0
        }
    }
    @objc
    func discountSlider(){
        checkCount()
        discountCollectionView.scrollToItem(at: IndexPath(item: count, section: 0), at: .centeredHorizontally, animated: true)
        pageControl.currentPage = count
        count+=1
    }
}


extension BrandView : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == discountCollectionView){
            pageControl.numberOfPages = viewModel.PriceRuleArray.count
            return viewModel.PriceRuleArray.count
        }
        return viewModel.brandsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if(collectionView == discountCollectionView){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiscountCell", for: indexPath) as! DiscountCell
            cell.setupCell(index: indexPath.row)
            cell.layer.cornerRadius = 20
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! BrandCollectionViewCell
        //let placeHolder = UIImage(systemName: "heart.fill")
        cell.brandImage.sd_setImage(with: URL(string: viewModel.brandsArray[indexPath.row].image?.src ?? ""))
        cell.brandName.text = viewModel.brandsArray[indexPath.row].title
        cell.layer.cornerRadius = 20
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if(collectionView == discountCollectionView){
            return UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        }
        return UIEdgeInsets(top: 5, left: 10, bottom: 10, right: 10)
    }
    func setupFlowLayout(){
        let flowLayout = UICollectionViewFlowLayout()
        let itemWidth = (view.bounds.width - 30) / 2
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        homeCollectionView.collectionViewLayout = flowLayout
        
    }
    func setupFlowLayout1(){
        let flowLayout = UICollectionViewFlowLayout()
        //let itemWidth = (view.bounds.width - 30) / 2
        flowLayout.itemSize = CGSize(width: view.bounds.width-20, height: view.bounds.height*0.258616)
        flowLayout.scrollDirection = .horizontal
        discountCollectionView.collectionViewLayout = flowLayout
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(collectionView == discountCollectionView){
            
            let cell = collectionView.cellForItem(at: indexPath) as! DiscountCell
            cell.showLbl()
            let pasteboard = UIPasteboard.general
            pasteboard.string = viewModel.PriceRuleArray[indexPath.row].title
        } else {
            let vc = tabBarController?.viewControllers![1] as! CategoriesViewController
            vc.viewModel.isBrand = true
            vc.viewModel.BrandOfDataString = viewModel.brandsArray[indexPath.row].title ?? ""
            vc.tabBarController?.navigationItem.title = vc.viewModel.BrandOfDataString
            //vc.setupSearchNavBar()
            self.tabBarController!.selectedIndex = 1
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if(collectionView == discountCollectionView){
            pageControl.currentPage = indexPath.item
        }
    }
    
    
}



