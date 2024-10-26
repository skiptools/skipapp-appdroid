import SwiftUI
import AppDroidModel

struct BridgeView : View {
    @State var viewModel = ViewModel()

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
                Button("Shuffle (Async)") {
                    Task { await viewModel.randomizeAsync() }
                }
                .buttonStyle(.bordered)
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
            Button("Crash!") {
                viewModel.crash()
            }
            .buttonStyle(.bordered)
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
