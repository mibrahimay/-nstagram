import UIKit
struct EditProfileForModel {
    let label : String
    let placeholder : String
    var value : String?
}
class EditProfileViewController: UIViewController, UITableViewDataSource {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FormTableViewCell.self, forCellReuseIdentifier: FormTableViewCell.identifier)
        return tableView
    }()
    private var models = [[EditProfileForModel]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureModels()
        tableView.tableHeaderView = createTableHeaderView()
        tableView.dataSource = self
        view.addSubview(tableView)
        view.backgroundColor = .systemBackground
        navigationItem.title = "Edit Profile"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didClickSave))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didClickCancel))
    }
    private func configureModels() {
        //name , username , website, bio  
        let section1labels = ["name","username","bio"]
        var section = [EditProfileForModel]()
        for label in section1labels {
            let model = EditProfileForModel (
                label: label, placeholder: "Enter \(label)...", value: nil)
            section.append(model)
        }
        models.append(section)
        
        let section2labels = ["email","phone","gender"]
        var section2 = [EditProfileForModel]()
        for label in section2labels {
            let model = EditProfileForModel (
                label: label, placeholder: "Enter \(label)...", value: nil)
            section2.append(model)
        }
        models.append(section2)
        //email , phone , gender
    }
        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func createTableHeaderView() -> UIView {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height / 4))
        
        let size = header.bounds.height / 1.5
        let profilePicButton = UIButton(frame: CGRect(x: (header.bounds.width - size) / 2, y: (header.bounds.height - size) / 2, width: size, height: size))
        
        profilePicButton.layer.masksToBounds = true
        profilePicButton.layer.cornerRadius = size / 2.0
        profilePicButton.addTarget(self, action: #selector(didClickProfilePicture), for: .touchUpInside)
        profilePicButton.setBackgroundImage(UIImage(systemName: "person.circle")?.withRenderingMode(.alwaysOriginal), for: .normal)
        profilePicButton.tintColor = .systemBlue

        profilePicButton.layer.borderWidth = 1
        profilePicButton.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        
        header.addSubview(profilePicButton)
        
        return header
    }
    
    @objc private func didClickProfilePicture() {
        // Handle profile picture button click
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: FormTableViewCell.identifier, for: indexPath) as! FormTableViewCell
        cell.configure(with: model)
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section == 1 else  {
            return nil
        }
        return "Private Information"
    }
    
    @objc private func didClickSave() {
        
        // Save info to database
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didClickCancel() {
        dismiss(animated: true, completion: nil)
    }
}
extension EditProfileViewController: FormTableViewCellDelegate {
    func formTableViewCell(cell: FormTableViewCell, didUpdateField updatedModel: EditProfileForModel) {
        // Implement your logic here to handle the updated model
        print (updatedModel.value ?? "nil")
    }
}

