//
//  ViewController.swift
//  MLSelectedTimeDemo
//
//  Created by Melo on 2021/7/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func show(_ sender: Any) {
        let businessTimeStrStart = "08:30"
        let businessTimeStrEnd = "17:30"
        let expireDate = Date().getNewDate(byAdding: 10)
        let configs = PickupTimeConfigs(businessTimeStrStart: businessTimeStrStart,
                                        businessTimeStrEnd: businessTimeStrEnd,
                                        expiredTimestamp: expireDate.toTimeStamp(),
                                        warmPrompt: "处方有效期至: \(expireDate.toString("yyyy-MM-dd HH:mm:ss"))\n药店营业时间: \(businessTimeStrStart) ~ \(businessTimeStrEnd)")
        let selectUtil = PickupTimeSelectUtil()
        selectUtil.assemblyDataAndShow(with: configs)
        selectUtil.chooseTimeBack = { (visualStr: String, bgStrStart: String, bgStrEnd: String) in
            print(visualStr)
            print(bgStrStart)
            print(bgStrEnd)
            self.resultLabel.text = visualStr
        }
    }

}

