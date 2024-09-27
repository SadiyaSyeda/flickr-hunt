//
//  FlickrViewModel.swift
//  FlickrHunt
//
//  Created by Sadiya Syeda on 9/25/24.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class FlickrViewModel: ObservableObject {
    @Published var photos: [FlickrImage] = []
    @Published var isLoading = false
    @Published var isLastPage = false
    var currentPage = 1
        
    var networkClient: NetworkClientProtocol
    
    init(networkClient: NetworkClientProtocol = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    func fetchPublicPhotos(page: Int = 1) async {
            guard !isLoading else { return }
            isLoading = true
            
            do {
                let data = try await networkClient.performRequest(for: DataRequestType.imageTag(tag: "", nojsoncallback: page))
                let decoder = JSONDecoder()
                let response = try decoder.decode(FlickrResponse.self, from: data)
                
                DispatchQueue.main.async {
                    if response.items.isEmpty {
                        self.isLastPage = true
                    } else {
                        let newItems = response.items
                        
                        self.photos.append(contentsOf: newItems)
                    }
                    self.isLoading = false
                    self.currentPage = page
                }
            } catch {
                print("Error fetching data: \(error)")
                isLoading = false
            }
        }
        
        func loadMorePhotos() async {
            guard !isLastPage else { return }
            
            // Increment the page number for the next set of photos
            await fetchPublicPhotos(page: currentPage + 1)
        }
    
    func searchPhotos(for tags: String) async {
        isLastPage = false
        
        isLoading = true
        
        do {
            let data = try await networkClient.performRequest(for: DataRequestType.imageTag(tag: tags))
            let response = try JSONDecoder().decode(FlickrResponse.self, from: data)
            DispatchQueue.main.async {
                self.photos = response.items
                self.isLoading = false
            }
        } catch {
            print("Error fetching data: \(error)")
            isLoading = false
        }
    }
}
