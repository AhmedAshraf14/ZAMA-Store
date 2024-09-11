//
//  ReviewsView.swift
//  ZAMAStore
//
//  Created by Ahmed Ashraf on 11/09/2024.
//

import UIKit

class ReviewsView: UIViewController {
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    
    @IBOutlet var starImageViews: [UIImageView]!

    @IBOutlet weak var reviewsTable: UITableView!
    var viewModel : ReviewsViewModel!
    
    required init?(coder: NSCoder) {
        self.viewModel = ReviewsViewModel()
        super.init(coder: coder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        setupUI()
    }
    func setupTable(){
        let nib = UINib(nibName: "ReviewTableViewCell", bundle: nil)
        reviewsTable.register(nib, forCellReuseIdentifier: "ReviewTableViewCell")
        reviewsTable.delegate = self
        reviewsTable.dataSource = self
        viewModel.filterRates()
    }
    func setupUI(){
        productNameLabel.text = viewModel.productName
        rateLabel.text = "\(viewModel.overallRating).0"
        updateStarImages()
    }
    
    
    func updateStarImages() {
        for (index, imageView) in starImageViews.enumerated() {
            if index < viewModel.overallRating {
                imageView.image = UIImage(systemName: "star.fill")
            } else {
                imageView.image = UIImage(systemName: "star")
            }
        }
    }

}

extension ReviewsView : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfReviews()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell", for: indexPath) as! ReviewTableViewCell
        cell.setupCell(review: viewModel.reviews[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    
}
