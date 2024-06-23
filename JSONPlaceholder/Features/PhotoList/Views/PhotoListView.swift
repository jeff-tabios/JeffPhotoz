//
//  PhotoListView.swift
//  JSONPlaceholder
//
//  Created by Jeffrey Tabios on 6/23/24.
//

import Foundation
import SwiftUI

struct PhotoListView: View {
    @StateObject private var viewModel = PhotoListViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.photos) { photo in
                    NavigationLink(destination: PhotoDetailView(photo: photo)) {
                        HStack(spacing: 8) {
                            AsyncImageLoaderView(url: URL(string: photo.thumbnailUrl)!)
                            .frame(width: 50, height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 10))

                            Text(photo.title)
                                .font(.headline)
                        }
                    }
                    .onAppear {
                        if let lastPhoto = viewModel.photos.last, lastPhoto == photo {
                                viewModel.fetchPhotos()
                            }
                    }
                }
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .navigationTitle("Photos")
        }
        .alert(item: $viewModel.errorMessage) { error in
            Alert(title: Text("Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
        }
    }
}
