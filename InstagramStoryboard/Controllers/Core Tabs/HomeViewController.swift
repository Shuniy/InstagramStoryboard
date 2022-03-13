//
//  HomeViewController.swift
//  InstagramStoryboard
//
//  Created by Shubham Kumar on 25/02/22.
//
import FirebaseAuth
import UIKit

struct HomeFeedRenderViewModel {
    let header: PostRenderViewModel
    let post: PostRenderViewModel
    let actions: PostRenderViewModel
    let comments: PostRenderViewModel
}

class HomeViewController: UIViewController {
    private let tableView: UITableView = {
        let tableView = UITableView()
        // Register Cells
        tableView.register(IGFeedPostTableViewCell.self, forCellReuseIdentifier: IGFeedPostTableViewCell.identifier)
        tableView.register(IGFeedPostHeaderTableViewCell.self, forCellReuseIdentifier: IGFeedPostHeaderTableViewCell.identifier)
        tableView.register(IGFeedPostActionsTableViewCell.self, forCellReuseIdentifier: IGFeedPostActionsTableViewCell.identifier)
        tableView.register(IGFeedPostGeneralTableViewCell.self, forCellReuseIdentifier: IGFeedPostGeneralTableViewCell.identifier)
        
        return tableView
    }()
    
    private var feedRenderModels = [HomeFeedRenderViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Home"
        tableView.delegate = self
        tableView.dataSource = self
        createMockModels()
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Check auth status
        handleNotAuthenticated()
        
    }
    
    func handleNotAuthenticated() {
        if Auth.auth().currentUser == nil {
            // Show LogIn
            let loginVC = LoginViewController()
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: false, completion: nil)
        } else {
            
        }
    }
    
    func createMockModels() {
        let user = User(username: "Shubham", name: (first: "Shubham", last: "Kumar"), birthDate: Date(), gender: .male, profilePhoto: URL(string: "https://google.com")!, bio: "", counts: UserCount(followers: 1, following: 1, posts: 1), joinDate: Date())
        let userPost = UserPost(identifier: "", postType: .photo, thumbnailImage: URL(string: "https://www.google.com")!, postURL: URL(string: "https://www.google.com")!, caption: "Hello", likeCount: [], comments: [], createdDate: Date(), taggedUser: [], owner: user)
        var comments = [PostComment]()
        for x in 0..<4 {
            comments.append(PostComment(username: "Shubham", text: "Hello World", createdDate: Date(), likes: [], identifier: "comment...\(x)"))
        }
        for _ in 0..<5 {
            let viewModel = HomeFeedRenderViewModel(header: PostRenderViewModel(renderType: .header(provider: user)), post: PostRenderViewModel(renderType: .primaryContent(provider: userPost)), actions: PostRenderViewModel(renderType: .actions(provider: "")), comments: PostRenderViewModel(renderType: .comments(comments: comments)))
            feedRenderModels.append(viewModel)
        }
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let model: HomeFeedRenderViewModel
        if section == 0 {
            model = feedRenderModels[0]
        } else {
            let position = section % 4 == 0 ? section / 4 : (section - (section / 4)) / 4
            model = feedRenderModels[position]
        }
        
        let subsection = section % 4
        if subsection == 0 {
            // header
            return 1
        } else if subsection == 1 {
            // post
            return 1
        } else if subsection == 2 {
            //actions
            return 1
        } else if subsection == 3 {
            //comments
            let commentsModel = model.comments
            switch commentsModel.renderType {
            case .comments(let comments):
                return comments.count > 3 ? 3 : comments.count
            case .actions, .primaryContent, .header: return 0
            }
        }
        
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return feedRenderModels.count * 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model: HomeFeedRenderViewModel
        if indexPath.section == 0 {
            model = feedRenderModels[0]
        } else {
            let position = indexPath.section % 4 == 0 ? indexPath.section / 4 : (indexPath.section - (indexPath.section / 4)) / 4
            model = feedRenderModels[position]
        }
        
        let subsection = indexPath.section % 4
        if subsection == 0 {
            // header
            let headerModel = model.header
            switch headerModel.renderType {
            case .header(let user):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostHeaderTableViewCell.identifier, for: indexPath) as! IGFeedPostHeaderTableViewCell
                return cell
            case .primaryContent:
                return UITableViewCell()
            case .actions:
                return UITableViewCell()
            case .comments:
                return UITableViewCell()
            }
        } else if subsection == 1 {
            // post
            let postModel = model.post
            switch postModel.renderType {
            case .primaryContent(let post):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostTableViewCell.identifier, for: indexPath) as! IGFeedPostTableViewCell
                return cell
            case .header:
                return UITableViewCell()
            case .actions:
                return UITableViewCell()
            case .comments:
                return UITableViewCell()
            }
        } else if subsection == 2 {
            //actions
            let actionModel = model.actions
            switch actionModel.renderType {
            case .actions(let action):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostActionsTableViewCell.identifier, for: indexPath) as! IGFeedPostActionsTableViewCell
                return cell
            case .primaryContent:
                return UITableViewCell()
            case .header:
                return UITableViewCell()
            case .comments:
                return UITableViewCell()
            }
        } else if subsection == 3 {
            //comments
            let commentModel = model.comments
            switch commentModel.renderType {
            case .comments(let comments):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostGeneralTableViewCell.identifier, for: indexPath) as! IGFeedPostGeneralTableViewCell
                return cell
            case .primaryContent:
                return UITableViewCell()
            case .actions:
                return UITableViewCell()
            case .header:
                return UITableViewCell()
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let subsection = indexPath.section % 4
        
        if subsection == 0 {
            return 70
        } else if subsection == 1 {
            return tableView.width
        } else if subsection == 2 {
            return 60
        } else if subsection == 3 {
            return 50
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let subsection = section % 4
        return subsection == 3 ? 70 : 0
    }
}
