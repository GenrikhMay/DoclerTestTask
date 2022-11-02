import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] == nil {
            let startingController = AppStartingCoordinator().start()
            window?.rootViewController = startingController
        }
        window?.makeKeyAndVisible()
    }
}
