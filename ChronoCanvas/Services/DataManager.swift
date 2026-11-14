//  DataManager.swift

import CoreData
import Foundation
import os

/// Core Data スタックを管理する
final class DataManager {
    static let shared = DataManager()

    let persistentContainer: NSPersistentContainer
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "ChronoCanvas", category: "DataManager")

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    /// - Parameter inMemory: プレビューやテスト用にメモリ上のストアを使う場合は true
    init(inMemory: Bool = false) {
        persistentContainer = NSPersistentContainer(name: "ChronoCanvas")
        if inMemory {
            persistentContainer.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        persistentContainer.persistentStoreDescriptions.forEach {
            $0.shouldMigrateStoreAutomatically = true
            $0.shouldInferMappingModelAutomatically = true
        }
        persistentContainer.loadPersistentStores { [logger] _, error in
            if let error = error as NSError? {
                // ストアが読み込めない状態での続行はデータ破損につながるため、ここだけは停止する
                logger.fault("Failed to load persistent store: \(error), \(error.userInfo)")
                fatalError("Failed to load persistent store: \(error)")
            }
        }
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    /// コンテキストの変更を保存する。失敗した場合はロールバックし、アプリは停止させない
    @discardableResult
    func saveContext() -> Bool {
        guard context.hasChanges else { return true }
        do {
            try context.save()
            return true
        } catch {
            logger.error("Failed to save context: \(error.localizedDescription)")
            context.rollback()
            return false
        }
    }
}
