import SwiftUI
import AppDroidModel
//import SkipAndroidBridge

struct BridgeView : View {
    @State var viewModel = ViewModel()
    @State var resultMessage: String = ""
    @State var errorMessage: String = ""

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text(viewModel.color.asRGBHexString)
                    .font(.largeTitle.monospaced())
                    .foregroundStyle(viewModel.color.values.brightness < 0.5 && viewModel.color.values.opacity > 0.5 ? Color.white : Color.black)
                Spacer()
            }
            .padding(50.0)
            .background(Color(hue: viewModel.color.values.hue, saturation: viewModel.color.values.saturation, brightness: viewModel.color.values.brightness, opacity: viewModel.color.values.opacity))
            .clipShape(RoundedRectangle(cornerRadius: 10.0))

            Spacer()
            HStack {
                Text("H:")
                Slider(value: $viewModel.color.values.hue, in: 0...1)
                Text(percent(viewModel.color.values.hue))
            }
            HStack {
                Text("S:")
                Slider(value: $viewModel.color.values.saturation, in: 0...1)
                Text(percent(viewModel.color.values.saturation))
            }
            HStack {
                Text("B:")
                Slider(value: $viewModel.color.values.brightness, in: 0...1)
                Text(percent(viewModel.color.values.brightness))
            }
            HStack {
                Text("A:")
                Slider(value: $viewModel.color.values.opacity, in: 0...1)
                Text(percent(viewModel.color.values.opacity))
            }

            Divider()

            HStack {
                Button("Shuffle") {
                    viewModel.randomize()
                }
                .buttonStyle(.borderedProminent)
                Button("Async") {
                    Task { await viewModel.randomizeAsync() }
                }
                .buttonStyle(.bordered)
                .foregroundStyle(.indigo)
                Button("Delay") {
                    viewModel.randomizeDelay()
                }
                .buttonStyle(.bordered)
                .foregroundStyle(.teal)
            }
            .font(.title2.bold())

            HStack {
                Toggle("Auto-slide", isOn: $viewModel.autoSlide)
                Toggle("MainActor", isOn: $viewModel.useMainActor)
            }
            .font(.title2)

            HStack {
                Text("Speed:")
                Slider(value: $viewModel.slideSpeed, in: 0.00...1.0)
            }

            Spacer()

            VStack(spacing: 5) {
                HStack {
                    Button("Parse JSON") {
                        (self.resultMessage, self.errorMessage) = ("", "")
                        do {
                            self.resultMessage = try viewModel.parseSampleResources()
                        } catch {
                            self.errorMessage = error.localizedDescription
                        }
                    }
                    .accessibilityIdentifier("parseJSONButton")
                    .accessibilityLabel("parseJSONButton")
                    .foregroundStyle(Color.blue)

                    Button("HTTP") {
                        (self.resultMessage, self.errorMessage) = ("", "")
                        Task {
                            do {
                                self.resultMessage = "HTTP: " + (try await viewModel.parseRemoteResources(secure: false))
                            } catch {
                                self.errorMessage = error.localizedDescription
                            }
                        }
                    }
                    .foregroundStyle(Color.cyan)

                    Button("HTTPS") {
                        (self.resultMessage, self.errorMessage) = ("", "")
                        Task {
                            do {
                                self.resultMessage = "HTTPS: " + (try await viewModel.parseRemoteResources(secure: true))
                            } catch {
                                self.errorMessage = error.localizedDescription
                            }
                        }
                    }
                    .foregroundStyle(Color.purple)
                }
                .buttonStyle(.bordered)
                .font(.title3)

                HStack {
                    Button("Context") {
                        (self.resultMessage, self.errorMessage) = ("", "")
                        do {
                            let fileURL = viewModel.fileURL()
                            self.resultMessage = "FILES: \(fileURL.path)"
                        } catch {
                            self.errorMessage = error.localizedDescription
                        }
                    }
                    .foregroundStyle(Color.mint)

                    Button("Throw") {
                        (self.resultMessage, self.errorMessage) = ("", "")
                        do {
                            try viewModel.throwError()
                        } catch {
                            self.errorMessage = error.localizedDescription
                        }
                    }
                    .foregroundStyle(Color.orange)

                    Button("Crash") {
                        (self.resultMessage, self.errorMessage) = ("", "")
                        viewModel.crash()
                    }
                    .foregroundStyle(Color.red)
                }
                .buttonStyle(.bordered)
                .font(.title3)
            }

            Text(resultMessage)
                .font(.headline)
                .foregroundStyle(.green)

            Text(errorMessage)
                .font(.headline)
                .foregroundStyle(.red)

            Spacer()
        }
        .padding()
    }
}


func percent(_ number: Double) -> String {
    pfmt.string(from: number as NSNumber)!
}

let pfmt: NumberFormatter = {
    let pfmt = NumberFormatter()
    pfmt.numberStyle = .percent
    return pfmt
}()
