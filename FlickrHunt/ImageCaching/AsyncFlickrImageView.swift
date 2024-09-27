//
//  AsyncFlickrImageView.swift
//  FlickrHunt
//
//  Created by Sadiya Syeda on 9/25/24.
//

import SwiftUI

struct AsyncFlickrImageView: View {
    @StateObject private var loader: ImageLoader
    let placeholder: Image
    
    init(urlString: String?, placeholder: Image = Image(systemName: "photo")) {
        _loader = StateObject(wrappedValue: ImageLoader(urlString: urlString))
        self.placeholder = placeholder
    }
    
    var body: some View {
        // Use a placeholder until the image is loaded
        if let image = loader.image {
            Image(uiImage: image)
                .resizable()
        } else {
            placeholder
                .resizable()
        }
    }
}
