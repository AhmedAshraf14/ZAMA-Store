//
//  ProductDetailsView.swift
//  ZAMAShop
//
//  Created by zyad Baset on 02/09/2024.
//

import UIKit

class ProductDetailsView: UIViewController {
    var viewModel : ProductDetailsViewModel!
    
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    private var currentIndex = 0
    private var timer: Timer?
    
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var sizeButton: UIButton!
    @IBOutlet weak var colorButton: UIButton!
    
    
    required init?(coder: NSCoder) {
        self.viewModel = ProductDetailsViewModel()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.productIsFav()
        setupImageSlider()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if viewModel.isFav{
            favButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }else {
            favButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    func setupImageSlider(){
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        let nib = UINib(nibName: "ImageCollectionViewCell", bundle: nil)
        imagesCollectionView.register(nib, forCellWithReuseIdentifier: "ImageCollectionViewCell")
        
        if let layout = imagesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: imagesCollectionView.frame.width, height: imagesCollectionView.frame.height)
        }
        pageControl.numberOfPages = viewModel.product.images!.count
        pageControl.addTarget(self, action: #selector(pageControlChanged(_:)), for: .valueChanged)

    }
    
    @objc func pageControlChanged(_ sender: UIPageControl) {
        let indexPath = IndexPath(item: sender.currentPage, section: 0)
        imagesCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func setupUI(){
        productTitleLabel.text = viewModel.product.title
        productPriceLabel.text = "\(viewModel.product.variants[0].price) EGP"
        descriptionTextView.text = viewModel.product.bodyHTML
    }
    
    @IBAction func optionsButtonPressed(_ sender: UIButton) {
        switch sender.tag{
        case 0:
            showOptions(alertTitle: "Select Size", optionIndex: 0)
        default:
            showOptions(alertTitle: "Select Color", optionIndex: 1)
        }
        
    }
    
    @IBAction func addToCartButtonPressed(_ sender: UIButton) {
        if sizeButton.titleLabel?.text == "Size" || colorButton.titleLabel?.text == "Color" {
            self.presentAlert(title: "Error", message: "Choose Size and Color", buttonTitle: "OK")
        }else{
            if MyAccount.shared.currentUser.note==nil{
                viewModel?.postToDraftOrder(isCart: true)
            }
                else{
                    viewModel?.putToDraftOrder(isCart: true)
                }
        }
    }
    
    @IBAction func reviewsButtonPressed(_ sender: UIButton) {
        let reviewsVC = storyboard?.instantiateViewController(withIdentifier: "ReviewsView") as! ReviewsView
        reviewsVC.viewModel.productName = viewModel.product.title
        self.present(reviewsVC, animated: true)
    }
    
    @IBAction func favButtonPressed(_ sender: UIButton) {
        if viewModel.isFav{
            viewModel.isFav.toggle()
            sender.setImage(UIImage(systemName: "heart"), for: .normal)
            viewModel.deleteFavDraftOrder()
        }else{
            if viewModel.user?.tags == ""{
                viewModel.postToDraftOrder(isCart: false)
            }else{
                viewModel.putToDraftOrder(isCart: false)
            }
            viewModel.isFav.toggle()
            sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
    }
    
    
    private func showOptions(alertTitle: String, optionIndex: Int) {
        let alert = UIAlertController(title: alertTitle, message: nil, preferredStyle: .actionSheet)
        
        for size in viewModel.product.options[optionIndex].values {
            let action = UIAlertAction(title: size, style: .default) { _ in
                switch alertTitle {
                case "Select Size":
                    self.sizeButton.setTitle(size, for: .normal)
                default:
                    self.colorButton.setTitle(size, for: .normal)
                }
                
            }
            action.setValue(UIColor.mintGreen, forKey: "titleTextColor")
            alert.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)

        self.present(alert, animated: true, completion: nil)
    }
    
}
extension ProductDetailsView : UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfProductImages()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        cell.setupCell(imageUrl: viewModel.product.images![indexPath.item].src)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControl.currentPage = indexPath.item
    }
    
}
