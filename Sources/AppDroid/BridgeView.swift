// This is free software: you can redistribute and/or modify it
// under the terms of the GNU General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import SwiftUI
import AppDroidModel

/// The number of time body is called; intentionally a global variable and not @State because it is updated from within the `var body`
var bodyCount = 0

// TODO: implement bridged @Observable and make this a @State property
let observableFacade = ObservableFacade()

struct BridgeView : View {
    @State var callbackCount: Int = 0
    @State var callbackState: String = ""
    @State var sliderValue = 50.0
    @State var observedSliderValue = 50.0

    // TODO: implement bridged @Observable
    //@State var observableClass = ObservableClass()

    var body: some View {
        // track the number of body executions
        let _ = { bodyCount += 1 }()
        VStack {
            HStack {
                Spacer()
                Text("Bridge to \(callingEnvironment()): \(bodyCount)")
                Spacer()
            }
                .font(.title2)
                .bold()
                .foregroundStyle(Color.white)
                .background(Color.blue)

            Spacer()

            Text("Emoji: \(bridgedString)")
                .font(.title)

            Text("System Property:")
                .font(.title)

            // Kotlin->Swift->Kotlin sample
            Text(getJavaSystemPropertyViaSwift(name: "java.io.tmpdir") ?? "none")
                .font(.body)
                .monospaced()

            Button("Callback: \(callbackState)") {
                self.callbackCount += 1
                self.callbackState = swiftClosure1Var(callbackCount)
            }
            .buttonStyle(.borderedProminent)
            .font(.title)

            Slider(value: $sliderValue, in: 0...100)
            HStack {
                Text("Observed: \(Int64(observedSliderValue))")
                Spacer()
                Text("Current: \(Int64(sliderValue))")
            }

            Spacer()
        }
        .padding()
        .onAppear {
            // setup the facade to call `withObservationTracking` with a callback that updates the local observedSliderValue state
            observableFacade.callback = { d in
                self.observedSliderValue = d
            }
        }
        .onChange(of: sliderValue) { oldValue, newValue in
            // update the observableFacade, which will update its internally-help ObservableInstance, which will trigger the observation callback
            observableFacade.doubleVar = newValue
        }
    }
}
