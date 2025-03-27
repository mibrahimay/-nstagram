import UIKit


enum PostRenderType {
    case header(provider: User)
    case primaryContent(provider: Userpost) // post
    case actions(provider: String) // like, comment, share
    case comments(comments: [PostComment])
}

/// Model of renderd Post
struct PostRenderViewModel {
    let renderType: PostRenderType
}

class PostViewController: UIViewController {

    private let model: Userpost?

    private var renderModels = [PostRenderViewModel]()

    private let tableView: UITableView = {
        let tableView = UITableView()
        // Register cells
        tableView.register(PostTableViewCell.self,
                           forCellReuseIdentifier: PostTableViewCell.identifier)
        tableView.register(HeaderPostTableViewCell.self,
                           forCellReuseIdentifier: HeaderPostTableViewCell.identifier)
        tableView.register(PostTableViewCellActions.self,
                           forCellReuseIdentifier: PostTableViewCellActions.identifier)
        tableView.register(AllPostsTableViewCell.self,
                           forCellReuseIdentifier: AllPostsTableViewCell.identifier)

        return tableView
    }()



    init(model: Userpost?) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
        configureModels()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureModels() {
        guard let userPostModel = self.model else {
            return
        }
        // Header
        renderModels.append(PostRenderViewModel(renderType: .header(provider: userPostModel.owner)))

        // Post
        renderModels.append(PostRenderViewModel(renderType: .primaryContent(provider: userPostModel)))

        // Actions
        renderModels.append(PostRenderViewModel(renderType: .actions(provider: "")))

        // 4 Comments
        var comments = [PostComment]()
        for x in 0..<4 {
            comments.append(
                PostComment(
                    identifier: "123_\(x)",
                    username: "@dave",
                    text: "Great post!",
                    createdDate: Date(),
                    likes: []
                )
            )
        }
        renderModels.append(PostRenderViewModel(renderType: .comments(comments: comments)))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .systemBackground
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

}

extension PostViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return renderModels.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch renderModels[section].renderType {
        case .actions(_): return 1
        case .comments(let comments): return comments.count > 4 ? 4 : comments.count
        case .primaryContent(_): return 1
        case .header(_): return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = renderModels[indexPath.section]

        switch model.renderType {
            case .actions(let actions):
                let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCellActions.identifier,
                                                         for: indexPath) as! PostTableViewCellActions
                return cell

        case .comments(let comments):
            let cell = tableView.dequeueReusableCell(withIdentifier: AllPostsTableViewCell.identifier,
                                                     for: indexPath) as! AllPostsTableViewCell
            return cell

        case .primaryContent(let post):
            let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier,
                                                     for: indexPath) as! PostTableViewCell
            return cell

        case .header(let user):
            let cell = tableView.dequeueReusableCell(withIdentifier: HeaderPostTableViewCell.identifier,
                                                     for: indexPath) as! HeaderPostTableViewCell
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = renderModels[indexPath.section]
        switch model.renderType {
        case .actions(_): return 60
        case .comments(_): return 50
        case .primaryContent(_): return tableView.width
        case .header(_): return 70
        }
    }
}
