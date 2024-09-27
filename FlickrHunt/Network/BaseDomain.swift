//
//  BaseDomain.swift
//  FlickrHunt
//
//  Created by Sadiya Syeda on 9/26/24.
//

import Foundation

enum BaseDomain {
    case publicPhotos
    
    func getPublicPhotosDomain() -> String {
        switch self {
        case .publicPhotos:
            return "https://api.flickr.com/services/feeds/photos_public.gne?format=json"
        }
    }
}
