# BlinkUI: A SwiftUI-Inspired Terminal UI Framework

BlinkUI is an experimental terminal UI framework that brings SwiftUI's declarative syntax and component-based architecture to terminal applications. Build beautiful, interactive terminal UIs using familiar SwiftUI-like patterns.

![BlinkUI_SimpleDemo](https://github.com/user-attachments/assets/5567be9d-2510-4e39-b430-ba380cc36a6f)

> [!WARNING]  
> This is an experimental project, currently in active development. While functional, it's not yet recommended for production use. Feedback and contributions are welcome!

## Features

- **SwiftUI-like Syntax**: Write terminal UIs using familiar declarative syntax
- **Rich Component Library**: Built-in components like Text, Button, HStack, VStack, and ZStack
- **State Management**: Support for @State, @Binding, and @Environment property wrappers
- **Focus Engine**: Keyboard navigation between interactive elements (Tab/Shift+Tab)
- **View Modifiers**: Padding, borders, and frame customization
- **Layout System**: Flexible layout engine for component positioning

## Quick Example

```swift
import BlinkUI

struct Example: App {
    @State var isSelected: Bool = false

    var body: some View {
        Text("This is your last chance. After this, there is no turning back.")
        if !isSelected {
            HStack {
                Button(action: { isSelected = true }) { Text("Blue pill") }
                Button(action: { isSelected = true }) { Text("Red pill") }
            }
        } else {
            Text("The Matrix is everywhere. It is all around us.")
        }
    }
}

// Run the app
let engine = AppEngine(app: Example())
engine.run()
```

## Components and Features

### Base Views

#### Text
Text with simple word wrapping logic
<div>
<img width="531" alt="Text Component Example" src="https://github.com/user-attachments/assets/2295abeb-282f-44aa-a698-5c42276eb120" />
</div>

#### Button
Interactive buttons with customizable labels and actions.
<div>
<img width="531" alt="Button Example 1" src="https://github.com/user-attachments/assets/f46dd3e4-0879-4d9f-a2d9-52e650ce36fe" />
<img width="531" alt="Button Example 2" src="https://github.com/user-attachments/assets/7fe00f68-aa23-4a64-ae6b-c259d2fe4bca" />
</div>

#### HStack
<div>
<img width="191" alt="image" src="https://github.com/user-attachments/assets/54a97b3e-5353-4780-a3ba-c6bacae8aa53" />
<img width="191" alt="image" src="https://github.com/user-attachments/assets/a3454755-f971-4651-a941-ba553797835f" />
<img width="191" alt="image" src="https://github.com/user-attachments/assets/dc921774-bc88-4653-b510-5652b07992a3" />
</div>

#### VStack
<div>
<img width="113" alt="image" src="https://github.com/user-attachments/assets/0ed87e34-90cc-4d1a-bdac-f9cdd6fd78ec" />
<img width="113" alt="image" src="https://github.com/user-attachments/assets/0cae262f-4fef-41d7-8dab-f0fda09a62e8" />
<img width="113" alt="image" src="https://github.com/user-attachments/assets/e9a1d3c4-cec4-45fe-a624-3117c984de97" />
</div>

#### ZStack
<div>
<img width="531" alt="ZStack Example" src="https://github.com/user-attachments/assets/28a27285-2deb-4d46-a0b5-1cfe0b413015" />
</div>

### View Modifiers

Powerful modifiers to customize your components:

#### Frame
Control the dimensions and alignment of your components.
<div>
<img width="546" alt="Frame Modifier Example" src="https://github.com/user-attachments/assets/a53ca7bd-41a1-4822-8bf8-5776a1353bf3" />
</div>

#### Padding
Add space around your components for better layout control.
<div>
<img width="546" alt="Padding Modifier Example" src="https://github.com/user-attachments/assets/da7a619f-1f36-40d9-807c-8e12759cf5e7" />
</div>

#### Border
Add beautiful borders with different styles.
<div>
<img width="546" alt="Border Modifier Example" src="https://github.com/user-attachments/assets/7507d977-67b3-45be-81f1-f69020cf1548" />
</div>

### Focus Engine
Navigate through interactive elements using keyboard (Tab/Shift+Tab).
![Focus Navigation Demo](https://github.com/user-attachments/assets/5e04c90a-074a-4066-b3e2-660520c8d385)

### State Management
Reactive state management with property wrappers (@State, @Binding, @Environment).
<div>
<img width="546" alt="State Management Example" src="https://github.com/user-attachments/assets/9e8d9060-21c5-423c-b104-870597412238" />
</div>

## Under Development
- 🚧 Word wrapping
- 🚧 Advanced layouts
- 🚧 Performance optimization
- 🚧 Testing framework
- 🚧 Buffer management
- 🚧 Cross-platform support (Windows/Linux)
- 🚧 Hyperlink support
- 🚧 Documentation and examples

## Getting Started

> Coming Soon: Installation and usage instructions will be added as the project stabilizes.

## Contributing

This project is open for experimentation and learning. If you're interested in terminal UI frameworks or SwiftUI internals, feel free to take a look at the code and provide feedback.

## Technical Details

The framework consists of over 2,000 lines of code implementing:
- Custom ViewBuilder for declarative syntax
- Node-based layout system
- State management system
- Focus engine for accessibility
- Terminal rendering engine

> TODO: A detailed technical blog post about the implementation and learnings is planned.

## Why This Project?

BlinkUI started as a deep dive into understanding SwiftUI's architecture. Instead of just reading about SwiftUI or building another todo app, I decided to challenge myself by recreating its core concepts for terminal applications. This hands-on approach provided invaluable insights into:

- How declarative UI frameworks actually work under the hood
- The complexities of state management and data flow
- The challenges of building a layout engine from scratch
- Real-world application of property wrappers and function builders

