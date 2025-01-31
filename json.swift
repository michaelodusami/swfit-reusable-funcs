/* Decodes a JSON file into an array of structs of type `T`.
///
/// This method reads a JSON file from either the main bundle or the document directory and decodes the file's contents into an array of structs that conform to the `Decodable` protocol.
///
/// - Parameters:
///   - fullFileName: The name of the JSON file to decode. This should include the file extension (e.g., "data.json").
///   - fileLocation: A string specifying the location of the file. Supported values:
///     - `"Main Bundle"`: The file is located in the main app bundle.
///     - `"Document Directory"`: The file is located in the app's document directory.
///   - type: The type of the struct to decode the JSON into. This defaults to `T.self`.
///
/// - Returns: An array of structs of type `T` representing the data in the JSON file.
/// 
/// - Important:
///   The struct type `T` must conform to the `Decodable` protocol, and its properties must match the keys and structure of the JSON file.
///   If the JSON file or its content is invalid, or if the attribute names in `T` do not match the keys in the JSON, the method will print an error message and force unwrap a potentially `nil` value, causing a runtime crash.
///
/// - Example Usage:
/// ```swift
/// struct User: Decodable {
///     let id: Int
///     let name: String
/// }
///
/// if let users: [User] = decodeJsonFileIntoArrayStruct(fullFileName: "users.json", fileLocation: "Main Bundle") {
///     print(users)
/// } else {
///     print("Failed to decode JSON.")
/// }
/// ```
///
/// - Note: This method force unwraps the optional values during data reading and decoding. Consider refactoring to use safer optional handling to avoid runtime crashes.
*/   
public func decodeJsonFileIntoArrayStruct<T: Decodable>(fullFileName: String, fileLocation: String, as type: T.Type = T.self) -> T {
    
    var jsonFileData: Data?
    var jsonFileUrl: URL?
    var arrayOfStructs: T?
    
    // Get the URL of the JSON file based on its location
    if fileLocation == "Main Bundle" {
        let urlOfJsonFileInMainBundle: URL? = Bundle.main.url(forResource: fullFileName, withExtension: nil)
        
        if let mainBundleUrl = urlOfJsonFileInMainBundle {
            jsonFileUrl = mainBundleUrl
        } else {
            print("JSON file \(fullFileName) does not exist in main bundle!")
        }
        
    } else {
        let urlOfJsonFileInDocumentDirectory: URL? = documentDirectory.appendingPathComponent(fullFileName)
        
        if let docDirectoryUrl = urlOfJsonFileInDocumentDirectory {
            jsonFileUrl = docDirectoryUrl
        } else {
            print("JSON file \(fullFileName) does not exist in document directory!")
        }
    }
    
    // Try to load the JSON data from the file
    do {
        jsonFileData = try Data(contentsOf: jsonFileUrl!)
    } catch {
        print("Unable to obtain JSON file \(fullFileName) content!")
    }
    
    // Try to decode the data into an array of structs
    do {
        let decoder = JSONDecoder()
        arrayOfStructs = try decoder.decode(T.self, from: jsonFileData!)
    } catch {
        print("Unable to decode JSON file \(fullFileName) because your struct attribute names do not exactly match the JSON file attribute names!")
    }
    
    // Return the decoded array of structs (force unwrapped)
    return arrayOfStructs!
}

