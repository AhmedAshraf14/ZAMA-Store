//
//  ReviewsViewModel.swift
//  ZAMAStore
//
//  Created by Ahmed Ashraf on 11/09/2024.
//

import Foundation

class ReviewsViewModel{
    
    var reviews: [Review] = [
        Review(name: "Youssef Hassan", rate: 5, opinion: "Exceeded my expectations! The product quality is amazing, and it arrived earlier than expected. Definitely recommend!", image: "user"),
        Review(name: "Mohamed Ali", rate: 4, opinion: "Good product overall, but the packaging was slightly damaged. The product itself works great.", image: "user"),
        Review(name: "Mona Ahmed", rate: 3, opinion: "The product is decent, but I was expecting a bit more for the price. It's functional, but not as high-end as advertised.", image: "user"),
        Review(name: "Amr Salah", rate: 4, opinion: "Very satisfied with this purchase. The product performs well, though I wish there were more color options.", image: "user"),
        Review(name: "Aya Mostafa", rate: 2, opinion: "Unfortunately, the product wasn't as expected. The customer support team was helpful, though, and processed my return quickly.", image: "user"),
        Review(name: "Khaled Mahmoud", rate: 5, opinion: "Amazing product! The build quality is top-notch and it performs exactly as described. Will be purchasing again.", image: "user"),
        Review(name: "Nour El-Din", rate: 3, opinion: "The product is okay, but I've used better alternatives. It does the job, but there’s room for improvement.", image: "user"),
        Review(name: "Salma Ibrahim", rate: 1, opinion: "Very disappointed. The product stopped working after a week. I would not recommend this to anyone.", image: "user")
    ]

    var productName : String!
    
    var overallRating : Int = Int.random(in: 1...5)
    
    func filterRates(){
        for index in reviews.indices {
            reviews[index].rate = (reviews[index].rate > overallRating) ? Int.random(in: 1...overallRating) : reviews[index].rate
        }
    }
    
    func numberOfReviews()->Int{
        return reviews.count
    }
    
}


