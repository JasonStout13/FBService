//  Project:  
// Created by Jason Stout on 1/11/23.
//
// Using Swift 5.0
// Running on macOS 13.0
// File
//
// "Design is not just what it looks like and feels like. Design is how it works." - Steve Jobs

import FirebaseFirestore

extension Timestamp: Comparable {
    public static func < (lhs: Timestamp, rhs: Timestamp) -> Bool {
        if lhs.seconds != rhs.seconds {
            return lhs.seconds < rhs.seconds
        } else {
            return lhs.nanoseconds < rhs.nanoseconds
        }
    }
    
    public static func <= (lhs: Timestamp, rhs: Timestamp) -> Bool {
        if lhs.seconds != rhs.seconds {
            return lhs.seconds <= rhs.seconds
        } else {
            return lhs.nanoseconds <= rhs.nanoseconds
        }
    }

    public static func > (lhs: Timestamp, rhs: Timestamp) -> Bool {
        if lhs.seconds != rhs.seconds {
            return lhs.seconds > rhs.seconds
        } else {
            return lhs.nanoseconds > rhs.nanoseconds
        }
    }

    public static func >= (lhs: Timestamp, rhs: Timestamp) -> Bool {
        if lhs.seconds != rhs.seconds {
            return lhs.seconds >= rhs.seconds
        } else {
            return lhs.nanoseconds >= rhs.nanoseconds
        }
    }

    public static func == (lhs: Timestamp, rhs: Timestamp) -> Bool {
        return lhs.seconds == rhs.seconds && lhs.nanoseconds == rhs.nanoseconds
    }
}
