import os

struct Example: App {
    @State var isSelected: Bool = false

    var body: some View {
        // HStack(alignment: .top) {
        //     Text("Hello")
        //     Text("World")
        //     VStack {
        //         Text("Is this")
        //         Text("the")
        //         Text("Matrix?")
        //     }

        // }

        // HStack {
        //     Text("Hello")
        //     Text("World")
        //     VStack {
        //         Text("Is this")
        //         Text("the")
        //         Text("Matrix?")
        //     }

        // }
        HStack(alignment: .bottom) {
            Text("Hello")
            Text("World")
            VStack {
                Text("Is this")
                Text("the")
                Text("Matrix?")
            }

        }
    }
}

let engine = AppEngine(app: Example())
engine.run()
