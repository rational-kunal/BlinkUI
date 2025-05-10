// Is debug i.e. launched via VS Code
func IsDebug() -> Bool {
    return CommandLine.arguments.contains("debug")
}
