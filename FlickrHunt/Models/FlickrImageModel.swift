//
//  FlickrImageModel.swift
//  FlickrHunt
//
//  Created by Sadiya Syeda on 9/25/24.
//

import Foundation

struct FlickrImage: Identifiable, Decodable, Encodable, Equatable {
    let id: String
    let title: String
    let description: String
    let author: String
    let published: String
    let media: Media

    struct Media: Decodable, Encodable, Equatable {
        let m: String
    }

    init(id: String = UUID().uuidString, title: String, description: String, author: String, published: String, media: Media) {
        self.id = id
        self.title = title
        self.description = description
        self.author = author
        self.published = published
        self.media = media
    }

    enum CodingKeys: String, CodingKey {
        case title, description, author, published, media
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decode(String.self, forKey: .description)
        self.author = try container.decode(String.self, forKey: .author)
        self.published = try container.decode(String.self, forKey: .published)
        self.media = try container.decode(Media.self, forKey: .media)

        self.id = UUID().uuidString
    }
}

struct FlickrResponse: Decodable, Encodable {
    let items: [FlickrImage]
}
