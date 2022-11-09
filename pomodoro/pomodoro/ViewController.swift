//
//  ViewController.swift
//  pomodoro
//
//  Created by 김초원 on 2022/11/09.
//


import UIKit
import AudioToolbox

enum TimeStatus {
    case start
    case pause
    case end
}

class ViewController: UIViewController {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var toggleBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    var duration = 60  // 60 sec
    var timerStatus: TimeStatus = .end
    var timer: DispatchSourceTimer?
    var currentSecond = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureToggleButton()
    }
    
    func setTimerInfoViewVisible(isHidden: Bool) {
        self.timerLabel.isHidden = isHidden
        self.progressView.isHidden = isHidden
    }
    
    func configureToggleButton() {
        self.toggleBtn.setTitle("시작", for: .normal)
        self.toggleBtn.setTitle("일시정지", for: .selected)
    }
    
    func startTimer() {
        if self.timer == nil {
            self.timer = DispatchSource.makeTimerSource(flags: [], queue: .main)
            self.timer?.schedule(deadline: .now(), repeating: 1)
            self.timer?.setEventHandler(handler: { [weak self] in
                guard let self = self else { return }
                self.currentSecond -= 1
                let hour = self.currentSecond / 3600
                let min = (self.currentSecond % 3600) / 60
                let sec = (self.currentSecond % 3600) % 60
                self.timerLabel.text = String(format: "%02d:%02d:%02d", hour, min, sec)
                self.progressView.progress = Float(self.currentSecond) / Float(self.duration)
                
                UIView.animate(withDuration: 0.5, delay: 0, animations: {
                    self.imageView.transform = CGAffineTransform(rotationAngle: .pi)
                })
                
                UIView.animate(withDuration: 0.5, delay: 0.5, animations: {
                    self.imageView.transform = CGAffineTransform(rotationAngle: .pi * 2)
                })
                
                if self.currentSecond <= 0{
                    // 타이머 종료
                    self.stopTimer()
                    AudioServicesPlaySystemSound(1005)
                }
            })
            self.timer?.resume()
        }
    }
    
    func stopTimer() {
        if self.timerStatus == .pause {
            self.timer?.resume()
        }
        self.timerStatus = .end
        self.cancelBtn.isEnabled = false
//        self.setTimerInfoViewVisible(isHidden: true)
//        self.datePicker.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
            self.timerLabel.alpha = 0
            self.progressView.alpha = 0
            self.datePicker.alpha = 1
            self.imageView.transform = .identity
        })
        self.toggleBtn.isSelected = false
        self.timer?.cancel()
        self.timer = nil // 메모리 해제
    }

    @IBAction func cancelBtnDidTap(_ sender: UIButton) {
        switch self.timerStatus {
        case .start, .pause:
            self.stopTimer()
            
        default:
            break
        }
    }
    
    
    @IBAction func toggleBtnDidTap(_ sender: UIButton) {
        self.duration = Int(self.datePicker.countDownDuration)
        switch self.timerStatus {
        case .end:
            self.currentSecond = self.duration
            self.timerStatus = .start
//            self.setTimerInfoViewVisible(isHidden: false)
//            self.datePicker.isHidden = true
            UIView.animate(withDuration: 0.5, animations: {
                self.timerLabel.alpha = 1
                self.progressView.alpha = 1
                self.datePicker.alpha = 0
            })
            self.toggleBtn.isSelected = true
            self.cancelBtn.isEnabled = true
            self.startTimer()
            
        case .start:
            self.timerStatus = .pause
            self.toggleBtn.isSelected = false
            self.timer?.suspend()
        
        case .pause:
            self.timerStatus = .start
            self.toggleBtn.isSelected = true
            self.timer?.resume()
            
        default:
            break
        }
    }
    
}

