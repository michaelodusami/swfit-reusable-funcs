//
//  CoreDataHelper.swift
//  YourProject
//
//  Created by YourName on Date.
//

import Foundation
import CoreData

public class CoreDataHelper {
    public static let shared = CoreDataHelper()
    private init() { }
    
    // Update the container name to match your .xcdatamodeld filename
    public lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "YourModelName")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("CoreDataHelper: Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    public var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - CRUD Operations
    
    /// Creates a new NSManagedObject for the specified entity.
    public func create<T: NSManagedObject>(entity: T.Type) -> T? {
        guard let entityName = T.entity().name else { return nil }
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as? T
    }
    
    /// Saves the current context.
    public func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("CoreDataHelper: Error saving context: \(error)")
            }
        }
    }
    
    /// Fetches objects for the specified entity, optionally filtered and sorted.
    public func fetch<T: NSManagedObject>(entity: T.Type,
                                          predicate: NSPredicate? = nil,
                                          sortDescriptors: [NSSortDescriptor]? = nil) -> [T]? {
        guard let entityName = T.entity().name else { return nil }
        let request = NSFetchRequest<T>(entityName: entityName)
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        
        do {
            let results = try context.fetch(request)
            return results
        } catch {
            print("CoreDataHelper: Error fetching \(entityName): \(error)")
            return nil
        }
    }
    
    /// Deletes the specified NSManagedObject.
    public func delete(_ object: NSManagedObject) {
        context.delete(object)
        saveContext()
    }
}



//
//  UserDefaultsManager.swift
//  YourProject
//
//  Created by YourName on Date.
//

import Foundation

public class UserDefaultsManager {
    public static let shared = UserDefaultsManager()
    private let defaults = UserDefaults.standard
    
    private init() { }
    
    /// Stores a value for the given key.
    public func set<T>(value: T, forKey key: String) {
        defaults.set(value, forKey: key)
    }
    
    /// Retrieves a value of the specified type for the given key.
    public func get<T>(forKey key: String) -> T? {
        return defaults.value(forKey: key) as? T
    }
    
    /// Removes the value associated with the given key.
    public func removeValue(forKey key: String) {
        defaults.removeObject(forKey: key)
    }
    
    /// Clears all values stored in UserDefaults for this app.
    public func clearAll() {
        if let domain = Bundle.main.bundleIdentifier {
            defaults.removePersistentDomain(forName: domain)
        }
    }
}


//
//  FileManagerHelper.swift
//  YourProject
//
//  Created by YourName on Date.
//

import Foundation

public class FileManagerHelper {
    public static let shared = FileManagerHelper()
    private init() { }
    
    private let fileManager = FileManager.default
    
    /// Returns the URL for the app's Documents directory.
    public func documentsDirectory() -> URL {
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    /// Writes data to a file with the given filename in the Documents directory.
    @discardableResult
    public func write(data: Data, to filename: String) -> Bool {
        let fileURL = documentsDirectory().appendingPathComponent(filename)
        do {
            try data.write(to: fileURL)
            return true
        } catch {
            print("FileManagerHelper: Error writing file: \(error)")
            return false
        }
    }
    
    /// Reads data from a file with the given filename in the Documents directory.
    public func read(from filename: String) -> Data? {
        let fileURL = documentsDirectory().appendingPathComponent(filename)
        do {
            let data = try Data(contentsOf: fileURL)
            return data
        } catch {
            print("FileManagerHelper: Error reading file: \(error)")
            return nil
        }
    }
    
    /// Deletes the file with the given filename from the Documents directory.
    @discardableResult
    public func delete(filename: String) -> Bool {
        let fileURL = documentsDirectory().appendingPathComponent(filename)
        do {
            try fileManager.removeItem(at: fileURL)
            return true
        } catch {
            print("FileManagerHelper: Error deleting file: \(error)")
            return false
        }
    }
    
    /// Checks if a file exists with the given filename in the Documents directory.
    public func fileExists(filename: String) -> Bool {
        let fileURL = documentsDirectory().appendingPathComponent(filename)
        return fileManager.fileExists(atPath: fileURL.path)
    }
}


//
//  ImageCacheManager.swift
//  YourProject
//
//  Created by YourName on Date.
//

import UIKit

public class ImageCacheManager {
    public static let shared = ImageCacheManager()
    private init() { }
    
    private let cache = NSCache<NSString, UIImage>()
    
    /// Retrieves a cached image for the given key.
    public func image(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    /// Caches the provided image using the given key.
    public func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
    /// Removes the cached image for the specified key.
    public func removeImage(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
    }
    
    /// Clears all images from the cache.
    public func clearCache() {
        cache.removeAllObjects()
    }
}


//
//  CodableModel.swift
//  YourProject
//
//  Created by YourName on Date.
//

import Foundation

/// A protocol for models that support Codable-based JSON parsing.
public protocol CodableModel: Codable { }

public extension CodableModel {
    /// Decodes an instance from Data.
    static func decode(from data: Data) -> Self? {
        let decoder = JSONDecoder()
        do {
            let model = try decoder.decode(Self.self, from: data)
            return model
        } catch {
            print("CodableModel: Decoding error - \(error)")
            return nil
        }
    }
    
    /// Encodes the instance into Data.
    func encode() -> Data? {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(self)
            return data
        } catch {
            print("CodableModel: Encoding error - \(error)")
            return nil
        }
    }
    
    /// Decodes an instance from a JSON string.
    static func decode(from jsonString: String, using encoding: String.Encoding = .utf8) -> Self? {
        guard let data = jsonString.data(using: encoding) else { return nil }
        return decode(from: data)
    }
    
    /// Converts the instance to a JSON string.
    func toJSONString(encoding: String.Encoding = .utf8) -> String? {
        guard let data = encode() else { return nil }
        return String(data: data, encoding: encoding)
    }
}


