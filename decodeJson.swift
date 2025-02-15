//
//  dataRelated.swift
//  ScavenGo
//
//  Created by Michael-Andre Odusami on 2/14/25.
//

import Foundation


/**
Decodes json file data into structs
 - Parameter fullFilename: the name of the file where the json data resides
 - Parameter fileLocation: the bundle the json data resides (most likely "Main Bundle" - the executable that is shipped with the app)
 - Parameter type: the type of data that will be converted and returned
 */
func decodeJsonIntoStruct<T: Decodable>(fullFilename: String, fileLocation: String, as type: T.Type = T.self) -> T?
{
    // depending on the file directory, retrieve the file url
    if fileLocation == "Main Bundle" {
        let mainBundle = Bundle.main
        guard let mainBundleUrlToFile = mainBundle.url(forResource: fullFilename, withExtension: nil) else {
            print("Can't seem to find \(fullFilename) at \(fileLocation).")
            return nil
        }
    
        do {
            let fileData = try Data(contentsOf: mainBundleUrlToFile)
            let jsonDecoder = JSONDecoder()
            return try jsonDecoder.decode(T.self, from: fileData)
        }
        catch {
            print("Couldn't Convert File: \(fullFilename) Into Data")
            return nil
        }
        
    }
    
    return nil
}
