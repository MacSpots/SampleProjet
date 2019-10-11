//
//  ScheduledSoundsDetailViewController.swift
//  SampleProjet
//
//  Created by Jason Jardim on 10/11/19.
//  Copyright © 2019 Jason Jardim. All rights reserved.
//

import UIKit
import Foundation


protocol HSScheduledSoundDetailViewControllerDelegate {
    
    func scheduledSoundDidDelete()
    
}

class HSScheduledSoundsDetailViewController: HSViewController {
    
    var delegate: HSScheduledSoundDetailViewControllerDelegate?

    var workingScheduledSound: ScheduledSoundsDocument?

    var isNewlyCreatedSound : Bool = false

    let lblTitle = HSLabel()
    let btnTitleAnswer = UIButton(type: .custom)

    let lblStartTime = HSLabel()
    let btnStartTimeAnswer = UIButton(type: .custom)

    let lblStopTime = HSLabel()
    let btnStopTimeAnswer = UIButton(type: .custom)

    let lblRepeat = HSLabel()
    let btnRepeatAnswer = UIButton(type: .custom)

    let lblSound = HSLabel()
    let btnSoundAnswer = UIButton(type: .custom)

    let lblFadeIn = HSLabel()
    let btnFadeInAnswer = UIButton(type: .custom)

    let lblFadeOut = HSLabel()
    let btnFadeOutAnswer = UIButton(type: .custom)


    let btnDeleteSound = UIButton(type: .custom)
    let btnSaveSound = UIButton(type: .custom)

    let rowOne   = UIView()
    let rowTwo   = UIView()
    let rowThree = UIView()
    let rowFour  = UIView()
    let rowFive  = UIView()
    let rowSix   = UIView()
    let rowSeven = UIView()

    
    private let svRowHeight = 40

    let stackView: UIStackView = {
        let sv = UIStackView()
        
        sv.axis = .vertical
        sv.distribution = .equalSpacing
        sv.alignment = .fill
        sv.spacing = 10
    
        return sv
    }()
    
    let scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isNewlyCreatedSound {
            let barButtonLeft = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelNewScheduledSound))
            self.navigationItem.leftBarButtonItem = barButtonLeft
        }

        let barButtonRight = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveNewScheduledSound))
        self.navigationItem.rightBarButtonItem = barButtonRight
        self.navigationItem.title = NSLocalizedString("SCHEDULED_SOUND", comment: "")

        refreshData()
        setupStackView()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
        scrollView.updateContentView()
    }
    
    func setupStackView() {
        self.scrollView.alwaysBounceVertical = false
        self.scrollView.isScrollEnabled = true
        self.view.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints {
            (make) -> Void in
            make.edges.equalTo(self.view)
        }
        
        self.scrollView.addSubview(self.stackView)
        self.stackView.snp.makeConstraints {
            (make) -> Void in
                make.top.equalTo(self.scrollView.snp.top).offset(30)
                make.width.equalTo(self.scrollView)
        }
    
        setupRowOne()
        self.stackView.addArrangedSubview(rowOne)
        
        setupRowTwo()
        self.stackView.addArrangedSubview(rowTwo)

        setupRowThree()
        self.stackView.addArrangedSubview(rowThree)

        setupRowFour()
        self.stackView.addArrangedSubview(rowFour)

        setupRowFive()
        self.stackView.addArrangedSubview(rowFive)

        setupRowSix()
        self.stackView.addArrangedSubview(rowSix)

        setupRowSeven()
        self.stackView.addArrangedSubview(rowSeven)
        
        setupSaveButton()
        
        // Dont show delete if its a newly created sound
        if isNewlyCreatedSound == false{
            setupDeleteButton()
        }
    }

    func setupRowOne() {
        
        rowOne.backgroundColor = HSGlobal.shared.color()
        
        rowOne.snp.makeConstraints {
            (make) -> Void in
                make.height.equalTo(svRowHeight)
        }
        
        lblStartTime.text = NSLocalizedString("SCHEDULED_SOUNDS_START_TIME", comment: "")
        lblStartTime.textColor = HSGlobal.shared.foreground()
        lblStartTime.dynamicFont = .title3
        lblStartTime.numberOfLines = 1
        lblStartTime.allowsDefaultTighteningForTruncation = true
        lblStartTime.lineBreakMode = NSLineBreakMode.byTruncatingTail
      
        self.rowOne.addSubview(lblStartTime)

        lblStartTime.snp.makeConstraints {
            (make) -> Void in
                make.leading.equalTo(self.rowOne.readableContentGuide)
        }
        
        btnStartTimeAnswer.isAccessibilityElement = true
        btnStartTimeAnswer.addTarget(self, action: #selector(didTapStartTimeButton), for: UIControl.Event.touchUpInside)
        btnStartTimeAnswer.setTitleColor(HSGlobal.shared.foregroundOnDark(), for: .normal)
        btnStartTimeAnswer.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption1)

        btnStartTimeAnswer.contentHorizontalAlignment = .right
        btnStartTimeAnswer.tintColor = HSGlobal.shared.foregroundOnDark()
        btnStartTimeAnswer.addRightImage(image: UIImage(named: "forward")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), offset: -16)
        
        self.rowOne.addSubview(btnStartTimeAnswer)
       
        btnStartTimeAnswer.snp.makeConstraints {
            (make) -> Void in
                make.width.equalTo(self.rowOne)
                make.height.equalTo(self.rowOne)
                make.trailing.equalTo(self.rowOne.readableContentGuide).offset(-20)
        }
    }
    
    func setupRowTwo() {
                
        rowTwo.snp.makeConstraints {
            (make) -> Void in
                make.height.equalTo(svRowHeight)
        }
        
        lblStopTime.text = NSLocalizedString("SCHEDULED_SOUNDS_END_TIME", comment: "")
        lblStopTime.textColor = HSGlobal.shared.foreground()
        lblStopTime.dynamicFont = .title3
        lblStopTime.numberOfLines = 1
        lblStopTime.allowsDefaultTighteningForTruncation = true
        lblStopTime.lineBreakMode = NSLineBreakMode.byTruncatingTail
      
        self.rowTwo.addSubview(lblStopTime)
        
        lblStopTime.snp.makeConstraints {
            (make) -> Void in
                make.leading.equalTo(self.rowTwo.readableContentGuide)
        }
        
        btnStopTimeAnswer.isAccessibilityElement = true
        btnStopTimeAnswer.tintColor = HSGlobal.shared.foregroundOnDark()
        btnStopTimeAnswer.addTarget(self, action: #selector(didTapStopTimeButton), for: UIControl.Event.touchUpInside)
        btnStopTimeAnswer.setTitleColor(HSGlobal.shared.foregroundOnDark(), for: .normal)
        btnStopTimeAnswer.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption1)
        btnStopTimeAnswer.contentHorizontalAlignment = .right
        btnStopTimeAnswer.tintColor = HSGlobal.shared.foregroundOnDark()
        btnStopTimeAnswer.addRightImage(image: UIImage(named: "forward")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), offset: -16)
      
        self.rowTwo.addSubview(btnStopTimeAnswer)
        
        btnStopTimeAnswer.snp.makeConstraints {
            (make) -> Void in
                make.width.equalTo(self.rowTwo)
                make.height.equalTo(self.rowTwo)
                make.trailing.equalTo(self.rowTwo.readableContentGuide).offset(-20)
        }
    }
    
    
    func setupRowThree() {

        rowThree.backgroundColor = .clear
        
        rowThree.snp.makeConstraints {
            (make) -> Void in
                make.height.equalTo(svRowHeight)
        }
        
        lblRepeat.text = NSLocalizedString("SCHEDULED_SOUNDS_REPEAT", comment: "")
        lblRepeat.textColor = HSGlobal.shared.foreground()
        lblRepeat.dynamicFont = .title3
        lblRepeat.numberOfLines = 1
        lblRepeat.allowsDefaultTighteningForTruncation = true
        lblRepeat.lineBreakMode = NSLineBreakMode.byTruncatingTail
       
        self.rowThree.addSubview(lblRepeat)
        
        lblRepeat.snp.makeConstraints {
            (make) -> Void in
            make.leading.equalTo(self.rowThree.readableContentGuide)
        }
        
        btnRepeatAnswer.isAccessibilityElement = true
        btnRepeatAnswer.tintColor = HSGlobal.shared.foregroundOnDark()
        btnRepeatAnswer.addTarget(self, action: #selector(didTapFrequencyButton), for: UIControl.Event.touchUpInside)
        btnRepeatAnswer.setTitleColor(HSGlobal.shared.foregroundOnDark(), for: .normal)
        btnRepeatAnswer.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption1)
        btnRepeatAnswer.contentHorizontalAlignment = .right
        btnRepeatAnswer.tintColor = HSGlobal.shared.foregroundOnDark()
        btnRepeatAnswer.addRightImage(image: UIImage(named: "forward")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), offset: -16)
       
        self.rowThree.addSubview(btnRepeatAnswer)
        
        btnRepeatAnswer.snp.makeConstraints {
            (make) -> Void in
                make.width.equalTo(self.rowThree)
                make.height.equalTo(self.rowThree)
                make.trailing.equalTo(self.rowThree.readableContentGuide).offset(-20)
        }
    }
    
    
    func setupRowFour() {
        
        rowFour.backgroundColor = .clear
        
        rowFour.snp.makeConstraints {
            (make) -> Void in
                make.height.equalTo(svRowHeight)
        }

        // Sound Label
        lblSound.text = NSLocalizedString("SCHEDULED_SOUNDS_SOUND", comment: "")
        lblSound.textColor = HSGlobal.shared.foreground()
        lblSound.dynamicFont = .title3
        lblSound.numberOfLines = 1
        lblSound.allowsDefaultTighteningForTruncation = true
        lblSound.lineBreakMode = NSLineBreakMode.byTruncatingTail
       
        self.rowFour.addSubview(lblSound)
        
        lblSound.snp.makeConstraints {
            (make) -> Void in
                make.leading.equalTo(self.rowFour.readableContentGuide)
        }
        
        //Sound Label Answer
        btnSoundAnswer.isAccessibilityElement = true
        btnSoundAnswer.tintColor = HSGlobal.shared.foregroundOnDark()
        btnSoundAnswer.addTarget(self, action: #selector(didTapSelectSoundButton), for: UIControl.Event.touchUpInside)
        btnSoundAnswer.setTitleColor(HSGlobal.shared.foregroundOnDark(), for: .normal)
        btnSoundAnswer.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption1)
        btnSoundAnswer.contentHorizontalAlignment = .right
        btnSoundAnswer.tintColor = HSGlobal.shared.foregroundOnDark()
        btnSoundAnswer.addRightImage(image: UIImage(named: "forward")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), offset: -16)
      
        self.rowFour.addSubview(btnSoundAnswer)
        
        btnSoundAnswer.snp.makeConstraints {
            (make) -> Void in
                make.width.equalTo(self.rowFour)
                make.height.equalTo(self.rowFour)
                make.trailing.equalTo(self.rowFour.readableContentGuide).offset(-20)
        }
    }
    
    func setupRowFive() {
        
        rowFive.backgroundColor = HSGlobal.shared.color()
        
        rowFive.snp.makeConstraints {
            (make) -> Void in
                make.height.equalTo(svRowHeight)
        }
        
        // Title Label
        lblTitle.text = NSLocalizedString("SCHEDULED_SOUNDS_LABEL", comment: "")
        lblTitle.textColor = HSGlobal.shared.foreground()
        lblTitle.dynamicFont = .title3
        lblTitle.numberOfLines = 1
        lblTitle.allowsDefaultTighteningForTruncation = true
        lblTitle.lineBreakMode = NSLineBreakMode.byTruncatingTail
        
        self.rowFive.addSubview(lblTitle)
        
        lblTitle.snp.makeConstraints {
            (make) -> Void in
                make.leading.equalTo(self.rowFive.readableContentGuide)
        }
        
        //Title Label Answer
        btnTitleAnswer.isAccessibilityElement = true
        btnTitleAnswer.tintColor = HSGlobal.shared.foregroundOnDark()
        btnTitleAnswer.addTarget(self, action: #selector(didTapChangeTitleButton), for: UIControl.Event.touchUpInside)
        btnTitleAnswer.setTitleColor(HSGlobal.shared.foregroundOnDark(), for: .normal)
        btnTitleAnswer.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption1)
        btnTitleAnswer.contentHorizontalAlignment = .right
        btnTitleAnswer.tintColor = HSGlobal.shared.foregroundOnDark()
        btnTitleAnswer.addRightImage(image: UIImage(named: "forward")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), offset: -16)
       
        self.rowFive.addSubview(btnTitleAnswer)
        
        btnTitleAnswer.snp.makeConstraints {
            (make) -> Void in
                make.width.equalTo(self.rowFive)
                make.height.equalTo(self.rowFive)
                make.trailing.equalTo(self.rowFive.readableContentGuide).offset(-20)
        }
    }
    
    
    func setupRowSix() {
        
        rowSix.backgroundColor = HSGlobal.shared.color()
        
        rowSix.snp.makeConstraints {
            (make) -> Void in
                make.height.equalTo(svRowHeight)
        }
        
        // FadeIn Label
        lblFadeIn.text = NSLocalizedString("SCHEDULED_SOUNDS_FADE_IN_DURATION", comment: "")
        lblFadeIn.textColor = HSGlobal.shared.foreground()
        lblFadeIn.dynamicFont = .title3
        lblFadeIn.numberOfLines = 1
        lblFadeIn.allowsDefaultTighteningForTruncation = true
        lblFadeIn.lineBreakMode = NSLineBreakMode.byTruncatingTail
       
        self.rowSix.addSubview(lblFadeIn)
        
        lblFadeIn.snp.makeConstraints {
            (make) -> Void in
                make.leading.equalTo(self.rowSix.readableContentGuide)
        }
        
        //Fade In Answer
        btnFadeInAnswer.isAccessibilityElement = true
        btnFadeInAnswer.tintColor = HSGlobal.shared.foregroundOnDark()
        btnFadeInAnswer.addTarget(self, action: #selector(didTapFadeInButton), for: UIControl.Event.touchUpInside)
        btnFadeInAnswer.setTitleColor(HSGlobal.shared.foregroundOnDark(), for: .normal)
        btnFadeInAnswer.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption1)
        btnFadeInAnswer.contentHorizontalAlignment = .right
        btnFadeInAnswer.tintColor = HSGlobal.shared.foregroundOnDark()
        btnFadeInAnswer.addRightImage(image: UIImage(named: "forward")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), offset: -16)
      
        self.rowSix.addSubview(btnFadeInAnswer)
        
        btnFadeInAnswer.snp.makeConstraints {
            (make) -> Void in
                make.width.equalTo(self.rowSix)
                make.height.equalTo(self.rowSix)
                make.trailing.equalTo(self.rowSix.readableContentGuide).offset(-20)
        }
    }
    
    
    func setupRowSeven() {
    
        rowSeven.backgroundColor = HSGlobal.shared.color()
        
        rowSeven.snp.makeConstraints {
            (make) -> Void in
                make.height.equalTo(svRowHeight)
        }
        
        // FadeOut Label
        lblFadeOut.text = NSLocalizedString("SCHEDULED_SOUNDS_FADE_OUT_DURATION", comment: "")
        lblFadeOut.textColor = HSGlobal.shared.foreground()
        lblFadeOut.dynamicFont = .title3
        lblFadeOut.numberOfLines = 1
        lblFadeOut.allowsDefaultTighteningForTruncation = true
        lblFadeOut.lineBreakMode = NSLineBreakMode.byTruncatingTail
       
        self.rowSeven.addSubview(lblFadeOut)
        
        lblFadeOut.snp.makeConstraints {
            (make) -> Void in
                make.leading.equalTo(self.rowSeven.readableContentGuide)
        }
        
        
        //Fade Out Answer
        btnFadeOutAnswer.isAccessibilityElement = true
        btnFadeOutAnswer.tintColor = HSGlobal.shared.foregroundOnDark()
        btnFadeOutAnswer.addTarget(self, action: #selector(didTapFadeOutButton), for: UIControl.Event.touchUpInside)
        btnFadeOutAnswer.setTitleColor(HSGlobal.shared.foregroundOnDark(), for: .normal)
        btnFadeOutAnswer.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption1)
        btnFadeOutAnswer.contentHorizontalAlignment = .right
        btnFadeOutAnswer.tintColor = HSGlobal.shared.foregroundOnDark()
        btnFadeOutAnswer.addRightImage(image: UIImage(named: "forward")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), offset: -16)
       
        self.rowSeven.addSubview(btnFadeOutAnswer)
        
        btnFadeOutAnswer.snp.makeConstraints {
            (make) -> Void in
                make.width.equalTo(self.rowSeven)
                make.height.equalTo(self.rowSeven)
                make.trailing.equalTo(self.rowSeven.readableContentGuide).offset(-20)
        }
    }
    
        
    func setupDeleteButton() {
        btnDeleteSound.isAccessibilityElement = true
        btnDeleteSound.tintColor = HSGlobal.shared.foregroundOnDark()
        btnDeleteSound.addTarget(self, action: #selector(didTapDelete), for: UIControl.Event.touchUpInside)
        btnDeleteSound.backgroundColor = HSGlobal.shared.colorDark()
        btnDeleteSound.setTitleColor(HSGlobal.shared.descructive(), for: .normal)
        btnDeleteSound.setTitle(NSLocalizedString("DELETE", comment: ""), for: .normal)
        btnDeleteSound.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.title3)
        
        self.scrollView.addSubview(btnDeleteSound)
        
        btnDeleteSound.snp.makeConstraints {
            (make) -> Void in
            make.centerX.equalTo(self.scrollView)
            make.width.equalTo(self.view.frame.width - 40)
            make.height.equalTo(44.0)
            make.top.equalTo(rowSeven.snp.bottom).offset(120)
        }
    }

    
    func setupSaveButton() {
        btnSaveSound.isAccessibilityElement = true
        btnSaveSound.tintColor = HSGlobal.shared.foregroundOnDark()
        btnSaveSound.addTarget(self, action: #selector(saveNewScheduledSound), for: UIControl.Event.touchUpInside)
        btnSaveSound.backgroundColor = HSGlobal.shared.colorDark()
        btnSaveSound.setTitleColor(HSGlobal.shared.tint(), for: .normal)

        btnSaveSound.setTitle(NSLocalizedString("SAVE", comment: ""), for: .normal)
        btnSaveSound.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.title3)
        
        self.scrollView.addSubview(btnSaveSound)
        
        btnSaveSound.snp.makeConstraints {
            (make) -> Void in
            make.centerX.equalTo(self.scrollView)
            make.width.equalTo(self.view.frame.width - 40)
            make.height.equalTo(44.0)
            make.top.equalTo(rowSeven.snp.bottom).offset(60)
        }
    }
    

    // IBActions
   
    @objc func didTapFrequencyButton() {
        let daysOfWeekViewController = HSScheduledSoundsFrequencyViewController()
        daysOfWeekViewController.delegate = self
        daysOfWeekViewController.workingScheduledSound = workingScheduledSound
        self.navigationController?.pushViewController(daysOfWeekViewController, animated: true)
    }
    
    @objc func didTapSelectSoundButton() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let selectSoundViewController = HSScheduledSoundSelectionTableViewController(audioController: appDelegate.audioController)
        selectSoundViewController.delegateWorkingSound = self
        selectSoundViewController.workingScheduledSound = workingScheduledSound
        self.navigationController?.pushViewController(selectSoundViewController, animated: true)
    }
    
    @objc func didTapChangeTitleButton() {
        let labelOrNameViewController = HSScheduleSoundsLabelViewController()
        labelOrNameViewController.delegate = self
        labelOrNameViewController.workingScheduledSound = workingScheduledSound
        self.navigationController?.pushViewController(labelOrNameViewController, animated: true)
    }
    
    @objc func didTapFadeInButton() {

        let pickerFadeIn = HSScheduledSoundsFadePickerViewController()
        pickerFadeIn.isFadeInPicker = true
        pickerFadeIn.delegate = self
        pickerFadeIn.workingScheduledSound = workingScheduledSound
        self.navigationController?.pushViewController(pickerFadeIn, animated: true)
    }
    
    @objc func didTapFadeOutButton() {
  
        let pickerFadeOut = HSScheduledSoundsFadePickerViewController()
        pickerFadeOut.isFadeInPicker = false
        pickerFadeOut.delegate = self
        pickerFadeOut.workingScheduledSound = workingScheduledSound
        self.navigationController?.pushViewController(pickerFadeOut, animated: true)
    }
    
    
    @objc func didTapStartTimeButton() {
        
        let pickerStopTime = HSScheduledSoundsStartStopTimesViewController()
        pickerStopTime.isStartTimePicker = true
        pickerStopTime.delegate = self
        pickerStopTime.workingScheduledSound = workingScheduledSound
        self.navigationController?.pushViewController(pickerStopTime, animated: true)
    }
    
    @objc func didTapStopTimeButton() {
        
        let pickerStartTime = HSScheduledSoundsStartStopTimesViewController()
        pickerStartTime.isStartTimePicker = false
        pickerStartTime.delegate = self
        pickerStartTime.workingScheduledSound = workingScheduledSound
        self.navigationController?.pushViewController(pickerStartTime, animated: true)
    }
    

    // CRUD Functions
    @objc func saveNewScheduledSound() {
        
        if isValidScheduledSound() == false {
            showFailsValidationAlert()
            return
        }
        
        if isNewlyCreatedSound {
            workingScheduledSound?.data?.isActive = true
        }
        
        // Check Permissions
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.requestPermissionForNotifications()
        
        
        if workingScheduledSound?.data?.shouldSync == true {
            workingScheduledSound?.data?.shouldSync = false
            workingScheduledSound?.saveData(sync: true)
        } else {
            workingScheduledSound?.saveData(sync: false)
        }
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: ScheduledSoundsManager.kScheduledSoundsDidRefresh), object: nil, userInfo: nil)

        self.navigationController?.popViewController(animated: true)

    }
    
    @objc func cancelNewScheduledSound() {
        deleteScheduledSound()
    }
    
    
    @objc func didTapDelete() {
        let alertController = UIAlertController(title: NSLocalizedString("DELETE", comment: ""), message: NSLocalizedString("SCHEDULED_SOUNDS_DELETE_ALERT_DESCRIPTION", comment: ""), preferredStyle: .alert)
      
        let okAction = UIAlertAction(title: NSLocalizedString("DELETE", comment: ""), style: .destructive) {
            (action) in
            HSTrack.trackEvent("ScheduledSounds/Delete/True")
            self.deleteScheduledSound()
        }
        
        alertController.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("CANCEL", comment: ""), style: .cancel) {
            (action) in
            HSTrack.trackEvent("ScheduledSounds/Delete/False")
        }
        
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true) {
        }
    }
    
    
    func isValidScheduledSound() -> Bool {
        if ((workingScheduledSound?.data?.startTime) == nil) {
            return false
        }
        
        if ((workingScheduledSound?.data?.stopTime) == nil) {
            return false
        }
        
        if ((workingScheduledSound?.data?.repeatFrequency) == nil) {
            return false
        }
        
        if ((workingScheduledSound?.data?.soundOrMix) == nil) {
            return false
        }
        
        return true
    }
    
    func showFailsValidationAlert() {
        let alertController = UIAlertController(title: NSLocalizedString("SCHEDULED_SOUNDS", comment: ""), message: NSLocalizedString("SCHEDULED_SOUNDS_REQUIRED_FIELDS", comment: ""), preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) {
            (action) in
        })
        
        self.present(alertController, animated: true, completion: {
        })
    }
    
    override func updateColors() {
        super.updateColors()
    }
    

    func deleteScheduledSound() {
        workingScheduledSound?.deleteScheduledSoundItem()
                
        self.delegate?.scheduledSoundDidDelete()
        NotificationCenter.default.post(name: Notification.Name(rawValue: ScheduledSoundsManager.kScheduledSoundsDidRefresh), object: nil, userInfo: nil)

        self.navigationController?.popViewController(animated: true)
    }
    
    func updateFrequencyLabel() {
        guard let workingScheduledSoundData = workingScheduledSound!.data else {
            btnRepeatAnswer.setTitle(NSLocalizedString("SCHEDULED_SOUNDS_EVERY_DAY", comment: ""), for: .normal)
            return
        }
        
        btnRepeatAnswer.setTitle(workingScheduledSoundData.repeatFrequencyAsNaturalString(), for: .normal)
    }
    
    @objc func didPressDoneOnModal() {
        self.dismiss(animated: true, completion: nil)
    }

    
    override func accessibilityPerformEscape() -> Bool {
        didPressDoneOnModal()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}



// HSSchedule Sound Delegate

extension HSScheduledSoundsDetailViewController : HSScheduledSoundDelegate {
    
    func scheduledSoundDidChange(scheduleSound: ScheduledSoundsDocument) {
        refreshData()
    }
    
    func refreshData() {
        let scheduleSound = self.workingScheduledSound!
        
        if scheduleSound.data?.title == "" {
            btnTitleAnswer.setTitle(NSLocalizedString("SCHEDULED_SOUNDS_LABEL_NONE", comment: ""), for: .normal)
        } else {
            btnTitleAnswer.setTitle(scheduleSound.data?.title, for: .normal)
        }
        
        let durationFadeIn = workingScheduledSound?.data?.fadeInDuration
        let stringFadeIn: String
        if durationFadeIn != nil {
            let dateComponents = HSDateUtil.hoursMinSecsDateComponentsFromSeconds(durationFadeIn!)
            stringFadeIn = DateComponentsFormatter.localizedString(from: dateComponents, unitsStyle: .short)!
        } else {
            stringFadeIn = ""
        }
        btnFadeInAnswer.setTitle(stringFadeIn, for: .normal)
        
        let durationFadeOut = workingScheduledSound?.data?.fadeOutDuration
        let stringFadeOut: String
        if durationFadeOut != nil {
            let dateComponents = HSDateUtil.hoursMinSecsDateComponentsFromSeconds(durationFadeOut!)
            stringFadeOut = DateComponentsFormatter.localizedString(from: dateComponents, unitsStyle: .short)!
        } else {
            stringFadeOut = ""
        }
        btnFadeOutAnswer.setTitle(stringFadeOut, for: .normal)
        
        updateFrequencyLabel()
        
        if ((workingScheduledSound?.data?.startTime) == nil) {
            btnStartTimeAnswer.setTitle(NSLocalizedString("SCHEDULED_SOUNDS_LABEL_NONE", comment: ""), for: .normal)
        } else {
            btnStartTimeAnswer.setTitle(workingScheduledSound?.data?.startTime, for: .normal)
        }
        
        if workingScheduledSound?.data?.stopTime == nil {
            btnStopTimeAnswer.setTitle(NSLocalizedString("SCHEDULED_SOUNDS_LABEL_NONE", comment: ""), for: .normal)
        } else {
            btnStopTimeAnswer.setTitle(workingScheduledSound?.data?.stopTime, for: .normal)
        }
        
        if workingScheduledSound?.data?.soundOrMix == nil {
            btnSoundAnswer.setTitle(NSLocalizedString("SCHEDULED_SOUNDS_LABEL_NONE", comment: ""), for: .normal)
        } else {
            let name = workingScheduledSound!.data!.soundOrMix!.title
            let category = workingScheduledSound!.data!.soundOrMix!.category
            
            let soundQuerier = HSSoundQuerier()
            let sound = soundQuerier.findByTitle(name, category: category)
            
            btnSoundAnswer.setTitle(sound!.localizedTitle(), for: .normal)
        }
    }
}

extension UIScrollView {
    func updateContentView() {
        contentSize.height = subviews.sorted(by: { $0.frame.maxY < $1.frame.maxY }).last?.frame.maxY ?? contentSize.height + 30
    }
}
