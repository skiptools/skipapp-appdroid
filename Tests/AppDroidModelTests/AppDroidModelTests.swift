import XCTest
import Foundation
import Observation
import SkipBridgeKt
@testable import AppDroidModel

@available(macOS 13, *)
final class AppDroidModelTests: XCTestCase {
    override func setUp() {
        #if SKIP
        loadPeerLibrary(packageName: "skipapp-appdroid", moduleName: "AppDroidModel")
        #endif
    }

    func testAppDroidModel() throws {
        // make sure the UserDefaults set/get is shared between view models
        let vm1 = ViewModel()

        vm1.slideSpeed = 0.5
        let vm2 = ViewModel()
        XCTAssertEqual(0.5, vm2.slideSpeed)

        vm1.slideSpeed = 1.0
        let vm3 = ViewModel()
        XCTAssertEqual(1.0, vm3.slideSpeed)
    }

    func testClosure() {
        XCTAssertEqual("value = 1", swiftClosure1Var(1))
    }

    func testObservable() {
        let vm = ViewModel()
        var changes = 0
        XCTAssertEqual(vm.color.values.hue, 0.5)
        #if !SKIP
        let _ = withObservationTracking({ vm.color.values.hue }, onChange: { changes += 1 })
        #endif
        vm.color.values.hue += 0.1
        XCTAssertEqual(vm.color.values.hue, 0.6)
        #if !SKIP
        XCTAssertEqual(changes, 1)
        #endif
    }
}
