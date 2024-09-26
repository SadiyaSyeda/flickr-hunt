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
    
    func searchPhotos(for tags: String) async {
        let formattedTags = tags.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags=\(formattedTags)"
        
        guard let url = URL(string: urlString) else { return }
        
        isLoading = true
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(FlickrResponse.self, from: data)
            self.photos = response.items
            print(self.photos)
        } catch {
            print("Error fetching data: \(error)")
        }
        
        isLoading = false
    }
}
