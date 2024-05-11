import UIKit
import FirebaseAuth

struct HomeFeedRenderViewModel {
    
    let header : PostRenderViewModel
    let post : PostRenderViewModel
    let actions: PostRenderViewModel
    let comments :PostRenderViewModel
}
class HomeViewController: UIViewController {
    private var feedRenderModels = [HomeFeedRenderViewModel]()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        // Additional setup for your tableView if needed
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createMockModels()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        tableView.register(HeaderPostTableViewCell.self, forCellReuseIdentifier: HeaderPostTableViewCell.identifier)
          // Assuming you have another cell class named AllPostsTableViewCell, make sure to register it as well if you haven't already
        tableView.register(AllPostsTableViewCell.self, forCellReuseIdentifier: AllPostsTableViewCell.identifier)
          // Assuming you have another cell class named PostTableViewCellActions, make sure to register it as well if you haven't already
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
        tableView.register(PostTableViewCellActions.self, forCellReuseIdentifier: PostTableViewCellActions.identifier)

    }
    private func createMockModels(){
        let user = User(username: "@ibrahimay",
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
        var comments = [PostComment]()
        for i in 0..<2 {
            comments.append(PostComment(identifier: "\(i)", username: "@ibrahimay", text: "", createdDate: Date(), likes: []
                )
            )
        }
        
        for i in 0..<5{
            let viewModel = HomeFeedRenderViewModel(header: PostRenderViewModel(renderType: .header(provider: user)), post: PostRenderViewModel(renderType: .primaryContent(provider: post)), actions: PostRenderViewModel(renderType: .actions(provider: "")), comments: PostRenderViewModel(renderType: .comments(comments: comments )))
            feedRenderModels.append(viewModel)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleNotAuthenticated()
    }
    
    private func handleNotAuthenticated() {
        if Auth.auth().currentUser == nil {
            let loginVC = LoginViewController()
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: false)
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return feedRenderModels.count * 4
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let x = section
        let model: HomeFeedRenderViewModel
        if x == 0 {
            model = feedRenderModels[0]
        }
        else {
            let position = x % 4 == 0 ? x/4 : ((x - (x % 4)) / 4)
            model = feedRenderModels[position]
        }

        let subSection = x % 4

        if subSection == 0 {
            // header
            return 1
        }
        else if subSection == 1 {
            // post
            return 1
        }
        else if subSection == 2 {
            // actions
            return 1
        }
        else if subSection == 3 {
            // comments
            let commentsModel = model.comments
            switch commentsModel.renderType {
            case .comments(let comments): return comments.count > 2 ? 2 : comments.count
            case .header, .actions, .primaryContent: return 0
            }
        }

        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let x = indexPath.section
        let model: HomeFeedRenderViewModel
        if x == 0 {
            model = feedRenderModels[0]
        }
        else {
            let position = x % 4 == 0 ? x/4 : ((x - (x % 4)) / 4)
            model = feedRenderModels[position]
        }

        let subSection = x % 4

        if subSection == 0 {
            // header
            switch model.header.renderType {
            case .header(let user):
                let cell = tableView.dequeueReusableCell(withIdentifier: HeaderPostTableViewCell.identifier,
                                                         for: indexPath) as! HeaderPostTableViewCell
                cell.configure(with: user)
                //      cell.configure(with: user)
                cell.delegate = self
                return cell
            case .comments, .actions, .primaryContent: return UITableViewCell()
            }
        }
        else if subSection == 1 {
            // post
            switch model.post.renderType {
            case .primaryContent(let post):
                let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier,
                                                         for: indexPath) as! PostTableViewCell
                cell.configure(with: post)
                return cell
            case .comments, .actions, .header: return UITableViewCell()
            }
        }
        else if subSection == 2 {
            // actions
            switch model.actions.renderType {
            case .actions(let provider):
                let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCellActions.identifier,
                                                         for: indexPath) as! PostTableViewCellActions
                cell.delegate = self
                return cell
            case .comments, .header, .primaryContent:  return UITableViewCell()
            }
        }
        else if subSection == 3 {
            // comments
            switch model.comments.renderType {
            case .comments(let comments):
                let cell = tableView.dequeueReusableCell(withIdentifier: AllPostsTableViewCell.identifier,
                                                         for: indexPath) as! AllPostsTableViewCell
                return cell
            case .header, .actions, .primaryContent: return UITableViewCell()
            }
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let subSection = indexPath.section % 4
        if subSection == 0 {
            // Header
            return 70
        }
        else if subSection == 1 {
            // Post
            return tableView.width
        }
        else if subSection == 2 {
            // Actions (like/comment)
            return 60
        }
        else if subSection == 3 {
            // Comment row
            return 50
        }

        return 0
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let subSection = section % 4
        return subSection == 3 ? 70 : 0
    }
}
extension HomeViewController : HeaderPostTableViewCellDelegate {
    
    func didClickMoreButton() {
        let actionSheet = UIAlertController(title: "Post Options", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Report", style: .destructive ,handler: {[weak self] _ in self?.reportPost()}))

        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel ,handler: nil))
        present(actionSheet,animated: true)
    }
    func reportPost(){
        
    }
    
}
extension HomeViewController : PostTableViewCellDelegate {
    func didClickLikeButton(){
        print("like")
    }
    func didClickCommentButton(){
        print ("comment")
    }
    func didClickSendButton(){
        print("send")
    }
    
}
