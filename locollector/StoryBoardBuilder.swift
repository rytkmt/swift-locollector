import UIKit

class StoryboardBuilder: NSObject {
    var mainStoryboard: UIStoryboard!
    
    override init() {
        super.init()
        self.mainStoryboard = StoryboardBuilder.createRegisterStoryboard()
    }
    
    static var sharedInstance: StoryboardBuilder = {
        return StoryboardBuilder()
    }()
    
    class func storyboardWithIdentifier(identifier: String) -> UIStoryboard {
        return UIStoryboard(name: identifier, bundle: Bundle.main)
    }
    
    // Main.Storyboard生成
    class func createRegisterStoryboard() -> UIStoryboard {
        return StoryboardBuilder.storyboardWithIdentifier(identifier: "Main")
    }
    
    func loginViewController() -> RootViewController {
        return mainStoryboard.instantiateViewController(withIdentifier: "RootViewController") as! RootViewController
    }
    
    func settingViewController() -> SettingViewController {
        return mainStoryboard.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
    }
    
    func sidemenuViewController() -> SidemenuViewController {
        return mainStoryboard.instantiateViewController(withIdentifier: "SidemenuViewController") as! SidemenuViewController
    }
}
