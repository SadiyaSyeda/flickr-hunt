//
//  FlickrImageDetailView.swift
//  FlickrHunt
//
//  Created by Sadiya Syeda on 9/25/24.
//

import SwiftUI

import SwiftUI

struct FlickrImageDetailView: View {
    let photo: FlickrImage
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // Image View
                AsyncFlickrImageView(urlString: photo.media.m)
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding()
                
                // Title
                Text(photo.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 5)
                
                // Description
                Text("Description:")
                    .font(.headline)
                    .padding(.bottom, 2)
                
                // Format description fields
                if let formattedDescription = formatDescription(photo.description) {
                    Text(formattedDescription)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 10)
                } else {
                    Text("No description available.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 10)
                }
                
                // Author
                Text("Author:")
                    .font(.headline)
                    .padding(.bottom, 2)
                
                Text(photo.author)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 10)
                
                // Published Date
                Text("Published:")
                    .font(.headline)
                    .padding(.bottom, 2)
                
                Text(formatDate(photo.published))
                    .font(.body)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(photo.title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // Format the published date
    private func formatDate(_ dateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: dateString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            displayFormatter.timeStyle = .none
            return displayFormatter.string(from: date)
        }
        return dateString // Return the original string if parsing fails
    }
    
    // Format the description to include all fields clearly
    private func formatDescription(_ htmlString: String) -> String? {
        // Attempt to convert HTML to plain text
        guard let data = htmlString.data(using: .utf8) else { return nil }
        
        do {
            let attributedString = try NSAttributedString(
                data: data,
                options: [.documentType: NSAttributedString.DocumentType.html,
                          .characterEncoding: String.Encoding.utf8.rawValue],
                documentAttributes: nil
            )
            
            // Convert AttributedString to String
            let descriptionString = attributedString.string
            
            // Here you can customize how you want to format it
            // For instance, splitting by new lines or bullet points
            let formattedString = descriptionString
                .replacingOccurrences(of: "\n", with: "\n• ") // Add bullet points
                .trimmingCharacters(in: .whitespacesAndNewlines) // Trim whitespace
            
            return "• " + formattedString // Prepend bullet for the first line
        } catch {
            print("Error converting HTML to AttributedString: \(error)")
            return nil
        }
    }
}
