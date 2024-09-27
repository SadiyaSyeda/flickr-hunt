//
//  RequestBuilder.swift
//  FlickrHunt
//
//  Created by Sadiya Syeda on 9/26/24.
//

import Foundation

struct RequestBuilder {
    func buildRequest(for requestType: RequestType) throws -> URLRequest {
        guard var urlComponents = URLComponents(string: requestType.baseDomain.getPublicPhotosDomain()) else {
            throw URLError(.badURL)
        }
        
        switch requestType {
        case let dataRequest as DataRequestType:
            switch dataRequest {
            case .imageTag(let tag, let page):
                let formattedTags = tag.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                
                if !formattedTags.isEmpty {
                    urlComponents.queryItems = [
                        URLQueryItem(name: "format", value: "json"),
                        URLQueryItem(name: "nojsoncallback", value: "\(page)"),
                        URLQueryItem(name: "tags", value: formattedTags)
                    ]
                } else {
                    // For public photos, no tags should be included
                    urlComponents.queryItems = [
                        URLQueryItem(name: "format", value: "json"),
                        URLQueryItem(name: "nojsoncallback", value: "\(page)")
                    ]
                }
            }
        default:
            throw URLError(.unsupportedURL)
        }
        
        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = requestType.httpMethod.getHttpMethod()
        
        // Set body if present (for POST requests)
        if let bodyData = (requestType as? DataRequestType)?.bodyData {
            urlRequest.httpBody = bodyData
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        return urlRequest
    }
}
