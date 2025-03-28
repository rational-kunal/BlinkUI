class ViewHeirarchyEngine {
    let root: Node

    init(rootView: any View) {
        let psuedoRootView = Screen()
        self.root = ScreenNode(view: psuedoRootView)
        rootView.buildNode(root)
    }
}
