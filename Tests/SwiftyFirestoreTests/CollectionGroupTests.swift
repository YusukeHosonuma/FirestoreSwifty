//
//  CollectionGroupTests.swift
//  SwiftyFirestoreTests
//
//  Created by Yusuke Hosonuma on 2020/04/08.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

import XCTest
@testable import SwiftyFirestore
import FirebaseFirestore

class CollectionGroupTests: FirestoreTestCase {

    override func setUp() {
        super.setUp()
        
        // Data:
        //
        // 📚 "account": <📒 AccountDocument> [
        //   "YusukeHosonuma" {
        //     📚 "repository": <📕 RepositoryDocument> [
        //       <id> {
        //         name: "SwiftyFirestore",
        //         language: "swift"
        //       },
        //     ]
        //   },
        //   "penginmura" {
        //     📚 "repository": <📕 RepositoryDocument> [
        //       <id> {
        //         name: "iosdc18-cfp-search",
        //         language: "HTML"
        //       },
        //       <id> {
        //         name: "iosdc18-cfp-search-ios",
        //         language: "swift"
        //       }
        //     ]
        //   }
        // ]
        //
        
        // 🔧 Setup
        Firestore.root
            .account(id: "YusukeHosonuma")
            .repository
            .add(RepositoryDocument(name: "SwiftyFirestore", language: "swift"))

        [
            RepositoryDocument(name: "iosdc18-cfp-search", language: "HTML"),
            RepositoryDocument(name: "iosdc18-cfp-search-ios", language: "swift"),
        ]
        .forEach {
            Firestore.root
                .account(id: "penginmura")
                .repository
                .add($0)
        }
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: - Swifty 🐤
    
    func testSwifty() throws {
        defer { waitExpectations() } // ⏳

        wait { exp in
            Firestore
                .collectionGroup
                .repository
                .whereBy(.language, "==", "swift")
                .orderBy(.name)
                .getAll { result in
                    guard case .success(let documents) = result else { XCTFail(); return } // ✅
                    
                    self.assertDocuments(documents)
                    exp.fulfill() // ⏱
                }
        }
    }

    // MARK: - Firestore 🔥
    
    func testFirestore() throws {
        defer { waitExpectations() } // ⏳

        wait { exp in
            Firestore.firestore()
                .collectionGroup("repository")
                .whereField("language", isEqualTo: "swift")
                .order(by: "name")
                .getDocuments { snapshot, error in
                    guard let snapshot = snapshot else { XCTFail(); return } // ✅
                    
                    let documents = snapshot.documents.compactMap {
                        try? Firestore.Decoder().decode(RepositoryDocument.self, from: $0.data())
                    }
                    
                    self.assertDocuments(documents)
                    exp.fulfill() // ⏱
                }
        }
    }
    
    // MARK: - Helper
    
    func assertDocuments(_ documents: [RepositoryDocument], file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(documents.count, 2, file: file, line: line)
        XCTAssertEqual(documents[0].name, "SwiftyFirestore", file: file, line: line)
        XCTAssertEqual(documents[1].name, "iosdc18-cfp-search-ios", file: file, line: line)
    }
}
