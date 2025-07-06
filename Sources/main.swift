import os

struct Main: App {
    @State var isSelected: Bool = false

    var body: some View {
        VStack(spacing: isSelected ? 1 : 0) {
            Text("This is your last chance. After this, there is no turning back.")
            if !isSelected {
                HStack {
                    Button(action: { isSelected = true }) {
                        Text("Blue pill").color(.blue)
                    }
                    Button(action: { isSelected = true }) {
                        Text("Red pill").color(.red)
                    }
                }
            } else {
                Text("The Matrix is everywhere. It is all around us.")
                    .padding(.horizontal, 2)
                    .padding(.vertical, 1)
                    .color(.yellow)
                    .backgroundColor(.black)
            }
        }
    }
}

// Run the app
let engine = AppEngine(app: Example())
engine.run()
