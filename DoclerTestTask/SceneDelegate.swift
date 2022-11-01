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
        let navigationController = UINavigationController()
        window?.rootViewController = navigationController
        if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] == nil {
            AppStartingCoordinator().start(navigationController: navigationController)
        }
        window?.makeKeyAndVisible()
    }
}
