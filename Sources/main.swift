import os

struct Example: App {
    var body: some View {
        // ExampleContainerView()
        ExampleContainerView()
    }
}

struct ExampleContainerView: View {
    var body: some View {
        ExampleContentView()
    }
}

struct ExampleContentView: View {
    @State var thisOrThat: Bool = false
    var body: some View {
        Button(
            action: {
                thisOrThat.toggle()
            },
            label: {
                Text("Button")
            })
        if thisOrThat {
            ThisView()
        } else {
            ThatView()
        }
    }
}

struct ThisView: View {
    @State var counter: Int = 0

    var body: some View {
        Button(
            action: { counter += 1 },
            label: {
                Text("This")
            })
        Text("\(counter)")
    }
}

struct ThatView: View {
    @State var counter: Int = 0

    var body: some View {
        Button(
            action: { counter += 1 },
            label: {
                Text("That")
            })
        Text("\(counter)")
    }
}

struct InnerView: View {
    var body: some View = Text("Hello, World!")
}

let engine = AppEngine(app: Example())
engine.run()
