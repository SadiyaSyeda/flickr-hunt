//
//  RequestType.swift
//  FlickrHunt
//
//  Created by Sadiya Syeda on 9/26/24.
//

import Foundation

protocol RequestType {
    var baseDomain: BaseDomain { get }
    var endpoint: String { get }
    var httpMethod: HttpMethodType { get }
}

enum DataRequestType: RequestType {
    case imageTag(tag: String, nojsoncallback: Int = 1)
    
    var baseDomain: BaseDomain {
        switch self {
        case .imageTag:
            return .publicPhotos
        }
    }
    
    var endpoint: String {
        switch self {
        case .imageTag(let tag, let nojsoncallback):
            let formattedTags = tag.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return "&nojsoncallback=\(nojsoncallback)&tags=\(formattedTags)"
        }
    }
    
    var httpMethod: HttpMethodType {
        switch self {
        case .imageTag:
            return .get
        default: // Incase if there will be a new endpoint with POST method in future
            return .post
        }
    }
    
    var bodyData: Data? {
        switch self {
        default:
            return nil
        }
    }
}
