//
//  NativeAdViewViewViewController.swift
//  CaulySample
//
//  Created by FSN on 11/9/23.
//

import UIKit

class NativeAdViewViewViewController: UIViewController {
    
    @IBOutlet var mainTitle: UILabel!
    @IBOutlet var subTitle: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var icon: UIImageView!
    @IBOutlet var image: UIImageView!
    @IBOutlet var jsonStringTextView: UITextView!
    @IBOutlet var optOutButton: UIButton!
    @IBOutlet var closeButton: UIButton!
    
    var link: NSString?
    var nativeAd: CaulyNativeAd?
    var nativeAdItem: CaulyNativeAdItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NSLog("Inform")
        nativeAd?.sendInform(nativeAdItem)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func didViewTouchUpInside(_ sender: UIButton) {
        NSLog("Native ad Clicked")
     
        UIView.animate(withDuration: 0.5, animations: {
            self.view.alpha = 0
        }, completion: {b in
            self.nativeAd?.click(self.nativeAdItem)
            
            self.view.alpha = 1
            self.presentingViewController?.dismiss(animated: false, completion: nil)
        })
    }
    
    @IBAction func closeButtonTouchUpInside(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func optOutButtonTouchUpInside(_ sender: UIButton) {
        self.nativeAd?.send(toOptOutLinkUrl: nativeAdItem)
    }
}
