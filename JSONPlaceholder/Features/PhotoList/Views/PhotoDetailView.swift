//
//  PhotoDetailView.swift
//  JSONPlaceholder
//
//  Created by Jeffrey Tabios on 6/23/24.
//

import Foundation
import SwiftUI

struct PhotoDetailView: View {
    let photo: Photo

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImageLoaderView(url: URL(string: photo.url)!)
                    .frame(maxWidth: .infinity, maxHeight: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                Text(photo.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .padding()
        }
        .navigationTitle("Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}
