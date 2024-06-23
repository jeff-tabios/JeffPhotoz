# JeffPhotoz
 JSON Placeholder photos - List - Detail example

## Overview

This project is an iOS application that fetches a list of photos from a remote API, displays them in a list, and provides a detailed view for each photo. It includes caching for offline access and follows best practices for performance and maintainability.

## Features

- Display a list of photos with image and title.
- Simple navigation to a detail view for each photo.
- Infinite scrolling to handle large datasets.
- Local caching of data to improve performance and offline access.
- Efficient image loading with caching.
- Error handling.

## Requirements

- iOS 14.0+
- Xcode 12.0+
- Swift 5.0+

## Architecture

The project uses the MVVM (Model-View-ViewModel) architecture pattern, with Combine for reactive programming and SwiftUI for the user interface.

