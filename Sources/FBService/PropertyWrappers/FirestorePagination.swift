//  Project:  
// Created by Jason Stout on 1/11/23.
//
// Using Swift 5.0
// Running on macOS 13.0
// File
//
// "Design is not just what it looks like and feels like. Design is how it works." - Steve Jobs

import FirebaseFirestore
import Foundation

public struct FirestorePagination<U: Codable & Firestorable & Equatable, C: Comparable> {
    public let orderBy: String
    public let descending: Bool
    public let limit: Int
    public let sortedBy: ((U, U) throws -> Bool)
    
    public init(orderBy: String,
                type: C.Type,
                descending: Bool,
                limit: Int) {
        self.orderBy = orderBy
        self.descending = descending
        self.limit = limit
        if type == Timestamp.self {
            self.sortedBy = { comparable0, comparable1 in
                guard let predicateSeconds0 = (comparable0.dictionary?[orderBy] as? [String: Int])?["seconds"],
                      let predicateSeconds1 = (comparable1.dictionary?[orderBy] as? [String: Int])?["seconds"],
                      let predicateNanoseconds0 = (comparable0.dictionary?[orderBy] as? [String: Int])?["nanoseconds"],
                      let predicateNanoseconds1 = (comparable1.dictionary?[orderBy] as? [String: Int])?["nanoseconds"]
                else { return false }
                
                if predicateSeconds0 == predicateSeconds1 {
                    if descending {
                        return predicateNanoseconds0 > predicateNanoseconds1
                    } else {
                        return predicateNanoseconds0 < predicateNanoseconds1
                    }
                } else {
                    if descending {
                        return predicateSeconds0 > predicateSeconds1
                    } else {
                        return predicateSeconds0 < predicateSeconds1
                    }
                }
            }
        } else if type == Date.self {
            self.sortedBy = { comparable0, comparable1 in
                guard let predicate0 = comparable0.dictionary?[orderBy] as? Double,
                      let predicate1 = comparable1.dictionary?[orderBy] as? Double
                else { return false }
                
                if descending {
                    return predicate0 > predicate1
                } else {
                    return predicate0 < predicate1
                }
            }
        } else {
            self.sortedBy = { comparable0, comparable1 in
                guard let predicate0 = comparable0.dictionary?[orderBy] as? C,
                      let predicate1 = comparable1.dictionary?[orderBy] as? C
                else { return false }
                
                if descending {
                    return predicate0 > predicate1
                } else {
                    return predicate0 < predicate1
                }
            }
        }
    }
    
}
