//
//  URLExtensionsTests.swift
//  RKUtils
//
//  Created by Rakibur Khan on 2/4/24.
//

import Testing
import Foundation
@testable import RKUtils

@Suite("URL Extensions")
struct URLExtensionsTests {

    // MARK: - readFromFile

    @Test("Read from file returns content")
    func readFromFileReturnsContent() throws {
        let testString = "Test content for file I/O"
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("rkutils_test_read.txt")

        try? FileManager.default.removeItem(at: fileURL)
        testString.writeToFile(saveLocation: fileURL)

        let result = fileURL.readFromFile()
        #expect(result == testString)

        try? FileManager.default.removeItem(at: fileURL)
    }

    @Test("Read from non-existent file returns nil")
    func readFromNonExistentFileReturnsNil() {
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("rkutils_no_such_file.txt")
        try? FileManager.default.removeItem(at: fileURL)
        #expect(fileURL.readFromFile() == nil)
    }
}
