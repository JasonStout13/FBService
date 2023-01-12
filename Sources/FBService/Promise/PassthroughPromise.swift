//  Project:  
// Created by Jason Stout on 1/11/23.
//
// Using Swift 5.0
// Running on macOS 13.0
// File
//
// "Design is not just what it looks like and feels like. Design is how it works." - Steve Jobs

import Combine
import Foundation

public struct PassthroughPromise<T> {
    public static func fulfill(_ promise: PassthroughSubject<T, Error>, storedIn cancellables: inout Set<AnyCancellable>, completion: @escaping (Result<T, Error>) -> ()) {
        promise.sink { result in
            switch result {
            case .finished:
                break
            case .failure(let err):
                DispatchQueue.main.async {
                    completion(.failure(err))
                }
            }
        } receiveValue: { value in
            DispatchQueue.main.async {
                completion(.success(value))
            }
        }
        .store(in: &cancellables)
    }
}
