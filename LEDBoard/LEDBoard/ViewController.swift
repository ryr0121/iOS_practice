import UIKit

class ViewController: UIViewController, LEDBoardSetting {
    func changedSetting(text: String?, textColor: UIColor, backgroundColor: UIColor) {
        if let text = text {
            self.ledTextLabel.text = text
        }
        self.ledTextLabel.textColor = textColor
        self.view.backgroundColor = backgroundColor
    }

    @IBOutlet weak var ledTextLabel: UILabel!
    @IBOutlet var viewLongPressGesture: UILongPressGestureRecognizer!
    @IBOutlet var viewTapGesture: UITapGestureRecognizer!
    
    var longPressTagFlag = false
    var tapTagFlag = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewLongPressGesture.addTarget(self, action: #selector(viewLongPressed(_:)))
        self.viewTapGesture.addTarget(self, action: #selector(viewTapped(_:)))

    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let settingViewController = segue.destination as? SettingLEDViewController {
            settingViewController.delegate = self
            settingViewController.ledText = self.ledTextLabel.text
            settingViewController.ledTextColor = self.ledTextLabel.textColor
            settingViewController.ledBackgroundColor = self.view.backgroundColor
        }
    }
    
    @objc func viewLongPressed(_ sender: UILongPressGestureRecognizer){
        if !longPressTagFlag {
            UIView.animate(withDuration: 1, animations: {
                self.ledTextLabel.font = UIFont.boldSystemFont(ofSize: 70)
                self.view.layoutIfNeeded()
            }, completion: { _ in
                self.longPressTagFlag = true
            })
            
        } else {
            UIView.animate(withDuration: 1, animations: {
                self.ledTextLabel.font = UIFont.boldSystemFont(ofSize: 50)
                self.view.layoutIfNeeded()
            }, completion: { _ in
                self.longPressTagFlag = false
            })
            
        }
    }
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer){
        debugPrint("Tap 제스처 실행됨")

        if !tapTagFlag {
            UIView.animate(withDuration: 1, animations: {
                let tempColor = self.ledTextLabel.textColor
                self.ledTextLabel.textColor = self.view.backgroundColor
                self.view.backgroundColor = tempColor
                debugPrint("Tap 제스처 실행됨")
                self.view.layoutIfNeeded()
            }, completion: { _ in
                self.tapTagFlag = true
            })
            
        } else {
            UIView.animate(withDuration: 1, animations: {
                let tempColor = self.ledTextLabel.textColor
                self.ledTextLabel.textColor = self.view.backgroundColor
                self.view.backgroundColor = tempColor
                debugPrint("Tap 제스처 실행됨")
                self.view.layoutIfNeeded()
            }, completion: { _ in
                self.tapTagFlag = false
            })
            
        }
    }
    
}

