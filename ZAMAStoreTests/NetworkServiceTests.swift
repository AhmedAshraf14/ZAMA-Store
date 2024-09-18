//
//  NetworkServiceTests.swift
//  ZAMAStoreTests
//
//  Created by Ahmed Ashraf on 19/09/2024.
//
import XCTest
@testable import ZAMAStore
import Alamofire

final class NetworkServiceTests: XCTestCase {

    var networkService: NetworkService!
        
        override func setUp() {
            super.setUp()
            networkService = NetworkService()
        }
        
        override func tearDown() {
            networkService = nil
            super.tearDown()
        }
        
        // MARK: - Test getDraftOrders
        
        func testGetDraftOrdersSuccess() {
            let expectation = self.expectation(description: "Draft orders fetched successfully")
            
            // Mock the expected response
            let mockData = "{}".data(using: .utf8)
            let mockParams: Alamofire.Parameters = ["status": "draft"]
            
            networkService.getDraftOrders(path: "draft_orders", parameters: mockParams) { data, error in
                XCTAssertNil(error, "Error should be nil")
                XCTAssertNotNil(data, "Data should not be nil")
                expectation.fulfill()
            }
            
            waitForExpectations(timeout: 5, handler: nil)
        }
        
        func testGetDraftOrdersFailure() {
            let expectation = self.expectation(description: "Draft orders fetching failed")
            
            // Mock the response with failure
            let mockParams: Alamofire.Parameters = ["status": "draft"]
            
            networkService.getDraftOrders(path: "invalid_path", parameters: mockParams) { data, error in
                XCTAssertNotNil(error, "Error should not be nil")
                //XCTAssertNil(data, "Data should be nil")
                expectation.fulfill()
            }
            
            waitForExpectations(timeout: 5, handler: nil)
        }
        
        // MARK: - Test getData
        
        func testGetDataSuccess() {
            let expectation = self.expectation(description: "Data fetched successfully")
            
            // Mock the expected response
            let mockParams: Alamofire.Parameters = [:]
            networkService.getData(path: "products", parameters: mockParams, model: ProductResponse.self) { result, error in
                XCTAssertNil(error, "Error should be nil")
                XCTAssertNotNil(result, "Result should not be nil")
                expectation.fulfill()
            }
            
            waitForExpectations(timeout: 5, handler: nil)
        }
        
        func testGetDataFailure() {
            let expectation = self.expectation(description: "Fetching data failed")
            
            // Mock the response with failure
            let mockParams: Alamofire.Parameters = [:]
            networkService.getData(path: "invalid_path", parameters: mockParams, model: ProductModel.self) { result, error in
                XCTAssertNotNil(error, "Error should not be nil")
                XCTAssertNil(result, "Result should be nil")
                expectation.fulfill()
            }
            
            waitForExpectations(timeout: 5, handler: nil)
        }
        
        // MARK: - Test postData
        
    func testPostAddressSuccess() {
        let expectation = self.expectation(description: "Address posted successfully")
        
        // Mock the expected response (For real Shopify API, ensure you have a valid customer_id)
        let mockParams: Alamofire.Parameters = [
            "address": [
                "address1": "123 Test St",
                "city": "Test City",
                "province": "Test Province",
                "phone": "555-1234",
                "zip": "12345",
                "last_name": "Doe",
                "first_name": "John",
                "country": "United States"
            ]
        ]
        
        let customerId = "7341601554569"  // Replace with a real customer ID
        let path = "customers/\(customerId)/addresses"
        
        networkService.postData(path: path, parameters: mockParams, postFlag: true) { result, error in
            //XCTAssertNil(error, "Error should be nil")
            //XCTAssertNotNil(result, "Result should not be nil")
            
            // Optional: Assert on the result structure
            if let result = result as? [String: Any], let address = result["address"] as? [String: Any] {
                XCTAssertEqual(address["city"] as? String, "Test City", "City should be 'Test City'")
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)  // Increase timeout if needed
    }
    
    func testPutAddressSuccess() {
        let expectation = self.expectation(description: "Address updated successfully")
        
        // Mock parameters for updating the address
        let mockParams: Alamofire.Parameters = [
            "address": [
                "first_name": "John",
                "last_name": "Doe",
                "address1": "123 Elm Street",
                "city": "Springfield",
                "province": "IL",
                "country": "US",
                "zip": "62704"
            ]
        ]
        
        // Test the `PUT` request by setting postFlag to false for the address endpoint
        networkService.postData(path: "customers/7341601554569/addresses/8864686833801", parameters: mockParams, postFlag: false) { result, error in
            XCTAssertNil(error, "Error should be nil for a successful address PUT request")
            XCTAssertNotNil(result, "Result should not be nil for a successful address PUT request")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testPutAddressFailure() {
        let expectation = self.expectation(description: "Updating address failed")
        
        // Mock parameters for an invalid address update
        let mockParams: Alamofire.Parameters = [
            "address": [
                "first_name": "John",
                "last_name": "Doe",
                "address1": "123 Elm Street",
                "city": "Springfield",
                "province": "IL",
                "country": "US",
                "zip": "62704"
            ]
        ]
        
        // Test the `PUT` request by using an invalid path
        networkService.postData(path: "customers/invalid_customer/addresses/invalid_address", parameters: mockParams, postFlag: false) { result, error in
            XCTAssertNotNil(error, "Error should not be nil for a failed address PUT request")
            XCTAssertNil(result, "Result should be nil for a failed address PUT request")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }

        
        // MARK: - Test deleteData
        
        func testDeleteDataSuccess() {
            let expectation = self.expectation(description: "Data deleted successfully")
            
            networkService.deleteData(path: "orders/1234") {
                expectation.fulfill()
            }
            
            waitForExpectations(timeout: 5, handler: nil)
        }
        
//    func testDeleteDataFailure() {
//        let expectation = self.expectation(description: "Deleting data failed")
//        
//        // Use the modified deleteData function that can handle errors
//        networkService.deleteData(path: "invalid_path", successHandler: {
//            XCTFail("Success handler should not be called")
//        }, errorHandler: { error in
//            XCTAssertNotNil(error, "Error should not be nil")
//            expectation.fulfill()
//        })
//        
//        waitForExpectations(timeout: 5, handler: nil)
//    }

}
