import UIKit
import SafariServices
struct SettingCellModel {
    let title: String
    let handler: (() -> Void)
}

final class SettingsViewController: UIViewController {
    private var tableView: UITableView!
    private var data = [[SettingCellModel]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureModels()
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func configureTableView() {
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    private func configureModels() {
        data.append([
            SettingCellModel(title: "Edit Profile") { [weak self] in
                self?.didClickEditProfile()
            },
            SettingCellModel(title: "Invite Friends") { [weak self] in
                self?.didClickInviteFriends()
            },
            
            SettingCellModel(title: "Save Original Post") { [weak self] in
                self?.didClickSaveOriginalPhoto()
            }
            
        ])
        
        data.append([
            
            SettingCellModel(title: "Terms of Service") { [weak self] in
                self?.openURL(type: .terms)
            },
            SettingCellModel(title: "Privacy Policy") { [weak self] in
                self?.openURL(type: .privacy)
            },
            SettingCellModel(title: "Need help") { [weak self] in
                self?.openURL(type: .help)
            }
        ])
        data.append([
            
            SettingCellModel(title: "Log out") { [weak self] in
                self?.didClicklogOut()
            }
        ])
    }
    
    enum settingsURLType{
        case terms, privacy, help
    }
    private func openURL(type :settingsURLType){
        let urlString :String
        switch type {
        case .terms : urlString = "https://help.instagram.com/581066165581870"
        case .privacy : urlString = "https://help.instagram.com/155833707900388"
        case .help : urlString = "https://help.instagram.com/"
        }
        guard let url = URL(string: urlString) else {
            return
        }
        let vc = SFSafariViewController (url : url)
        present(vc, animated: true)
    }
    private func didClickEditProfile(){
        let vc = EditProfileViewController()
        vc.title =  "Edit Profile"
        let secondVC2 = UINavigationController(rootViewController: vc)
        secondVC2.modalPresentationStyle = .fullScreen
        present(secondVC2, animated: true)
    }
    private func didClickInviteFriends(){
        //show share sheet to invite friend
        
    }
    private func didClickSaveOriginalPhoto(){
        
    }

    private func didClicklogOut() {
        let alert2 = UIAlertController(title: "Log Out", message: "Are you want to log out ?", preferredStyle: .actionSheet)
        alert2.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert2.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { _ in
            AuthManager.shared.logOut { [weak self] success in
                DispatchQueue.main.async {
                    if success {
                        let loginVC = LoginViewController()
                        loginVC.modalPresentationStyle = .fullScreen
                        self?.present(loginVC, animated: true) {
                            self?.navigationController?.popToRootViewController(animated: false)
                            self?.tabBarController?.selectedIndex = 0
                        }
                    } else {
                        // Handle error
                        fatalError("You could not log out")
                    }
                }
            }
        }))
        alert2.popoverPresentationController?.sourceView = tableView
        alert2.popoverPresentationController?.sourceRect = tableView.bounds //for ipad not crash
        present(alert2, animated: true)

    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.section][indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        data[indexPath.section][indexPath.row].handler()
    }
}
