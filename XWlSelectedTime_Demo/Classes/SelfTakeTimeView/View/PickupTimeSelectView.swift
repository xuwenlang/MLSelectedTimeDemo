//
//  PickupTimeSelectView.swift
//  MLSelectedTimeDemo
//
//  Created by Melo on 2021/7/26.
//

import UIKit

class PickupTimeSelectView: UIView {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var presExpireLabel: UILabel!
    @IBOutlet weak var dateTableView: UITableView!
    @IBOutlet weak var timeTableView: UITableView!
    @IBOutlet weak var confirmButton: UIButton!
    
    public var didClickCloseButton: (() -> Void)?
    public var didClickConfirmButton: ((_ dateModel: PickupDateModel?, _ hourModel: PickupDateHourPeriod?) -> Void)?

    public var takeDates: [PickupDateModel] = [] {
        didSet {
            dateTableView.reloadData()
        }
    }
    public var takeTimes: [PickupDateHourPeriod] = [] {
        didSet {
            timeTableView.reloadData()
        }
    }

    private let pickupTimeDayCellReuseID = "PickupTimeDayCellReuseIdentifier"
    private let pickupTimeHourCellReuseID = "PickupTimeHourCellReuseIdentifier"

    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }

    class func newInstance() -> Self {
        return Bundle.main.loadNibNamed("\(self)", owner: nil, options: nil)?.first as! Self
    }

    private func setUI() {
        dateTableView.register(UINib(nibName: "PickupTimeDayCell", bundle: nil), forCellReuseIdentifier: pickupTimeDayCellReuseID)
        dateTableView.rowHeight = 45
        dateTableView.separatorStyle = .none
        dateTableView.tableFooterView = UIView()
        dateTableView.delegate = self
        dateTableView.dataSource = self

        timeTableView.register(UINib(nibName: "PickupTimeHourCell", bundle: nil), forCellReuseIdentifier: pickupTimeHourCellReuseID)
        timeTableView.rowHeight = 45
        timeTableView.separatorStyle = .none
        timeTableView.tableFooterView = UIView()
        timeTableView.delegate = self
        timeTableView.dataSource = self

        confirmButton.layer.masksToBounds = true
        confirmButton.layer.cornerRadius = 4
    }

    /// 关闭按钮点击
    @IBAction func onClickCloseButton(_ sender: Any) {
        didClickCloseButton?()
    }

    /// 确认按钮点击
    @IBAction func onClickConfirmButton(_ sender: Any) {
        var dateModel: PickupDateModel?
        var hourModel: PickupDateHourPeriod?

        let dateIndexPath = self.dateTableView.indexPathForSelectedRow
        if let idx = dateIndexPath {
            dateModel = takeDates[idx.row]
        } else {
            didClickConfirmButton?(nil, nil)
            return
        }

        let timeIndexPath = self.timeTableView.indexPathForSelectedRow
        if let timeIdx = timeIndexPath {
            hourModel = takeTimes[timeIdx.row]
            didClickConfirmButton?(dateModel, hourModel)
        } else {
            didClickConfirmButton?(dateModel, nil)
        }
    }

}

extension PickupTimeSelectView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == dateTableView {
            return takeDates.count
        } else {
            return takeTimes.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == dateTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: pickupTimeDayCellReuseID, for: indexPath) as? PickupTimeDayCell else {
                fatalError("Could not dequeue cell with identifier: \(pickupTimeDayCellReuseID)")
            }
            let element = takeDates[indexPath.row]
            cell.titleText = element.dayStr
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: pickupTimeHourCellReuseID, for: indexPath) as? PickupTimeHourCell else {
                fatalError("Could not dequeue cell with identifier: \(pickupTimeHourCellReuseID)")
            }
            let element = takeTimes[indexPath.row]
            cell.titleText = element.hourPeriodStr
            return cell
        }
    }

}

extension PickupTimeSelectView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView == dateTableView) {
            let element = takeDates[indexPath.row]
            takeTimes = element.hourPeriod
            self.timeTableView.scroll(to: .top, animated: true)
        }
    }

}
