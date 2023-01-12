//  Project:  
// Created by Jason Stout on 1/11/23.
//
// Using Swift 5.0
// Running on macOS 13.0
// File
//
// "Design is not just what it looks like and feels like. Design is how it works." - Steve Jobs

import FirebaseFunctions

public struct CallableFunctionsService {
    public static func call(_ name: String, data: Any? = nil) async throws -> HTTPSCallableResult {
        return try await Functions.functions().httpsCallable(name).call(data)
    }
}
