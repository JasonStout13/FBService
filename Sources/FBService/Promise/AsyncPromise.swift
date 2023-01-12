//  Project:  
// Created by Jason Stout on 1/11/23.
//
// Using Swift 5.0
// Running on macOS 13.0
// File
//
// "Design is not just what it looks like and feels like. Design is how it works." - Steve Jobs

import Combine

public struct AsyncPromise<T> {
    @MainActor
    @discardableResult
    public static func fulfill(_ promise: Future<T, Error>, storedIn cancellables: inout Set<AnyCancellable>) async throws -> T {
        try await withCheckedContinuation({ continuation in
            promise.sink { result in
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            } receiveValue: { value in
                continuation.resume(returning: value)
            }
            .store(in: &cancellables)
        })
    }
}
