//
//  CoreDataManager.swift
//  JSONPlaceholder
//
//  Created by Jeffrey Tabios on 6/23/24.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()

    let persistentContainer: NSPersistentContainer

    private init() {
        persistentContainer = NSPersistentContainer(name: "JSONPlaceholder")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
    }

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError("Unresolved error \(error)")
            }
        }
    }

    func fetchCachedPhotos() -> [Photo] {
        let fetchRequest: NSFetchRequest<CachedPhotoItem> = CachedPhotoItem.fetchRequest()
        do {
            let cachedPhotos = try persistentContainer.viewContext.fetch(fetchRequest)
            return cachedPhotos.map { Photo(cachedPhoto: $0) }
        } catch {
            print("Failed to fetch cached photos: \(error)")
            return []
        }
    }

    func savePhotos(_ photos: [Photo]) {
        let context = persistentContainer.viewContext
        photos.forEach { photo in
            let cachedPhoto = CachedPhotoItem(context: context)
            cachedPhoto.id = Int64(photo.id)
            cachedPhoto.title = photo.title
            cachedPhoto.imageUrl = photo.thumbnailUrl // Update property name
            cachedPhoto.fullSizeImageUrl = photo.url // Update property name
        }
        saveContext()
    }

    func deleteAllItems() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CachedPhotoItem.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try persistentContainer.viewContext.execute(deleteRequest)
            saveContext()
        } catch {
            print("Failed to delete items: \(error)")
        }
    }
}
