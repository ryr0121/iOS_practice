import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var todoListTableView: UITableView!
    var doneEditBtn: UIBarButtonItem?
    var tasks = [TaskDataModel]() {
        didSet {
            saveTask()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.doneEditBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBtnDidTap))
        self.todoListTableView.dataSource = self
        self.todoListTableView.delegate = self
        loadTask()
    }
    
    @objc func doneBtnDidTap() {
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.todoListTableView.setEditing(false, animated: true)
    }

    @IBAction func editBtnDidTap(_ sender: Any) {
        guard !self.tasks.isEmpty else { return }
        self.navigationItem.leftBarButtonItem = self.doneEditBtn
        self.todoListTableView.setEditing(true, animated: true)
    }
    
    @IBAction func addBtnDidTap(_ sender: Any) {
        let addTaskAlert = UIAlertController(title: "새로운 할 일", message: nil, preferredStyle: .alert)
        let addBtn = UIAlertAction(title: "추가", style: .default, handler: { [weak self] _ in
            guard let contents = addTaskAlert.textFields?[0].text else { return }
            let task = TaskDataModel(contents: contents, isDone: false)
            self?.tasks.append(task)
            self?.todoListTableView.reloadData()
        })
        let cancelBtn = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        addTaskAlert.addAction(cancelBtn)
        addTaskAlert.addAction(addBtn)
        addTaskAlert.addTextField(configurationHandler: { textField in
            textField.placeholder = "할 일을 입력해주세요"
        })
        self.present(addTaskAlert, animated: true, completion: nil)
    }
    
    func saveTask() {
        let data = self.tasks.map {
            [
                "contents": $0.contents,
                "isDone": $0.isDone
            ]
        }
        UserDefaults.standard.set(data, forKey: "tasks")
    }
    
    func loadTask() {
        guard let data = UserDefaults.standard.object(forKey: "tasks") as? [[String: Any]] else { return }
        self.tasks = data.compactMap{
            guard let contents = $0["contents"] as? String else { return nil }
            guard let isDone = $0["isDone"] as? Bool else { return nil }
            return TaskDataModel(contents: contents, isDone: isDone)
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let taskCell = todoListTableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        taskCell.textLabel?.text = self.tasks[indexPath.row].contents
        if self.tasks[indexPath.row].isDone {
            taskCell.accessoryType = .checkmark
        } else {
            taskCell.accessoryType = .none
        }
        return taskCell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.tasks.remove(at: indexPath.row)
        todoListTableView.deleteRows(at: [indexPath], with: .automatic)
        if self.tasks.isEmpty {
            self.doneBtnDidTap()
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var tasks = self.tasks
        let task = tasks[sourceIndexPath.row]
        tasks.remove(at: sourceIndexPath.row)
        tasks.insert(task, at: destinationIndexPath.row)
        self.tasks = tasks
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var task = self.tasks[indexPath.row]
        task.isDone = !task.isDone
        self.tasks[indexPath.row] = task
        self.todoListTableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
