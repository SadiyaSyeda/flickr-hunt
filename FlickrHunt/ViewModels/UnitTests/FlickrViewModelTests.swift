//
//  FlickrViewModelTests.swift
//  FlickrHuntTests
//
//  Created by Sadiya Syeda on 9/26/24.
//

import XCTest
@testable import FlickrHunt

@MainActor
final class FlickrViewModelTests: XCTestCase {
    var viewModel: FlickrViewModel!
    var mockNetworkClient: MockNetworkClient!
    
    override func setUp() {
        super.setUp()
        mockNetworkClient = MockNetworkClient()
        viewModel = FlickrViewModel(networkClient: mockNetworkClient)
    }
    
    func testInitialization() {
        XCTAssertTrue(viewModel.photos.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testFetchPublicPhotosSuccess() async {
        let mockResponse = FlickrResponse(items: [
            FlickrImage(id: "1", title: "Cat", description: "Cute cat", author: "Author1", published: "2024-01-01", media: FlickrImage.Media(m: "imageURL1")),
            FlickrImage(id: "2", title: "Dog", description: "Friendly dog", author: "Author2", published: "2024-01-02", media: FlickrImage.Media(m: "imageURL2"))
        ])
        
        mockNetworkClient.mockData = try! JSONEncoder().encode(mockResponse)
        mockNetworkClient.mockError = nil
        
        await viewModel.fetchPublicPhotos()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertEqual(viewModel.photos.count, 2)
        XCTAssertEqual(viewModel.photos[0].title, "Cat")
        XCTAssertEqual(viewModel.photos[1].title, "Dog")
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testFetchPublicPhotosFailure() async {
        mockNetworkClient.mockError = URLError(.notConnectedToInternet)
        
        await viewModel.fetchPublicPhotos()
        
        XCTAssertTrue(viewModel.photos.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testFetchPublicPhotosEmptyResponse() async {
        let mockResponse = FlickrResponse(items: [])
        
        mockNetworkClient.mockData = try! JSONEncoder().encode(mockResponse)
        mockNetworkClient.mockError = nil
        
        await viewModel.fetchPublicPhotos()
        
        XCTAssertTrue(viewModel.photos.isEmpty)
    }
    
    func testSearchPhotosSuccess() async {
        let mockResponse = FlickrResponse(items: [
            FlickrImage(id: "1", title: "Cat", description: "Cute cat", author: "Author1", published: "2024-01-01", media: FlickrImage.Media(m: "imageURL1")),
            FlickrImage(id: "2", title: "Dog", description: "Friendly dog", author: "Author2", published: "2024-01-02", media: FlickrImage.Media(m: "imageURL2"))
        ])
        
        mockNetworkClient.mockData = try! JSONEncoder().encode(mockResponse)
        mockNetworkClient.mockError = nil
        
        await viewModel.searchPhotos(for: "pets")
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertEqual(viewModel.photos.count, 2)
        XCTAssertEqual(viewModel.photos[0].title, "Cat")
        XCTAssertEqual(viewModel.photos[1].title, "Dog")
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testSearchPhotosEmptyResponse() async {
        let mockResponse = FlickrResponse(items: [])
        
        mockNetworkClient.mockData = try! JSONEncoder().encode(mockResponse)
        mockNetworkClient.mockError = nil
        
        await viewModel.searchPhotos(for: "unknown")
        
        XCTAssertTrue(viewModel.photos.isEmpty)
    }
    
    func testSearchPhotosNetworkError() async {
        mockNetworkClient.mockError = NSError(domain: "NetworkError", code: -1, userInfo: nil)
        
        await viewModel.searchPhotos(for: "flowers")
        
        XCTAssertTrue(viewModel.photos.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
    }
}
