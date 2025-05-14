# BlinkUI: A framework to write UI for terminal
Heavily inspired by SwiftUI. Think SwiftUI app but for terminal.

> [!WARNING]  
> ⚠️ Work In Progress ⚠️

![BlinkUI-PreMVP](https://github.com/user-attachments/assets/10efc91b-5ac8-4995-81fa-cb4c19db4edc)

```swift
struct Example: App {
    var body: some View {
        Counter()
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

// Send the app to the engine
let engine = AppEngine(app: Example())
engine.run()
```


### Line of codes
```
❯ find . -name "*.swift" -type f | xargs wc -l
      15 ./Package.swift
      32 ./Sources/Core/View.swift
      21 ./Sources/Core/RenderEngine.swift
     131 ./Sources/Core/Terminal.swift
      45 ./Sources/Core/State.swift
      78 ./Sources/Core/FocusEngine.swift
      34 ./Sources/Core/AppEngine.swift
     151 ./Sources/Core/TreeEngine.swift
       3 ./Sources/Core/App.swift
       7 ./Sources/Core/RenderContext.swift
      73 ./Sources/Core/Node.swift
      34 ./Sources/Core/ViewBuilder.swift
      38 ./Sources/Core/Identifier.swift
       7 ./Sources/Components/EmptyView.swift
      24 ./Sources/Components/TupleView.swift
      66 ./Sources/Components/ZStack.swift
      30 ./Sources/Components/Screen.swift
      42 ./Sources/Components/ConditionalView.swift
      12 ./Sources/Components/AnyView.swift
       9 ./Sources/Components/ClientDefinedViewNodeBuilder.swift
      93 ./Sources/Components/HStack.swift
      92 ./Sources/Components/VStack.swift
      49 ./Sources/Components/Text.swift
      71 ./Sources/Components/Button.swift
      38 ./Sources/Common/Edge.swift
      17 ./Sources/Common/Alignment.swift
       8 ./Sources/Common/CommonUtility.swift
       4 ./Sources/Common/IsDebug.swift
      94 ./Sources/main.swift
     121 ./Sources/ViewModifierComponents/Frame.swift
      94 ./Sources/ViewModifierComponents/Padding.swift
    1533 total
```