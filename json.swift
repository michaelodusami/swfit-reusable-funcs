import Foundation

/// Decodes a JSON file into an array of structs of type `T`.
public func decodeJsonFileIntoArrayStruct<T: Decodable>(fullFileName: String, fileLocation: String, as type: T.Type = T.self) -> T? {
    
    // Get the file URL based on location
    guard let jsonFileUrl = getJsonFileUrl(fullFileName: fullFileName, fileLocation: fileLocation) else {
        return nil
    }

    // Read data from the file
    guard let jsonData = readData(from: jsonFileUrl) else {
        return nil
    }

    // Decode the JSON data into the desired type
    return decodeJsonData(jsonData, as: type)
}

/// Retrieves the URL of the JSON file from the specified location.
private func getJsonFileUrl(fullFileName: String, fileLocation: String) -> URL? {
    if fileLocation == "Main Bundle" {
        if let url = Bundle.main.url(forResource: fullFileName, withExtension: nil) {
            return url
        } else {
            print("JSON file \(fullFileName) does not exist in main bundle!")
            return nil
        }
    } else {
        let documentDirectoryUrl = documentDirectory.appendingPathComponent(fullFileName)
        if FileManager.default.fileExists(atPath: documentDirectoryUrl.path) {
            return documentDirectoryUrl
        } else {
            print("JSON file \(fullFileName) does not exist in document directory!")
            return nil
        }
    }
}

/// Reads data from a given file URL.
private func readData(from url: URL) -> Data? {
    do {
        return try Data(contentsOf: url)
    } catch {
        print("Unable to read data from \(url.path)!")
        return nil
    }
}

/// Decodes JSON data into a specified type.
private func decodeJsonData<T: Decodable>(_ data: Data, as type: T.Type) -> T? {
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        print("Unable to decode JSON data. Make sure your struct attributes match the JSON structure.")
        return nil
    }
}

/// A helper property to get the document directory URL.
private var documentDirectory: URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
}
