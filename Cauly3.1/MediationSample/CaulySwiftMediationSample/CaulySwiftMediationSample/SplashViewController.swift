//
//  SplashViewController.swift
//  CaulySwiftMediationSample
//
//  Created by FSN on 2023/07/23.
//

import UIKit

class SplashViewController: UIViewController, AppOpenAdManagerDelegate {
    /// Number of seconds remaining to show the app open ad.
    /// This simulates the time needed to load the app.
    var secondsRemaining: Int = 5
    /// The countdown timer.
    var countdownTimer: Timer?
    /// Text that indicates the number of seconds left to show an app open ad.
    @IBOutlet weak var splashScreenLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        AppOpenAdManager.shared.appOpenAdManagerDelegate = self
        startTimer()
    }

    @objc func decrementCounter() {
        secondsRemaining -= 1
        if secondsRemaining > 0 {
            splashScreenLabel.text = "App is done loading in: \(secondsRemaining)"
        } else {
            splashScreenLabel.text = "Done."
            countdownTimer?.invalidate()
            AppOpenAdManager.shared.showAdIfAvailable(viewController: self)
        }
    }

    func startTimer() {
        splashScreenLabel.text = "App is done loading in: \(secondsRemaining)"
        countdownTimer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(SplashViewController.decrementCounter),
            userInfo: nil,
            repeats: true)
    }

    func startMainScreen() {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = mainStoryBoard.instantiateViewController(withIdentifier: "MainStoryBoard")
        present(mainViewController, animated: true) {
            self.dismiss(animated: false) {
                // Find the keyWindow which is currently being displayed on the device,
                // and set its rootViewController to mainViewController.
                let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
                keyWindow?.rootViewController = mainViewController
            }
        }
    }

    // MARK: AppOpenAdManagerDelegate
    func appOpenAdManagerAdDidComplete(_ appOpenAdManager: AppOpenAdManager) {
        startMainScreen()
    }
}
