//
//  TodoDocument.swift
//  SwiftyFirestore
//
//  Created by Yusuke Hosonuma on 2020/04/02.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

import SwiftyFirestore
import FirebaseFirestore

struct TodoDocument: FirestoreDocument, Equatable {
    static let collectionID: String = "todos"
    
    var documentID: String!
    var title: String
    var done: Bool
    var priority: Int = 0
    var tags: [String] = []
    var remarks: String?
    var lastUpdated: Timestamp?
    var info: [String: String]? // TODO: can use struct?

    enum CodingKeys: String, CodingKey {
        case documentID
        case title
        case done
        case priority
        case tags
        case remarks
        case lastUpdated
        case info
    }
}

struct AccountDocument: FirestoreDocument, Equatable {
    static let collectionID: String = "account"

    var documentID: String!
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case documentID
        case name
    }
}

struct RepositoryDocument: FirestoreDocument, Equatable {
    static let collectionID: String = "repository"

    var documentID: String!
    var name: String
    var language: String // TODO: enum
    
    enum CodingKeys: String, CodingKey {
        case documentID
        case name
        case language
    }
}

struct GistDocument: FirestoreDocument {
    static let collectionID: String = "gist"

    var documentID: String!
    var url: String
    var account: DocumentRef<AccountDocument>
    
    enum CodingKeys: String, CodingKey {
        case documentID
        case url
        case account
    }
}
