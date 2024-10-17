import XCTest
import SkipBridge
@testable import AppDroidModel

@available(macOS 13, *)
final class AppDroidModelTests: XCTestCase {
    override func setUp() {
        #if SKIP
        loadPeerLibrary(packageName: "skipapp-appdroid", moduleName: "AppDroidModel")
        #endif
    }

    func testAppDroidModel() throws {
        #if SKIP
        XCTAssertEqual("/", getJavaSystemProperty("file.separator"))
        #else
        throw XCTSkip("getJavaSystemProperty only works in transpiled test")
        #endif
    }

    func testClosure() {
        XCTAssertEqual("value = 1", swiftClosure1Var(1))
    }
}
