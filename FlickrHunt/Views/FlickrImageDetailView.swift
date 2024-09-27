//
//  FlickrImageDetailView.swift
//  FlickrHunt
//
//  Created by Sadiya Syeda on 9/25/24.
//

import SwiftUI

struct FlickrImageDetailView: View {
    let photo: FlickrImage
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                Text(photo.title)
                    .font(.title)
                    .foregroundColor(.purple)
                    .fontWeight(.bold)
                    .padding([.top, .leading, .trailing])
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)
                    .accessibilityLabel("Image Title: \(photo.title)")
                    .accessibilityHint("Image title description")
                
                AsyncFlickrImageView(urlString: photo.media.m)
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: 300)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding()
                    .accessibilityLabel("Image view")
                    .accessibilityHint("A detailed view of the image")
                
                Text("Description:")
                    .font(.headline)
                    .padding(.bottom, 2)
                    .accessibilityLabel("Description")
                    .accessibilityHint("Title Description")
                
                if let authorLink = parseAuthorLink(description: photo.description) {
                    Link(authorLink.text, destination: URL(string: authorLink.url)!)
                        .foregroundColor(.blue)
                        .font(.body)
                        .accessibilityLabel("Hyperlink Author \(authorLink.text)")
                        .accessibilityHint("Tap to visit author \(authorLink.text) profile")
                }
                
                if let imageLink = parseImageLink(description: photo.description) {
                    Spacer()
                    Text("posted a photo:")
                        .accessibilityLabel("Posted a photo")
                    Spacer()
                    
                    Link("Here", destination: URL(string: imageLink)!)
                        .foregroundColor(.blue)
                        .font(.body)
                        .padding(.bottom, 2)
                        .accessibilityLabel("Hyperlink Here")
                        .accessibilityHint("Tap to visit image site.")
                }
                
                let specificDescription = parseSpecificDescriptionText(description: photo.description)
                if !specificDescription.isEmpty {
                    Text(specificDescription)
                        .foregroundColor(.primary)
                        .font(.body)
                        .padding(.bottom, 2)
                        .accessibilityLabel("Detailed description: \(specificDescription)")
                        .accessibilityHint("Detailed description of the image")
                }
                
                Text("Author: \(photo.author)")
                    .font(.body)
                    .foregroundColor(.mint)
                    .padding(.bottom, 10)
                    .accessibilityLabel("Author: \(photo.author)")
                    .accessibilityHint("\(photo.title) image was uploaded by \(photo.author)")
                
                Text("Published on \(formatDate(photo.published))")
                    .font(.body)
                    .foregroundColor(.mint)
                    .accessibilityLabel("Published: \(formatDate(photo.published))")
                    .accessibilityHint("The image \(photo.title) was published on \(formatDate(photo.published))")
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .accessibilityElement(children: .contain)
    }
}

private func formatDate(_ dateString: String) -> String {
    let formatter = ISO8601DateFormatter()
    if let date = formatter.date(from: dateString) {
        let displayFormatter = DateFormatter()
        displayFormatter.dateStyle = .medium
        displayFormatter.timeStyle = .none
        return displayFormatter.string(from: date)
    }
    return dateString
}

private func parseAuthorLink(description: String) -> LinkItem? {
    let linkPattern = #"<a href=\"([^\"]+)\">([^<]+)</a>"#
    let regex = try? NSRegularExpression(pattern: linkPattern, options: [])
    let matches = regex?.matches(in: description, options: [], range: NSRange(location: 0, length: description.utf16.count))
    
    if let match = matches?.first, let urlRange = Range(match.range(at: 1), in: description),
       let textRange = Range(match.range(at: 2), in: description) {
        let url = String(description[urlRange])
        let text = String(description[textRange])
        return LinkItem(text: text, url: url)
    }
    return nil
}

private func parseImageLink(description: String) -> (String)? {
    let imagePattern = #"<a href=\"([^\"]+)\"[^>]*><img src=\"([^\"]+)\"[^>]*(?: alt=\"([^\"]*)\")?[^>]*></a>"#
    let regex = try? NSRegularExpression(pattern: imagePattern, options: [])
    let matches = regex?.matches(in: description, options: [], range: NSRange(location: 0, length: description.utf16.count))
    
    if let match = matches?.first,
       let urlRange = Range(match.range(at: 1), in: description) {
        let url = String(description[urlRange])
        
        return (url)
    }
    return nil
}

private func parseSpecificDescriptionText(description: String) -> String {
    // Match <p> tags and extract content inside them, but exclude any <a> tags
    let paragraphPattern = #"<p>(?:(?!<a ).)*?([^<]+)(?:(?!<\/a>).)*<\/p>"#
    let regex = try? NSRegularExpression(pattern: paragraphPattern, options: [])
    let matches = regex?.matches(in: description, options: [], range: NSRange(location: 0, length: description.utf16.count))
    
    // Iterate over all matches and find the last non-empty paragraph
    for match in matches?.reversed() ?? [] {
        if let textRange = Range(match.range(at: 1), in: description) {
            let specificText = String(description[textRange])
            
            // Return this text if it's not empty or just whitespace
            if !specificText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return specificText
            }
        }
    }
    return ""
}


private func hasPlainText(description: String) -> Bool {
    // Check for any text outside of HTML tags
    let plainTextPattern = #">([^<]+)<"# // Matches text between HTML tags
    let regex = try? NSRegularExpression(pattern: plainTextPattern, options: [])
    let matches = regex?.matches(in: description, options: [], range: NSRange(location: 0, length: description.utf16.count))
    
    return matches?.count ?? 0 > 0
}

struct LinkItem: Hashable {
    let text: String
    let url: String
}

struct FlickrImageDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Portrait Preview
            FlickrImageDetailView(photo: FlickrImage(
                id: "1",
                title: "Sample Image 1",
                description: "This is a sample description for the image.",
                author: "Author 1",
                published: "2023-09-25T10:00:00Z",
                media: FlickrImage.Media(m: "https://via.placeholder.com/300")
            ))
            .previewDevice("iPhone 14")
            .previewDisplayName("Portrait")
            .dynamicTypeSize(.large)
            
            // Landscape Preview
            FlickrImageDetailView(photo: FlickrImage(
                id: "1",
                title: "Sample Image 1",
                description: "This is a sample description for the image.",
                author: "Author 1",
                published: "2023-09-25T10:00:00Z",
                media: FlickrImage.Media(m: "https://via.placeholder.com/300")
            ))
            .previewDevice("iPhone 14")
            .previewDisplayName("Landscape")
            .previewLayout(.fixed(width: 896, height: 414))
            .dynamicTypeSize(.large)
        }
    }
}


