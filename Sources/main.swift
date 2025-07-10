import os

struct Main: App {
    @State var selectedColor: Color?

    var body: some View {
        VStack(spacing: selectedColor != nil ? 1 : 0) {
            Text("This is your last chance. After this, there is no turning back.")
            if let selectedColor {
                Text("The Matrix is everywhere. It is all around us.")
                    .padding(.horizontal, 2)
                    .padding(.vertical, 1)
                    .color(.yellow)
                    .backgroundColor(selectedColor)
            } else {
                HStack {
                    Button("Blue pill") { selectedColor = .blue }
                    // .tint(.blue) // -> Default
                    Button("Red pill") { selectedColor = .red }
                        .tint(.red)
                }
            }
        }
    }
}

// Run the app
let engine = AppEngine(app: CommandLine.arguments.contains("--example") ? Example() : Main())
engine.run()
