import SwiftUI
import AppDroidModel

struct BridgeView : View {
    @State var viewModel = ViewModel()
    @State var sliding = false
    @State var slideSpeed = 0.01

    var body: some View {
        VStack {
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

            HStack {
                Spacer()
                Text("HSL: \(percent(viewModel.color.hsl.reduce(0.0, +) / 4.0))")
                    .font(.largeTitle)
                    .foregroundStyle(viewModel.color.values.brightness < 0.5 && viewModel.color.values.opacity > 0.5 ? Color.white : Color.black)
                Spacer()
            }
            .padding(50.0)
            .background(Color(hue: viewModel.color.values.hue, saturation: viewModel.color.values.saturation, brightness: viewModel.color.values.brightness, opacity: viewModel.color.values.opacity))
            .clipShape(RoundedRectangle(cornerRadius: 10.0))

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

            HStack {
                Toggle("Auto-slide", isOn: $sliding)
                    .onChange(of: sliding) {
                        slideOnMain()
                    }
                Slider(value: $slideSpeed, in: 0.00...0.1)
            }
            .font(.title2)

            Spacer()

            Spacer()
        }
        .padding()
    }

    /// Keep sliding for as long as the `sliding` property is true.
    func slideOnMain() {
        if self.sliding {
            DispatchQueue.main.asyncAfter(deadline: .now() + slideSpeed) {
                //viewModel.slideValues(after: 0.1) // not working on Anrdoid
                viewModel.slideValues()
                slideOnMain()
            }
        }
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
