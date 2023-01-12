//  Project:  
// Created by Jason Stout on 1/11/23.
//
// Using Swift 5.0
// Running on macOS 13.0
// File
//
// "Design is not just what it looks like and feels like. Design is how it works." - Steve Jobs

import Foundation

public extension Int {
    func MB() -> Int64 {
        Int64(self * 1024 * 1024)
    }
}
