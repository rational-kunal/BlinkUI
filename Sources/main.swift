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
    @State var counter = 0
    var body: some View {
        Button(
            action: {
                counter += 1
            },
            label: {
                Text("Button")
            })
        Text("Counter: \(counter)")
    }
}

struct InnerView: View {
    var body: some View = Text("Hello, World!")
}

let engine = AppEngine(app: Example())
engine.run()
