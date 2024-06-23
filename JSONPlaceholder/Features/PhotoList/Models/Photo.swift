//
//  Photo.swift
//  JSONPlaceholder
//
//  Created by Jeffrey Tabios on 6/23/24.
//

import Foundation

struct Photo: Identifiable, Codable, Equatable {
    init(id: Int, title: String, thumbnailUrl: String, url: String) {
        self.id = id
        self.title = title
        self.thumbnailUrl = thumbnailUrl
        self.url = url
    }
    
    let id: Int
    let title: String
    let thumbnailUrl: String
    let url: String

    init(cachedPhoto: CachedPhotoItem) {
        self.id = Int(cachedPhoto.id)
        self.title = cachedPhoto.title ?? ""
        self.thumbnailUrl = cachedPhoto.imageUrl ?? ""
        self.url = cachedPhoto.fullSizeImageUrl ?? ""
    }

    static func ==(lhs: Photo, rhs: Photo) -> Bool {
        return lhs.id == rhs.id
    }
}
