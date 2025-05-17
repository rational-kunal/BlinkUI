import os

enum DemoScreen {
    case None
    case Counter
    case ZStackAndAlignment
    case EnvironmentBorder
    case Text
}

struct Example: App {
    @State var demoScreen: DemoScreen = .None

    var body: some View {
        VStack {
            HStack {
                Button {
                    demoScreen = .Counter
                } label: {
                    Text("State+Binding")
                }
                Button {
                    demoScreen = .ZStackAndAlignment
                } label: {
                    Text("ZStack+Alignment")
                }
                Button {
                    demoScreen = .EnvironmentBorder
                } label: {
                    Text("EnvironmentBorder")
                }
                Button {
                    demoScreen = .Text
                } label: {
                    Text("Text")
                }
            }

            VStack {
                if demoScreen == .ZStackAndAlignment {
                    ZStackAndAlignmentExample()
                } else if demoScreen == .Counter {
                    Counter()
                } else if demoScreen == .EnvironmentBorder {
                    EnvironmentBorderDemo()
                } else if demoScreen == .Text {
                    TextDemo()
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
    @State private var counter = 0

    var body: some View {
        VStack {
            Text("Tapping on the button changes counter")
            Text("Counter should also reset when this screen is removed from render tree")
            CounterControls(counter: $counter)
            Text("\(counter)").padding(.all, 5)
        }
    }
}

struct CounterControls: View {
    @Binding var counter: Int

    var body: some View {
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
    }
}

enum Choices {
    case A, B, C
}

struct ChoiceEnvironmentKey: EnvironmentKey {
    static let defaultValue: Choices = .A
}
extension EnvironmentValues {
    var choice: Choices {
        get { self[ChoiceEnvironmentKey.self] }
        set { self[ChoiceEnvironmentKey.self] = newValue }
    }
}

struct EnvironmentBorderDemo: View {
    @State var selectedChoice: Choices = .A
    var body: some View {
        VStack {
            HStack {
                Button(action: { selectedChoice = .A }) {
                    Text("Choice A")
                }
                Button(action: { selectedChoice = .B }) {
                    Text("Choice B")
                }
                Button(action: { selectedChoice = .C }) {
                    Text("Choice C")
                }
            }

            Text(
                "Selecting a choice updates the environment, which reflects in the innermost consumer view"
            )

            Inner().environment(\.choice, selectedChoice)
        }.frame(width: .infinity, height: .infinity)
    }
}

struct Inner: View {
    var body: some View {
        VStack {
            Text("Inner")
            InnerInner()
        }.padding(.horizontal).border(style: .dashed)
    }
}

struct InnerInner: View {
    var body: some View {
        VStack {
            Text("InnerInner")
            InnerMost()
        }.padding(.horizontal).border(style: .solid)
    }
}

struct InnerMost: View {
    var body: some View {
        VStack {
            Text("InnerMost")
            EnvironmentConsumer()
        }.padding(.horizontal).border(style: .rounded)
    }
}

struct EnvironmentConsumer: View {
    @Environment(\.choice) var envChoice: Choices

    var body: some View {
        VStack {
            if envChoice == .A {
                Text("Selected Choice: A")
            } else if envChoice == .B {
                Text("Selected Choice: B")
            } else {
                Text("Selected Choice: C")
            }
        }
    }
}

struct TextDemo: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Lorem ipsum dolor sit amet consectetur adipiscing elit quisque faucibus.")
            Text(
                "Lorem ipsum dolor sit amet consectetur adipiscing elit. Amet consectetur adipiscing elit quisque faucibus ex sapien. Quisque faucibus ex sapien vitae pellentesque sem placerat. Vitae pellentesque sem placerat in id cursus mi."
            )
        }.frame(alignment: .leading)
    }
}

let engine = AppEngine(app: Example())
engine.run()
