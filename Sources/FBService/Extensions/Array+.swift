//  Project:  
// Created by Jason Stout on 1/11/23.
//
// Using Swift 5.0
// Running on macOS 13.0
// File
//
// "Design is not just what it looks like and feels like. Design is how it works." - Steve Jobs

import Foundation

public extension Array where Element: Codable & Firestorable & Equatable {
    @discardableResult
    mutating func append(_ document: Element, collectionPath: String, sortedBy areInIncreasingOrder: ((Element, Element) throws -> Bool)) throws -> Array  {
        let newElement = try FirestoreViewContext.create(document, collectionPath: collectionPath)
        self.append(newElement)
        self = Array(self.uniqued(on: { document in
            document.uid
        }))
        self = try self.sorted(by: areInIncreasingOrder)
        return self
    }
    
    @discardableResult
    mutating func delete(_ document: Element, collectionPath: String) throws -> Array {
        try FirestoreViewContext.delete(document, collectionPath: collectionPath)
        if let index = self.firstIndex(of: document) {
            self.remove(at: index)
        }
        return self
    }
    
    @discardableResult
    mutating func update(_ document: Element, with newDocument: Element, collectionPath: String) throws -> Array {
        let newElement = try FirestoreViewContext.update(newDocument, collectionPath: collectionPath)
        if let index = self.firstIndex(of: document) {
            self[index] = newElement
        }
        return self
    }
}
