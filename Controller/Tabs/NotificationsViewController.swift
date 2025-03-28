import UIKit

enum UserNotificationType {
    case like(post: Userpost)
    case follow(state: FollowState)
}

struct UserNotification {
    let type: UserNotificationType
    let text: String
    let user: User
}

final class NotificationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = false
        tableView.register(NotificationLikeEventTableViewCell.self,
                           forCellReuseIdentifier: NotificationLikeEventTableViewCell.identifier)
        tableView.register(NotificationFollowEventTableViewCell.self,
                           forCellReuseIdentifier: NotificationFollowEventTableViewCell.identifier)
        return tableView
    }()

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.tintColor = .label
        return spinner
    }()

    private lazy var noNotificationsView = NoNotificationsView()

    private var models = [UserNotification]()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNotifications()
        navigationItem.title = "Notifications"
        view.backgroundColor = .systemBackground
        view.addSubview(spinner)
     //   spinner.startAnimating()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        spinner.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        spinner.center = view.center
    }

    private func fetchNotifications() {
        for i in 0...100 {
            let user = User(username: "joe",
                             bio: "",
                             name: (first: "", last: ""),
                             birthDate: Date(),
                             gender: .male,
                             counts: UserCount(followers: 1, following: 1, posts: 1),
                             joindate: Date(), // Make sure you use joindate here, not joinDate
                             profilePhoto: URL(string: "https://www.google.com")!)

            let post = Userpost(identifier: "",
                                 postType: .photo, // Make sure it's Userpost, not UserPost
                                 thumbnailImage: URL(string: "https://www.google.com/")!,
                                 postURL: URL(string: "https://www.google.com/")!,
                                 caption: nil as String?, // Provide the type information or remove the assignment if it's optional
                                 likeCount: [],
                                 comments: [],
                                 createdDate: Date(),
                                 taggedUsers: [],
                                 owner: user)

                                               
                                               
             let model = UserNotification(type: i % 2 == 0 ? .like(post: post) : .follow(state: .not_following),
                                          text: "Hello World",
                                          user: user)
             models.append(model)
         }
    }

    private func addNoNotificationsView() {
        tableView.isHidden = true
        view.addSubview(tableView)
        noNotificationsView.frame = CGRect(x: 0, y: 0, width: view.width/2, height: view.width/4)
        noNotificationsView.center = view.center
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        switch model.type {
        case .like(_):
            // like cell
            let cell = tableView.dequeueReusableCell(withIdentifier: NotificationLikeEventTableViewCell.identifier,
                                                     for: indexPath) as! NotificationLikeEventTableViewCell
            cell.configure(with: model)
            cell.delegate = self
            return cell
        case .follow:
            // follow cell
            let cell = tableView.dequeueReusableCell(withIdentifier: NotificationFollowEventTableViewCell.identifier,
                                                     for: indexPath) as! NotificationFollowEventTableViewCell
         //   cell.configure(with: model)
            cell.delegate = self
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
}
extension NotificationsViewController: NotificationLikeEventTableViewCellDelegate {
    func didTapRelatedPostButton(model: UserNotification) {
        switch model.type {
        case .like(let post):
            let vc = PostViewController(model: post)
            vc.title = post.postType.rawValue
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .follow(_):
            fatalError("Dev Issue: Should never get called")
        }
    }
}


extension NotificationsViewController: NotificationFollowEventTableViewCellDelegate {
    func didTapFollowUnFollowButton(model: UserNotification) {
        print("tapped button")
    }
    
    func didClickFollowUnFollowButton(model: UserNotification) {
        print("tapped button")
        // perform database update
    }
}

