//
//  FileTreeRepresentableTests.swift
//  ReaddleAssignmentTests
//
//  Created by Ahmed Mgua on 19/06/2022.
//

import XCTest
@testable import ReaddleAssignment

struct MockFileTreeRepresentable: FileTreeRepresentable {
    
}

class FileTreeRepresentableTests: XCTestCase {
    var sut: FileTreeRepresentable.Type!
    
    override func setUpWithError() throws {
        sut = MockFileTreeRepresentable.self
    }
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testDecodingFiles() throws {
        let array = FileItem.samples.map { item in
            return [item.id.uuidString, item.parentID?.uuidString ?? "", item.fileType.rawValue, item.name]
        }
        
        let decodedFiles  = sut.decodeFiles(array)
        XCTAssertEqual(decodedFiles[0].id, FileItem.samples[0].id)
    }
    
    func testEncodingFiles() throws {
        let files = FileItem.samples
        let array = sut.encodeFiles(files)
        
        XCTAssertEqual(files[0].id.uuidString, array[0][0])
    }
    
    func testOrganizingFiles() throws {
        let files = FileItem.samples
        let organizedFiles = sut.organize(files)
        
        XCTAssertEqual(organizedFiles.count, 2)
        XCTAssertEqual(organizedFiles[0].children?.count, 3)
    }
}

