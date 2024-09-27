//
//  NetworkClientTests.swift
//  FlickrHuntTests
//
//  Created by Sadiya Syeda on 9/26/24.
//

import XCTest
@testable import FlickrHunt

final class NetworkClientTests: XCTestCase {
    
    func testPerformRequestSuccess() async throws {
        let mockData = """
        {
            "items": [
                {
                    "id": "1",
                    "title": "Beautiful Sunset",
                    "description": "A breathtaking sunset over the mountains.",
                    "author": "John Doe",
                    "published": "2024-09-26T12:34:56Z",
                    "media": {
                        "m": "https://live.staticflickr.com/65535/54022629467_7de2bbefe6_m.jpg"
                    }
                },
                {
                    "id": "2",
                    "title": "City Lights",
                    "description": "The vibrant lights of the city at night.",
                    "author": "Jane Smith",
                    "published": "2024-09-26T12:34:56Z",
                    "media": {
                        "m": "https://live.staticflickr.com/65535/54022630657_8c48a21d33_m.jpg"
                    }
                }
            ]
        }
        """.data(using: .utf8)!
        
        
        let mockURLSession = MockURLSession(mockData: mockData, statusCode: 200, mockError: nil)
        let networkClient = NetworkClient(session: mockURLSession)
        
        let data = try await networkClient.performRequest(for: .imageTag(tag: " "))
        
        let mockFlickrResponseList = try JSONDecoder().decode(FlickrResponse.self, from: mockData)
        let returnedFlickrResponseList = try JSONDecoder().decode(FlickrResponse.self, from: data)
        
        for (mockCategory, returnedCategory) in zip(mockFlickrResponseList.items, returnedFlickrResponseList.items) {
            XCTAssertEqual(mockCategory.media.m, returnedCategory.media.m)
        }
    }
    
    func testPerformRequestNon200StatusCode() async throws {
        let mockURLSession = MockURLSession(mockData: nil, statusCode: 404, mockError: nil)
        let networkClient = NetworkClient(session: mockURLSession)
        
        do {
            _ = try await networkClient.performRequest(for: .imageTag(tag: " "))
            XCTFail("Expected to throw URLError, but request succeeded")
        } catch let error as URLError {
            XCTAssertEqual(error.code, .badServerResponse)
        }
    }
    
    func testPerformRequest404() async {
        let mockURLSession = MockURLSession(mockData: Data(), statusCode: 404, mockError: nil)
        let networkClient = NetworkClient(session: mockURLSession)
        
        do {
            _ = try await networkClient.performRequest(for: .imageTag(tag: " "))
            XCTFail("Request should have failed with 404 error")
        } catch {
            XCTAssertTrue(error is URLError)
            XCTAssertEqual((error as? URLError)?.code, .badServerResponse)
        }
    }
    
    func testPerformRequestNetworkFailure() async throws {
        let mockError = URLError(.notConnectedToInternet)
        let mockURLSession = MockURLSession(mockData: nil, statusCode: 0, mockError: mockError)
        let networkClient = NetworkClient(session: mockURLSession)
        
        do {
            _ = try await networkClient.performRequest(for: .imageTag(tag: " "))
            XCTFail("Expected to throw URLError, but request succeeded")
        } catch let error as URLError {
            XCTAssertEqual(error.code, .notConnectedToInternet)
        } catch {
            XCTFail("Expected URLError, but got \(error)")
        }
    }
    
    func testBuildRequest() throws {
        let requestType = DataRequestType.imageTag(tag: "porcupine", nojsoncallback: 2)
        let requestBuilder = RequestBuilder()
        
        let request = try requestBuilder.buildRequest(for: requestType)
        
        XCTAssertEqual(request.url?.absoluteString, "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=2&tags=porcupine")
        XCTAssertEqual(request.httpMethod, "GET")
    }
    
}
