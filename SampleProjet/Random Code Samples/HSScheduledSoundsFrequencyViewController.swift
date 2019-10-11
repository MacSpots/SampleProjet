//
//  HSScheduledSoundsFrequencyViewController.swift
//  SampleProjet
//
//  Created by Jason Jardim on 10/11/19.
//  Copyright © 2019 Jason Jardim. All rights reserved.
//

import UIKit
import Foundation

class HSScheduledSoundsFrequencyViewController: HSViewController {
    
    weak var delegate: HSScheduledSoundDelegate?
    var workingScheduledSound: ScheduledSoundsDocument?

    var tableView: UITableView = UITableView()
    let calendar = Calendar.current

    var arraySelectedData: [Int] = [Int]()

    let btnSave = UIButton(type: .custom)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationItem.title = NSLocalizedString("SCHEDULED_SOUNDS_REPEAT", comment: "")
        setupViewAndConstraints()
    }
    
    
    func setupViewAndConstraints() {

        let barButtonRight = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(didPressSave))
        self.navigationItem.rightBarButtonItem = barButtonRight
        
        //Table View
        self.tableView.backgroundColor = HSGlobal.shared.color()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "daysOfWeekCell")
        self.tableView.estimatedRowHeight = 40
        self.tableView.separatorStyle = .singleLine
        self.tableView.allowsMultipleSelection = true
        self.tableView.tintColor = HSGlobal.shared.tint()

        self.view.addSubview(tableView)
        
        self.tableView.snp.makeConstraints {
            (make) -> Void in
            if #available(iOS 11.0, *) {
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            } else {
                make.top.equalTo(self.topLayoutGuide.snp.bottom)
            }
            make.left.equalTo(self.view)
            make.width.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
        
        // Save Button
        btnSave.isAccessibilityElement = true
        btnSave.tintColor = HSGlobal.shared.foregroundOnDark()
        btnSave.addTarget(self, action: #selector(didPressSave), for: UIControl.Event.touchUpInside)
        btnSave.backgroundColor = HSGlobal.shared.colorDark()
        btnSave.setTitleColor(HSGlobal.shared.tint(), for: .normal)

        btnSave.setTitle(NSLocalizedString("SAVE", comment: ""), for: .normal)
        btnSave.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.title3)
        btnSave.alpha = 1.0
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 44 + 30))
        footerView.addSubview(btnSave)

        btnSave.snp.makeConstraints {
            (make) -> Void in
            make.top.equalTo(footerView).offset(30)
            make.leading.equalTo(footerView.readableContentGuide).offset(20)
            make.trailing.equalTo(footerView.readableContentGuide).offset(-20)
            make.height.equalTo(44.0)
            make.bottom.equalTo(footerView)
        }
        
        tableView.tableFooterView = footerView
        tableView.tableFooterView!.isUserInteractionEnabled = true
        
        arraySelectedData = workingScheduledSound?.data?.arrayRepeatFrequency ?? []
        
        tableView.reloadData()
    }
    
    
    @objc func didPressSave() {
        saveRepeatFrequency()
        self.navigationController?.popViewController(animated: true)
    }

    
    func saveRepeatFrequency() {
        if arraySelectedData.count > 0 {
            var returnedData: String = ""
            
            arraySelectedData.sort {
                return $0 < $1
            }
            
            for item in arraySelectedData{
                returnedData = returnedData + "\(calendar.shortStandaloneWeekdaySymbols[item]) "
            }
            
            returnedData = returnedData.trimmingCharacters(in: [" "])
            
            workingScheduledSound?.data?.repeatFrequency = returnedData
            workingScheduledSound?.data?.arrayRepeatFrequency = arraySelectedData
            
            self.delegate?.scheduledSoundDidChange(scheduleSound: workingScheduledSound!)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        print("deinit - HSScheduledSoundsFrequencyViewController")
    }
}


extension HSScheduledSoundsFrequencyViewController: UITableViewDelegate {
    
    
}

extension HSScheduledSoundsFrequencyViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calendar.weekdaySymbols.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "daysOfWeekCell", for: indexPath as IndexPath) as UITableViewCell
        
        cell.backgroundColor = HSGlobal.shared.color()
        cell.textLabel?.textColor = HSGlobal.shared.foreground()
        cell.textLabel?.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.title3)

        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        cell.textLabel?.text = String.localizedStringWithFormat(NSLocalizedString("SCHEDULED_SOUNDS_EVERY_DAYS_OF_WEEK", comment: ""),  calendar.weekdaySymbols[indexPath.row])
       
        if arraySelectedData.contains(indexPath.row) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
       
        if !arraySelectedData.contains(indexPath.row) {
            arraySelectedData.append(indexPath.row)
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
            tableView.delegate?.tableView!(tableView, didDeselectRowAt: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
        let dayOfWeekInt = indexPath.row
        arraySelectedData.removeAll(where: {$0 == dayOfWeekInt})
    }
}
