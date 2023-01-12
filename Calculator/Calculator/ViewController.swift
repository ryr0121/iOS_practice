import UIKit

class ViewController: UIViewController {
    
    enum Operation {
        case Plus
        case Minus
        case Multiple
        case Divide
        case unknown
    }
    
    @IBOutlet weak var resultLabel: UILabel!
    
    var displayNum = ""
    var firstOperand = ""
    var secondOperand = ""
    var result = ""
    var currentOperation: Operation = .unknown
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func numBtnDidTap(_ sender: UIButton) {
        guard let numValue = sender.titleLabel?.text else { return }
        if self.displayNum.count < 9 {
            self.displayNum += numValue
            self.resultLabel.text = self.displayNum
        }
    }
    
    @IBAction func clearBtnDidTap(_ sender: UIButton) {
        self.displayNum = ""
        self.firstOperand = ""
        self.secondOperand = ""
        self.result = ""
        self.currentOperation = .unknown
        self.resultLabel.text = "0"
    }
    
    @IBAction func dotbtnDidTap(_ sender: UIButton) {
        if self.displayNum.count < 8, !self.displayNum.contains(".") {
            self.displayNum += self.displayNum.isEmpty ? "0." : "."
            self.resultLabel.text = self.displayNum
        }
    }
    
    @IBAction func divideBtnDidTap(_ sender: UIButton) {
        self.operation(.Divide)
    }
    
    @IBAction func multipleBtnDidTap(_ sender: UIButton) {
        self.operation(.Multiple)
    }
    
    @IBAction func minusBtnDidTap(_ sender: UIButton) {
        self.operation(.Minus)
    }
    
    @IBAction func plusBtnDidTap(_ sender: UIButton) {
        self.operation(.Plus)
    }
    
    @IBAction func equalBtnDidTap(_ sender: UIButton) {
        self.operation(self.currentOperation)
    }
    
    func operation(_ operation: Operation){
        if self.currentOperation != .unknown {
            if !self.firstOperand.isEmpty {
                self.secondOperand = self.displayNum
                
                guard let firstOperand = Double(self.firstOperand) else { return }
                guard let secondOperand = Double(self.secondOperand) else { return }
                
                switch self.currentOperation {
                case .Plus:
                    self.result = "\(firstOperand + secondOperand)"
                case .Minus:
                    self.result = "\(firstOperand - secondOperand)"
                case .Multiple:
                    self.result = "\(firstOperand * secondOperand)"
                case .Divide:
                    self.result = "\(firstOperand / secondOperand)"
                default:
                    break
                }
            }
            
            if let result = Double(self.result), result.truncatingRemainder(dividingBy: 1) == 0 {
                self.result = "\(Int(result))"
                self.resultLabel.text = self.result
            }
        } else {
            self.firstOperand = self.displayNum
            self.currentOperation = operation
            self.displayNum = ""
        }
    }
}

