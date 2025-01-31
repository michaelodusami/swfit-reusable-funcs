//
//  util.swift
//
//  Created by Michael-Andre Odusami on 1/31/25.
//  Copyright © 2025 Michael-Andre Odusami. All rights reserved.
//

import Foundation
import SwiftUI

/*
************************
MARK: Decode Json Into Struct
************************
*/
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

/*
************************
MARK: Get Json File From URL
************************
*/
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

/*
************************
MARK: Read Data From Given File
************************
*/
private func readData(from url: URL) -> Data? {
    do {
        return try Data(contentsOf: url)
    } catch {
        print("Unable to read data from \(url.path)!")
        return nil
    }
}

/*
************************
MARK: Decode Json Data Into Specific Type
************************
*/
private func decodeJsonData<T: Decodable>(_ data: Data, as type: T.Type = T.self ) -> T? {
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        print("Unable to decode JSON data. Make sure your struct attributes match the JSON structure.")
        return nil
    }
}
