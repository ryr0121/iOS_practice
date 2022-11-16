import UIKit

protocol LEDBoardSetting: AnyObject {
    func changedSetting(text: String?, textColor: UIColor, backgroundColor: UIColor)
}

class SettingLEDViewController: UIViewController {

    @IBOutlet weak var ledContentsTextField: UITextField!
    
    @IBOutlet weak var ledTextColorWell: UIColorWell!
    
    @IBOutlet weak var ledBackGroundColorWell: UIColorWell!
    
    var ledText: String?
    var ledTextColor: UIColor!
    var ledBackgroundColor: UIColor!
    weak var delegate: LEDBoardSetting?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ledTextColorWell.addTarget(self, action: #selector(textColorPicked(_:)), for: .valueChanged)
        self.ledBackGroundColorWell.addTarget(self, action: #selector(bgColorPicked(_:)), for: .valueChanged)
        
        configureView()
    }
    
    @objc func textColorPicked(_ sender: Any){
        self.ledTextColor = self.ledTextColorWell.selectedColor
    }
    
    @objc func bgColorPicked(_ sender: Any){
        self.ledBackgroundColor = self.ledBackGroundColorWell.selectedColor
    }
    
    @IBAction func saveBtnDidTap(_ sender: Any) {
        self.delegate?.changedSetting(text: self.ledContentsTextField.text, textColor: self.ledTextColor, backgroundColor: self.ledBackgroundColor)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func configureView(){
        if let ledText = self.ledText {
            self.ledContentsTextField.text = ledText
        }
        self.ledTextColorWell.selectedColor = self.ledTextColor
        self.ledBackGroundColorWell.selectedColor = self.ledBackgroundColor
    }
    
}
