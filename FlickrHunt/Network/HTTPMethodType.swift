//
//  HTTPMethodType.swift
//  FlickrHunt
//
//  Created by Sadiya Syeda on 9/26/24.
//

import Foundation

enum HttpMethodType {
    case get
    case post
    
    func getHttpMethod() -> String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        }
    }
}
