//
//  ListViewController.swift
//  Filling
//
//  Created by mac on 17.02.2024.
//

import UIKit

class ListViewController: UIViewController {

    private var data = [UserRelationship]()
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UserFollowTableViewCell.self,forCellReuseIdentifier: UserFollowTableViewCell.identifier)
        return tableView
        
    }()
    init(data: [UserRelationship]) {
        self.data = data
        super.init(nibName: nil , bundle: nil)
    }
    required init?(coder : NSCoder) {
        fatalError("init(coder:)has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        view.backgroundColor = .systemBackground
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}
extension ListViewController: UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserFollowTableViewCell.identifier, for: indexPath) as! UserFollowTableViewCell
        cell.delegate = self
        cell.configure(with: data[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //go to profile of selected cell
        let model = data[indexPath.row]
    }
}
extension ListViewController : UserFollowTableViewCellDelegate{
    func didClickFollowUnfollowButton(model: UserRelationship) {
        switch model.type{
        case .following:
            break
        case .not_following:
            break
        }
    }
}
