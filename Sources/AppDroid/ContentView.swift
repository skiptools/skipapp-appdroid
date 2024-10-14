// This is free software: you can redistribute and/or modify it
// under the terms of the GNU General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import SwiftUI

public struct ContentView: View {
    @AppStorage("tab") var tab = Tab.bridge
    @State var appearance = ""

    public init() {
    }

    public var body: some View {
        TabView(selection: $tab) {
            BridgeView()
                .tabItem { Label("Bridge", image: "bridge") }
                .tag(Tab.bridge)

            NavigationStack {
                List {
                    ForEach(1..<1_000) { i in
                        NavigationLink("Item \(i)", value: i)
                    }
                }
                .navigationTitle("List")
                .navigationDestination(for: Int.self) { i in
                    Text("Item \(i)")
                        .font(.title)
                        .navigationTitle("Screen \(i)")
                }
            }
            .tabItem { Label("List", systemImage: "list.bullet") }
            .tag(Tab.list)

            NavigationStack {
                Form {
                    Picker("Appearance", selection: $appearance) {
                        Text("System").tag("")
                        Text("Light").tag("light")
                        Text("Dark").tag("dark")
                    }
                    HStack {
                        #if SKIP
                        ComposeView { ctx in // Mix in Compose code!
                            androidx.compose.material3.Text("💚", modifier: ctx.modifier)
                        }
                        #else
                        Text(verbatim: "💙")
                        #endif
                        Text("Powered by \(androidSDK != nil ? "Jetpack Compose" : "SwiftUI")")
                    }
                    .foregroundStyle(.gray)
                }
                .navigationTitle("Settings")
            }
            .tabItem { Label("Settings", systemImage: "gearshape.fill") }
            .tag(Tab.settings)
        }
        .preferredColorScheme(appearance == "dark" ? .dark : appearance == "light" ? .light : nil)
    }
}

enum Tab : String, Hashable {
    case bridge, list, settings
}
