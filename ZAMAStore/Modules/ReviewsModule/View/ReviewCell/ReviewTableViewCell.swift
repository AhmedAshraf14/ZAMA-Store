//
//  ReviewTableViewCell.swift
//  ZAMAStore
//
//  Created by Ahmed Ashraf on 11/09/2024.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var reviewerNameLabel: UILabel!
    @IBOutlet var starImageViews: [UIImageView]!
    @IBOutlet weak var reviewerOpinionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.mintGreen.cgColor
        avatarImageView.layer.cornerRadius = 12
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(review: Review){
        reviewerNameLabel.text = review.name
        reviewerOpinionLabel.text = review.opinion
        avatarImageView.image = UIImage(named: review.image)
        updateStarImages(rating: review.rate)
    }
    
    private func updateStarImages(rating : Int) {
        for (index, imageView) in starImageViews.enumerated() {
            if index < rating {
                imageView.image = UIImage(systemName: "star.fill")
            } else {
                imageView.image = UIImage(systemName: "star")
            }
        }
    }
    
}
