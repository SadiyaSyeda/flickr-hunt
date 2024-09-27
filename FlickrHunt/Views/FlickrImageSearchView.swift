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
    @State private var isActive: Bool = true
    
    var body: some View {
        if isActive {
            LaunchView(isActive: $isActive)
        } else {
            NavigationView {
                VStack {
                    TextField("Search Flickr", text: $searchText)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.green, lineWidth: 2)
                        )
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .foregroundColor(.brown)
                        .font(.system(size: 20, weight: .semibold))
                        .onChange(of: searchText) { newText in
                            Task {
                                if !newText.isEmpty {
                                    await viewModel.searchPhotos(for: newText)
                                } else {
                                    viewModel.photos = []
                                    await viewModel.fetchPublicPhotos()
                                }
                            }
                        }
                        .accessibilityLabel("Search Flickr Images")
                        .accessibilityHint("Enter text to search for Flickr images")
                    
                    // Loading Spinner
                    if viewModel.isLoading {
                        ProgressView("Loading...")
                            .font(.system(size: 20, weight: .semibold))
                            .padding()
                            .accessibilityLabel("Loading")
                            .accessibilityHint("Please wait while images are loading")
                    }
                    
                    // Grid of images with uniform size
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 16) {
                            ForEach(viewModel.photos) { photo in
                                NavigationLink(destination: FlickrImageDetailView(photo: photo)) {
                                    AsyncFlickrImageView(urlString: photo.media.m)
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 120, height: 120)
                                        .clipped()
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .accessibilityLabel("Image \(photo.title)")
                                        .accessibilityHint("Double tap to view image details")
                                }
                                .onAppear {
                                    // Check if this is the last photo and trigger pagination
                                    if photo == viewModel.photos.last && !viewModel.isLoading && !viewModel.isLastPage {
                                        Task {
                                            await viewModel.loadMorePhotos()
                                        }
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }
                .navigationTitle("Flickr Hunt 👀🔎")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Flickr Hunt 👀🔎")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.purple)
                            .accessibilityLabel("Header Flickr Hunt 👀🔎")
                            .accessibilityAddTraits(.isHeader)
                    }
                }
            }
            .onAppear {
                Task {
                    await viewModel.fetchPublicPhotos()
                }
            }
        }
    }
}


// Mock Data for Preview
extension FlickrViewModel {
    static var mockPhotos: [FlickrImage] {
        [
            FlickrImage(
                title: "Sample Image 1",
                description: "Sample description 1",
                author: "Author 1",
                published: "2023-09-25T10:00:00Z",
                media: FlickrImage.Media(m: "https://via.placeholder.com/120")
            ),
            FlickrImage(
                title: "Sample Image 1",
                description: "Sample description 2",
                author: "Author 2",
                published: "2023-09-26T12:00:00Z",
                media: FlickrImage.Media(m: "https://via.placeholder.com/120")
            )
        ]
    }
    
    convenience init(mock: Bool) {
        self.init()
        if mock {
            self.photos = FlickrViewModel.mockPhotos
        }
    }
}

// Preview
struct FlickrImageSearchView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Portrait Preview
            FlickrImageSearchView()
                .previewDevice("iPhone 14")
                .previewDisplayName("Portrait")
                .dynamicTypeSize(.large)
            
            // Landscape Preview
            FlickrImageSearchView()
                .previewDevice("iPhone 14")
                .previewDisplayName("Landscape")
                .previewLayout(.fixed(width: 896, height: 414))
                .dynamicTypeSize(.large)
        }
    }
}
