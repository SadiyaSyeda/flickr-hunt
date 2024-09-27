# flickr-hunt

# Overview
This iPhone app allows users to search Flickr for images via a search bar and displays results in a grid. It supports dynamic search, progress indicators, image details, accessibility features, image caching, and more for a smooth user experience.

# Key Features

## 1.Image Search Functionality
 * A search bar at the top allows users to type in a search query.
 * The search results are fetched from Flickr based on the entered query.
 * The search supports single words and comma-separated words (e.g., "cat" or "forest, bird").
 * Search results update in real-time after each keystroke or change to the search string.
   
## 2.Image Display
 * A grid below the search bar displays the thumbnail images fetched from Flickr.
 
## 3.Image Caching
*  Image caching is implemented to enhance the performance by storing images fetched from the Flickr API. This allows previously loaded images to be quickly retrieved from the cache, reducing loading times and unnecessary network calls, leading to a smoother user experience.

## 4. Image Detail View
 * Tapping on an image shows a detail view with:
    Full-sized image
    Title
    Description
    Author
    Formatted published date
   
## 5. Accessibility Support
 * Full VoiceOver support to assist visually impaired users.
 * Dynamic text support allows the app to respond to the device’s text size settings.
   
## 6. Orientation Support
 * The app supports both portrait and landscape orientations.
   
## 7. Launch Screen and Default Images
 * Upon launching, the app shows a splash screen.
 * Default images from Flickr’s public feed are displayed before the user begins searching.
   
## 8. Pagination
 * Infinite scroll support with pagination to fetch more data as the user scrolls down.
   
## 9. Loading Indicator
 * A non-blocking loading spinner appears while search results are being fetched.

# App Demo

![Simulator Screen Recording - iPhone 14 Pro - 2024-09-27 at 11 16 51](https://github.com/user-attachments/assets/beca424e-3525-431d-b077-38d015586309)

# Architecture

The app follows the MVVM (Model-View-ViewModel) pattern:

* **Model**: Represents data structures, including FlickrImage and network-related data like FlickrResponse.
* **View**: Comprises SwiftUI views (FlickrImageSearchView, FlickrImageDetailView, etc.) that define the app's user interface.
* **ViewModel**: Handles fetching data from the network, updates the views, and manages state. It includes:
FlickrViewModel responsible for handling image search, fetching public photos, and managing the loading state.
* **async/await**: Streamlines asynchronous network calls, allowing for more readable and maintainable code by avoiding callbacks.
* **@MainActor**: Ensures that UI updates are performed on the main thread, promoting thread safety and a smoother user experience when updating the UI with data fetched asynchronously.

# SwiftUI Previews

Previews are implemented for all major views, allowing for visual inspection during development.
LaunchView has a preview showcasing the initial splash screen.
The search grid view and detail view both support previews, making it easier to test layout and accessibility.

# Tests

Unit tests are provided for the network client and view models to ensure the correctness of the app’s data flow and logic.

# Key Files

 * FlickrImageSearchView.swift: Main view containing the search bar, grid of images, and progress indicator.
 * FlickrViewModel.swift: ViewModel handling the search logic and state management.
 * NetworkClient.swift: Manages API calls to fetch images.
 * FlickrImageDetailView.swift: Shows detailed information when an image is tapped.
 * LaunchView.swift: Displays the splash screen on app launch.
 * AsyncFlickrImageView.swift: Asynchronously loads and displays an image from a URL, showing a placeholder until the image is ready.
 * ImageCache.swift: Singleton class that uses `NSCache` to efficiently store and retrieve images by their keys, providing a centralized caching solution for the app.
 * ImageLoader.swift: An `ObservableObject` that asynchronously loads images from a given URL, first checking the `ImageCache` for cached images before fetching them from the network and caching them for future use.
 * MockNetworkClient.swift: Testable implementation of `NetworkClientProtocol` that allows you to simulate network responses by providing predefined mock data or errors, facilitating unit testing without making actual network calls.
 * MockURLSession.swift: is a testable implementation of `URLSessionProtocol` that simulates network responses by providing mock data, a specified HTTP status code, and an optional error, enabling effective unit testing without actual network interaction.
 * Tests: Includes unit tests for the network client and view models.
