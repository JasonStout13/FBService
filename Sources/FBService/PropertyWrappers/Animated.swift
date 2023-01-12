//  Project:  
// Created by Jason Stout on 1/11/23.
//
// Using Swift 5.0
// Running on macOS 13.0
// File
//
// "Design is not just what it looks like and feels like. Design is how it works." - Steve Jobs

import SwiftUI

@discardableResult
public func animated<Result>(_ animation: Animation? = .default, _ body: () throws -> Result) rethrows -> Result {
    try withAnimation(animation, body)
}
