//  Project:  
// Created by Jason Stout on 1/11/23.
//
// Using Swift 5.0
// Running on macOS 13.0
// File
//
// "Design is not just what it looks like and feels like. Design is how it works." - Steve Jobs

import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

/// A property wrapper that fetches a Firestore collection.
@propertyWrapper
public struct FirestoreFetch<T, U: Codable & Firestorable & Equatable, C: Comparable>: DynamicProperty {
    @StateObject public var manager: FirestoreFetchManager<T, U, C>
    
    /// The query's configurable properties.
    public struct Configuration<U> {
        /// The query's collection path.
        public var path: String
        
        /// The query's orderBy predicate
        public var sortedBy: ((U, U) throws -> Bool)
        
        /// The query's predicates.
        public var predicates: [QueryPredicate]
        
        // The strategy to use in case there was a problem during the decoding phase.
        public var decodingFailureStrategy: DecodingFailureStrategy = .raise
        
        /// If any errors occurred, they will be exposed here as well.
        public var error: Error?
        
    }
    
    public var wrappedValue: T {
        get {
            manager.value
        }
        nonmutating set {
            manager.value = newValue
        }
    }
    
    public var projectedValue: Binding<T> {
        Binding(
            get: {
                wrappedValue
            },
            set: {
                wrappedValue = $0
            }
        )
    }
    
    /// A binding to the request's mutable configuration properties
    public var configuration: Configuration<U> {
        get {
            manager.configuration
        }
        nonmutating set {
            manager.objectWillChange.send()
            manager.configuration = newValue
        }
    }
    
    /// Creates an instance by defining a query based on the parameters.
    /// - Parameters:
    ///   - collectionPath: The path to the Firestore collection to query.
    ///   - sort: Sets the sort of the query. Defaults to `nil`.
    ///   - predicates: An optional array of `QueryPredicate`s that defines a
    ///     filter for the fetched results.
    ///   - decodingFailureStrategy: The strategy to use when there is a failure
    ///     during the decoding phase. Defaults to `DecodingFailureStrategy.raise`.
    public init(_ collectionPath: String,
                sort: FirestoreSort<U, C>,
                predicates: [QueryPredicate] = [],
                decodingFailureStrategy: DecodingFailureStrategy = .raise) where T == [U] {
        var predicates = predicates
        predicates.append(.order(by: sort.orderBy, descending: sort.descending))
        let configuration = Configuration(
            path: collectionPath,
            sortedBy: sort.sortedBy,
            predicates: predicates,
            decodingFailureStrategy: decodingFailureStrategy
        )
        _manager = StateObject(wrappedValue: FirestoreFetchManager<T, U, C>(configuration: configuration))
    }
}

final public class FirestoreFetchManager<T, U: Codable & Firestorable & Equatable, C: Comparable>: ObservableObject {
    
    @Published public var value: T
    
    private let firestore = Firestore.firestore()
    
    private var setupQuery: (() -> Void)!
    
    internal var shouldUpdateQuery = true
    internal var configuration: FirestoreFetch<T, U, C>.Configuration<U> {
        didSet {
            // prevent never-ending update cycle when updating the error field
            guard shouldUpdateQuery else { return }
            setupQuery()
        }
    }
    
    public init(configuration: FirestoreFetch<T, U, C>.Configuration<U>) where T == [U] {
        self.value = [U]()
        self.configuration = configuration
        
        fetch()
    }
    
    /// Fetches the values.
    public func fetch() where T == [U] {
        setupQuery = createQuery { [weak self] result in
            switch result {
            case .success(let querySnapshot):
                guard let documents = querySnapshot?.documents else {
                    withAnimation {
                        self?.value = []
                    }
                    return
                }
                
                let decodedDocuments: [U] = documents.compactMap { queryDocumentSnapshot in
                    let result = Result { try queryDocumentSnapshot.data(as: U.self) }
                    switch result {
                    case let .success(decodedDocument):
                        return decodedDocument
                    case let .failure(error):
                        self?.projectError(error)
                        return nil
                    }
                }
                
                if self?.configuration.error != nil {
                    if self?.configuration.decodingFailureStrategy == .raise {
                        withAnimation {
                            self?.value = []
                        }
                    } else {
                        withAnimation {
                            self?.value = decodedDocuments
                        }
                    }
                } else {
                    withAnimation {
                        self?.value = decodedDocuments
                    }
                }
                
            case .failure(let error):
                withAnimation {
                    self?.value = []
                    self?.projectError(error)
                }
            }
        }
        setupQuery()
    }
    
    private func getQuery() -> Query {
        var query: Query = self.firestore.collection(self.configuration.path)
        
        for predicate in self.configuration.predicates {
            switch predicate {
            case let .isEqualTo(field, value):
                query = query.whereField(field, isEqualTo: value)
            case let .isIn(field, values):
                query = query.whereField(field, in: values)
            case let .isNotIn(field, values):
                query = query.whereField(field, notIn: values)
            case let .arrayContains(field, value):
                query = query.whereField(field, arrayContains: value)
            case let .arrayContainsAny(field, values):
                query = query.whereField(field, arrayContainsAny: values)
            case let .isLessThan(field, value):
                query = query.whereField(field, isLessThan: value)
            case let .isGreaterThan(field, value):
                query = query.whereField(field, isGreaterThan: value)
            case let .isLessThanOrEqualTo(field, value):
                query = query.whereField(field, isLessThanOrEqualTo: value)
            case let .isGreaterThanOrEqualTo(field, value):
                query = query.whereField(field, isGreaterThanOrEqualTo: value)
            case let .orderBy(field, value):
                query = query.order(by: field, descending: value)
            case let .limitTo(field):
                query = query.limit(to: field)
            case let .limitToLast(field):
                query = query.limit(toLast: field)
            }
        }
        return query
    }
    
    private func createQuery(with completion: @escaping (Result<QuerySnapshot?, Error>) -> Void)
    -> () -> Void {
        return {
            self.getQuery().getDocuments { querySnapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(querySnapshot))
            }
        }
    }
    
    private func projectError(_ error: Error?) {
        shouldUpdateQuery = false
        configuration.error = error
        shouldUpdateQuery = true
    }
    
    /// Creates a new element.
    /// - Parameters:
    ///   - element: An element to be created.
    public func create(_ element: U) throws where T == [U] {
        try animated {
            try value.append(element, collectionPath: configuration.path, sortedBy: configuration.sortedBy)
        }
    }
    
    /// Deletes an element.
    /// - Parameter element: The element to be deleted.
    public func delete(_ element: U) throws where T == [U] {
        try animated {
            try value.delete(element, collectionPath: configuration.path)
        }
    }
    
    /// Updates an element.
    /// - Parameters:
    ///   - element: An element to be updated.
    ///   - newElement: The updated element.
    public func update(_ element: U, with newElement: U) throws where T == [U] {
        try animated {
            try value.update(element, with: newElement, collectionPath: configuration.path)
        }
    }
}

