//
//  CollectionRefTests.swift
//  SwiftyFirestoreTests
//
//  Created by Yusuke Hosonuma on 2020/04/06.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

import Foundation

import XCTest
@testable import SwiftyFirestore
import Firebase
import FirebaseFirestore

final class CollectionRefeTests: FirestoreTestCase {
    
    let documents = [
        TodoDocument(documentId: nil, title: "Apple",  done: true, priority: 3),
        TodoDocument(documentId: nil, title: "Banana", done: true, priority: 2),
        TodoDocument(documentId: nil, title: "Banana", done: true, priority: 1),
    ]
    
    override func setUp() {
        super.setUp()
        
        // 🔨
        for document in documents {
            Firestore.root.todos.add(document)
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testOrder() {
        defer { waitExpectations() } // ⏳
        
        // 🔼 ascending
        wait { exp in
            Firestore.root
                .todos
                .orderBy(.priority, sort: .ascending)
                .getAll { result in
                    guard case .success(let documents) = result else { XCTFail(); return } // ✅
                    XCTAssertEqual(documents.map { $0.priority }, [1, 2, 3])
                    exp.fulfill() // ⏰
                }
        }

        // 🔽 descending
        wait { exp in
            Firestore.root
                .todos
                .orderBy(.priority, sort: .descending)
                .getAll { result in
                    guard case .success(let documents) = result else { XCTFail(); return } // ✅
                    XCTAssertEqual(documents.map { $0.priority }, [3, 2, 1])
                    exp.fulfill() // ⏰
                }
        }

        // ➕ combination
        wait { exp in
            Firestore.root
                .todos
                .orderBy(.title, sort: .ascending)
                .orderBy(.priority, sort: .ascending)
                .getAll { result in
                    guard case .success(let documents) = result else { XCTFail(); return } // ✅
                    XCTAssertEqual(documents.map { $0.priority }, [3, 1, 2])
                    exp.fulfill() // ⏰
                }
        }
    }
    
    func testLimit() {
        defer { waitExpectations() } // ⏳

        // ⤴️ limit(to:)
        wait { exp in
            Firestore.root
                .todos
                .orderBy(.priority, sort: .ascending)
                .limitTo(2)
                .getAll { result in
                    guard case .success(let documents) = result else { XCTFail(); return } // ✅
                    XCTAssertEqual(documents.map { $0.priority }, [1, 2])
                    exp.fulfill() // ⏳
                }
        }
        
        // ⤴️ limit(toLast:)
        wait { exp in
            Firestore.root
                .todos
                .orderBy(.priority, sort: .ascending)
                .limitToLast(2)
                .getAll { result in
                    guard case .success(let documents) = result else { XCTFail(); return } // ✅
                    XCTAssertEqual(documents.map { $0.priority }, [2, 3])
                    exp.fulfill() // ⏳
                }
        }
    }
}
