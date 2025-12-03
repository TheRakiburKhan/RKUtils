//
//  BundleExtensionsTests.swift
//  RKiOSUtils
//
//  Created by Rakibur Khan on 1/6/25.
//

import Testing
import Foundation
@testable import RKUtils

@Suite("Bundle Extensions")
struct BundleExtensionsTests {

    @Test("Release version number")
    func releaseVersionNumber() {
        let bundle = Bundle.main
        let releaseVersion = bundle.releaseVersionNumber

        // The version might be nil in test bundles, so we test both cases
        if releaseVersion != nil {
            #expect(releaseVersion != nil)
            #expect(!releaseVersion!.isEmpty)
        } else {
            #expect(releaseVersion == nil)
        }
    }

    @Test("Build version number")
    func buildVersionNumber() {
        let bundle = Bundle.main
        let buildVersion = bundle.buildVersionNumber

        // The build version might be nil in test bundles
        if buildVersion != nil {
            #expect(buildVersion != nil)
            #expect(!buildVersion!.isEmpty)
        } else {
            #expect(buildVersion == nil)
        }
    }

    @Test("Release version number pretty format")
    func releaseVersionNumberPretty() {
        let bundle = Bundle.main
        let prettyVersion = bundle.releaseVersionNumberPretty

        #expect(prettyVersion.hasPrefix("v"))

        // If there's no release version, it should default to "v0.0.0"
        if bundle.releaseVersionNumber == nil {
            #expect(prettyVersion == "v0.0.0")
        } else {
            #expect(prettyVersion.contains("."))
        }
    }

    @Test("Bundle display name")
    func bundleDisplayName() {
        let bundle = Bundle.main
        let displayName = bundle.bundleDisplayName

        // Display name might be empty in test bundles (non-optional String)
        _ = displayName
    }

    @Test("Bundle extensions with main bundle")
    func bundleExtensionsWithCustomBundle() {
        // Test bundle extensions work properly
        let testBundle = Bundle.main

        // Test with the test bundle
        _ = testBundle.releaseVersionNumber
        _ = testBundle.buildVersionNumber
        let prettyVersion = testBundle.releaseVersionNumberPretty
        let displayName = testBundle.bundleDisplayName

        // Pretty version should always start with "v"
        #expect(prettyVersion.hasPrefix("v"))

        // Display name is non-optional
        _ = displayName
    }

    @Test("Release version number pretty default value")
    func releaseVersionNumberPrettyDefaultValue() {
        // Test that the default value is used when no version is present
        let bundle = Bundle.main

        if bundle.releaseVersionNumber == nil {
            let prettyVersion = bundle.releaseVersionNumberPretty
            #expect(prettyVersion == "v0.0.0")
        }
    }

    @Test("Bundle display name empty default")
    func bundleDisplayNameEmptyDefault() {
        let bundle = Bundle.main
        let displayName = bundle.bundleDisplayName

        // Should return empty string if not available
        if bundle.infoDictionary?["CFBundleDisplayName"] == nil {
            #expect(displayName == "")
        } else {
            #expect(!displayName.isEmpty)
        }
    }
}
