import os

struct Example: App {
    var body: some View {
        ExampleContainerView()
        ExampleContainerView()
    }
}

struct ExampleContainerView: View {
    var body: some View {
        ExampleContentView()
    }
}

struct ExampleContentView: View {
    var body: some View {
        Button(
            action: {
                _ = []
            },
            label: {
                Text("Button")
            })
        Text("This")
        Text("Is")
        Text("A")
        Text("VStack")
    }
}

struct InnerView: View {
    var body: some View = Text("Hello, World!")
}

let engine = AppEngine(app: Example())
engine.run()
