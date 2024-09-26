//
//  FlickrImageSearchView.swift
//  FlickrHunt
//
//  Created by Sadiya Syeda on 9/25/24.
//

import SwiftUI

struct FlickrImageSearchView: View {
    @StateObject private var viewModel = FlickrViewModel()
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                // Search bar
                TextField("Search Flickr", text: $searchText)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: searchText) { newText in
                        Task {
                            if !newText.isEmpty {
                                await viewModel.searchPhotos(for: newText)
                            } else {
                                viewModel.photos = [] // Clear photos when search is empty
                            }
                        }
                    }
                
                // Loading Spinner
                if viewModel.isLoading {
                    ProgressView("Loading...").padding()
                }
                
                // Grid of images
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                        ForEach(viewModel.photos) { photo in
                            NavigationLink(
                                destination: FlickrImageDetailView(photo: photo)
                            ) {
                                AsyncFlickrImageView(urlString: photo.media.m)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("FlickrFinder")
        }
    }
}
