//
//  ViewController.swift
//  helloauthentication-swift
//
//  Created by Ilan Klein on 08/03/2016.
//  Copyright © 2016 ibm. All rights reserved.
//

import UIKit
import BMSCore
import BMSSecurity

class ViewController: UIViewController {

    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var errorTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func testBluemixConnection(sender: UIButton) {
        topLabel.text = "Hello Auth"
        bottomLabel.text = "Attempting to connect"
        errorTextView.text = ""
        
        let callBack:MfpCompletionHandler = {(response: Response?, error: NSError?) in
            if error == nil && response?.statusCode==200 {
                dispatch_sync(dispatch_get_main_queue()) {
                    self.topLabel.text = "Yay!"
                    self.bottomLabel.text = "Connected to MCA protected endpoint"
                    self.errorTextView.text = " \(AppDelegate.resourceURL)"
                }
            } else {
                dispatch_sync(dispatch_get_main_queue()) {
                    var message: String
                
                    if let m = response?.responseText {
                        message = "\(m) Please verify the ApplicationRoute and ApplicationID."
                    }
                    else {
                        message =  "\(error?.localizedDescription) Please verify the ApplicationRoute and ApplicationID."
                    }
                    self.topLabel.text = "Bummer!"
                    self.bottomLabel.text = "Something Went Wrong"
                    self.errorTextView.text = message
                }
            }
        }
        
        let request = Request(url: AppDelegate.protectedResourceURL, method: HttpMethod.GET)
        request.sendWithCompletionHandler(callBack)
//        MCAAuthorizationManager.sharedInstance.obtainAuthorization(callBack)

    }
}

