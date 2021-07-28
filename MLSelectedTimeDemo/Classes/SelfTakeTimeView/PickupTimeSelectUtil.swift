//
//  PickupTimeSelectUtil.swift
//  MLSelectedTimeDemo
//
//  Created by Melo on 2021/7/25.
//

import UIKit

struct PickupTimeConfigs {
    var businessTimeStrStart: String
    var businessTimeStrEnd: String
    var expiredTimestamp: Double
    var warmPrompt: String
}

class PickupTimeSelectUtil {

    var maskView = UIControl()

    let selectView = PickupTimeSelectView.newInstance()

    var viewHeight: CGFloat = 450

    var viewModel: PickupTimeSelectViewModel!

    var chooseTimeBack: ((_ visualStr: String, _ bgStrStart: String, _ bgStrEnd: String) -> Void)?

    init() {
        maskView.backgroundColor = UIColor.clear
        maskView.addTarget(self, action: #selector(hide), for: .touchUpInside)

        selectView.didClickCloseButton = { () in
            self.hide()
        }
        selectView.didClickConfirmButton = { (dateModel, hourModel) in
            guard let takeDate = dateModel else {
                self.showAlert(title: "请选择取药日期")
                return
            }
            guard let takeHour = hourModel else {
                self.showAlert(title: "请选择取药时间")
                return
            }

            let dayStr = takeDate.dayDate.toString("yyyy-MM-dd")
            let visualStr = dayStr + " " + takeHour.hourPeriodStr
            let bgStrStart = dayStr + " " + takeHour.startTimeStr
            let bgStrEnd = dayStr + " " + takeHour.endTimeStr

            if let timeBack = self.chooseTimeBack {
                timeBack(visualStr, bgStrStart, bgStrEnd)
            }

            self.hide()
        }
    }

    func assemblyDataAndShow(with configs: PickupTimeConfigs) {
        selectView.presExpireLabel.text = configs.warmPrompt
        viewModel = PickupTimeSelectViewModel(expiredTimestamp: configs.expiredTimestamp,
                                              businessTimeStrStart: configs.businessTimeStrStart,
                                              businessTimeStrEnd: configs.businessTimeStrEnd)
        do {
            let resultDates = try viewModel.loadData()
            selectView.takeDates = resultDates
            selectView.takeTimes = resultDates[0].hourPeriod
            show()
        } catch PickupTimeSelectViewError.expired {
            self.showAlert(title: PickupTimeSelectViewError.expired.localizedDescription)
        } catch {
            
        }
    }

    func show() {
        let keyWindow: UIWindow? = UIApplication.shared.keyWindow
        guard let window = keyWindow else {
            return
        }

        maskView.frame = window.bounds
        selectView.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: viewHeight)

        window.addSubview(maskView)
        window.addSubview(selectView)

        self.selectView.layoutIfNeeded()
        UIView.animate(withDuration: 0.25) {
            self.maskView.backgroundColor = UIColor(white: 0.0, alpha: 0.35)
            self.selectView.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height - self.viewHeight, width: UIScreen.main.bounds.size.width, height: self.viewHeight)
            self.selectView.layoutIfNeeded()
        }
    }

    @objc func hide() {
        UIView.animate(withDuration: 0.25, animations: {
            self.maskView.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
            self.selectView.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: self.viewHeight)
            self.selectView.layoutIfNeeded()
        }, completion: { _ in
            self.selectView.removeFromSuperview()
            self.maskView.removeFromSuperview()
        })
    }

    func showAlert(title: String?,
                   message: String? = nil,
                   confirmTitle: String? = nil,
                   handler: (() -> Void)? = nil) {
        let alertVc = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction.init(title: confirmTitle ?? "确定", style: UIAlertAction.Style.default) { (alertAction) in
            handler?()
        }
        alertVc.addAction(alertAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertVc, animated: true, completion: nil)
    }
    
}
