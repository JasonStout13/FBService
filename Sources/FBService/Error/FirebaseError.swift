//  Project:  
// Created by Jason Stout on 1/11/23.
//
// Using Swift 5.0
// Running on macOS 13.0
// File
//
// "Design is not just what it looks like and feels like. Design is how it works." - Steve Jobs

import Foundation

public enum FirebaseError: Error {
    case somethingWentWrong
    case alreadySignedIn
    case noUid
    case noQuerySnapshot
    case noDocumentSnapshot
    case documentDoesNotExist
    case noAuthDataResult
    case noProfile
    case noImageAvailable
    case noUrl
    case noData
    case noLastDocument
    case failedToDeleteAsset
    case custom(description: String, code: Int)
}

extension FirebaseError {
    public var code: Int {
        switch self {
        case .somethingWentWrong:
            return -1
        case .alreadySignedIn:
            return 0
        case .noUid:
            return 1
        case .noQuerySnapshot:
            return 2
        case .noDocumentSnapshot:
            return 3
        case .documentDoesNotExist:
            return 4
        case .noAuthDataResult:
            return 5
        case .noProfile:
            return 6
        case .noImageAvailable:
            return 7
        case .noUrl:
            return 8
        case .noData:
            return 9
        case .noLastDocument:
            return 10
        case .failedToDeleteAsset:
            return 11
        case .custom(description: _, code: let code):
            return code
        }
    }
}

extension FirebaseError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .somethingWentWrong:
            return "Oops! Something went wrong!"
        case .alreadySignedIn:
            return "Looks like your already signed in!"
        case .noUid:
            return "No UID!"
        case .noQuerySnapshot:
            return "No Query Snapshot!"
        case .noDocumentSnapshot:
            return "No Document Snapshot!"
        case .documentDoesNotExist:
            return "Document Does Not Exist!"
        case .noAuthDataResult:
            return "No Auth Data Result!"
        case .noProfile:
            return "No Profile!"
        case .noImageAvailable:
            return "No Image Available!"
        case .noUrl:
            return "No URL!"
        case .noData:
            return "No Data!"
        case .noLastDocument:
            return "No Last Document!"
        case .failedToDeleteAsset:
            return "Failed To Delete Asset!"
        case .custom(description: let description, code: _):
            return description
        }
    }
}

extension FirebaseError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .somethingWentWrong:
            return NSLocalizedString("Something went wrong.", comment: "Something went wrong")
        case .alreadySignedIn:
            return NSLocalizedString("Already signed in.", comment: "Already signed in")
        case .noUid:
            return NSLocalizedString("No Uid.", comment: "No Uid")
        case .noQuerySnapshot:
            return NSLocalizedString("No query snapshot.", comment: "No query snapshot")
        case .noDocumentSnapshot:
            return NSLocalizedString("No document snapshot.", comment: "No document snapshot")
        case .documentDoesNotExist:
            return NSLocalizedString("Document does not exist.", comment: "Document does not exist")
        case .noAuthDataResult:
            return NSLocalizedString("No auth data result.", comment: "No auth data result")
        case .noProfile:
            return NSLocalizedString("No profile.", comment: "No profile")
        case .noImageAvailable:
            return NSLocalizedString("No image available.", comment: "No image available")
        case .noUrl:
            return NSLocalizedString("No URL.", comment: "No URL")
        case .noData:
            return NSLocalizedString("No data.", comment: "No data")
        case .noLastDocument:
            return NSLocalizedString("No last document.", comment: "No last document")
        case .failedToDeleteAsset:
            return NSLocalizedString("Failed to delete asset.", comment: "Failed to delete asset")
        case .custom(description: let description, code: _):
            return NSLocalizedString(description, comment: description)
        }
    }
}
