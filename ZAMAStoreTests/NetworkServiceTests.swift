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
                XCTAssertNil(data, "Data should be nil")
                expectation.fulfill()
            }
            
            waitForExpectations(timeout: 5, handler: nil)
        }
        
        // MARK: - Test getData
        
        func testGetDataSuccess() {
            let expectation = self.expectation(description: "Data fetched successfully")
            
            // Mock the expected response
            let mockParams: Alamofire.Parameters = [:]
            networkService.getData(path: "products", parameters: mockParams, model: ProductModel.self) { result, error in
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
        
        func testPostDataSuccess() {
            let expectation = self.expectation(description: "Data posted successfully")
            
            // Mock the expected response
            let mockParams: Alamofire.Parameters = ["title": "Test Product"]
            networkService.postData(path: "products", parameters: mockParams, postFlag: true) { result, error in
                XCTAssertNil(error, "Error should be nil")
                XCTAssertNotNil(result, "Result should not be nil")
                expectation.fulfill()
            }
            
            waitForExpectations(timeout: 5, handler: nil)
        }
        
        func testPostDataFailure() {
            let expectation = self.expectation(description: "Posting data failed")
            
            // Mock the response with failure
            let mockParams: Alamofire.Parameters = ["title": "Test Product"]
            networkService.postData(path: "invalid_path", parameters: mockParams, postFlag: true) { result, error in
                XCTAssertNotNil(error, "Error should not be nil")
                XCTAssertNil(result, "Result should be nil")
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
        
        func testDeleteDataFailure() {
            let expectation = self.expectation(description: "Deleting data failed")
            
            networkService.deleteData(path: "invalid_path") {
                XCTFail("This should not be called")
            }
            
            waitForExpectations(timeout: 5, handler: nil)
        }

}
