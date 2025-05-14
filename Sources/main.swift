import os

enum DemoScreen {
    case None
    case Counter
    case ZStackAndAlignment
}

struct Example: App {
    @State var demoScreen: DemoScreen = .None

    var body: some View {
        VStack {
            HStack {
                Button {
                    demoScreen = .Counter
                } label: {
                    Text("State")
                }
                Button {
                    demoScreen = .ZStackAndAlignment
                } label: {
                    Text("ZStack+Alignment")
                }
            }

            VStack {
                if demoScreen == .ZStackAndAlignment {
                    ZStackAndAlignmentExample()
                } else if demoScreen == .Counter {
                    Counter()
                } else {
                    SimpleInstructions()
                }
            }.frame(width: .infinity, height: .infinity)

        }.frame(width: .infinity, height: .infinity, alignment: .top)
    }
}

struct SimpleInstructions: View {
    var body: some View {
        Text("Press tab / shift+tab to iterate over buttons")
        Text("Press space to activate focused button")
    }
}

struct ZStackAndAlignmentExample: View {
    var body: some View {
        ZStack(alignment: .top) {
            Text("topLeading").frame(width: .infinity, height: .infinity, alignment: .topLeading)
            Text("top").frame(width: .infinity, height: .infinity, alignment: .top)
            Text("topTrailing").frame(width: .infinity, height: .infinity, alignment: .topTrailing)
            Text("leading").frame(width: .infinity, height: .infinity, alignment: .leading)
            Text("center").frame(width: .infinity, height: .infinity, alignment: .center)
            Text("trailing").frame(width: .infinity, height: .infinity, alignment: .trailing)
            Text("bottomLeading").frame(
                width: .infinity, height: .infinity, alignment: .bottomLeading)
            Text("bottom").frame(width: .infinity, height: .infinity, alignment: .bottom)
            Text("bottomTrailing").frame(
                width: .infinity, height: .infinity, alignment: .bottomTrailing)
        }
    }
}

struct Counter: View {
    @State var counter = 0
    var body: some View {
        Text("Tapping on the button changes counter")
        Text("Counter should also reset when this screen is removed from render tree")
        HStack {
            Button {
                counter += 1
            } label: {
                Text("add").padding(.horizontal)
            }
            Button {
                counter = 0
            } label: {
                Text("reset").padding(.horizontal)
            }
            Button {
                counter -= 1
            } label: {
                Text("minus").padding(.horizontal)
            }
        }

        Text("\(counter)")
    }
}

let engine = AppEngine(app: Example())
engine.run()
