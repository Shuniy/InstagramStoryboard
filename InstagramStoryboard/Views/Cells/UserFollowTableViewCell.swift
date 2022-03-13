//
//  UserFollowTableViewCell.swift
//  InstagramStoryboard
//
//  Created by Shubham Kumar on 09/03/22.
//

import UIKit

protocol UserFollowTableViewCellDelegate: AnyObject {
    func didTapFollowUnfollowButton(model: UserRelationShip)
}

enum FollowState {
    case following, not_following
}

struct UserRelationShip {
    let username: String
    let name: String
    let type: FollowState
}

class UserFollowTableViewCell: UITableViewCell {
    static let identifier = "UserFollowTableViewCell"
    
    weak var delegate: UserFollowTableViewCellDelegate?
    private var model: UserRelationShip?
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "Shubham"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.text = "@Shubham"
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let followButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .link
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(nameLabel)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(profileImageView)
        contentView.addSubview(followButton)
        followButton.addTarget(self, action: #selector(didTapFollowButton), for: .touchUpInside)
        selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        nameLabel.text = nil
        usernameLabel.text = nil
        followButton.setTitle(nil, for: .normal)
        followButton.layer.borderWidth = 0
        followButton.backgroundColor = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.frame = CGRect(x: 3, y: 3, width: contentView.height - 6, height: contentView.height - 6)
        profileImageView.layer.cornerRadius = profileImageView.height / 2.0
        
        let buttonWidth = contentView.width > 500 ? 220.0 : contentView.width / 3
        
        followButton.frame = CGRect(x: contentView.width - 5 - buttonWidth, y: (contentView.height - 40) / 2, width: buttonWidth, height: 40)
        
        let labelHeight = contentView.height / 2
        nameLabel.frame = CGRect(x: profileImageView.right + 5, y: 0, width: contentView.width - 3 - profileImageView.width, height: labelHeight)
        
        usernameLabel.frame = CGRect(x: profileImageView.right + 5, y: nameLabel.bottom, width: contentView.width - 3 - profileImageView.width, height: labelHeight)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapFollowButton() {
        guard let model = model else {
            return
        }
        delegate?.didTapFollowUnfollowButton(model: model)
    }
    
    public func configure(with model: UserRelationShip) {
        self.model = model
        nameLabel.text = model.name
        usernameLabel.text = model.username
        switch model.type {
        case .following:
            //show unfollow button
            followButton.backgroundColor = .systemBackground
            followButton.layer.borderWidth = 1
            followButton.layer.borderColor = UIColor.label.cgColor
            followButton.setTitleColor(.label, for: .normal)
            followButton.setTitle("Unfollow", for: .normal)
        case .not_following:
            // show follow button
            followButton.backgroundColor = .link
            followButton.layer.borderWidth = 0
            followButton.setTitleColor(.white, for: .normal)
            followButton.setTitle("Follow", for: .normal)
        }
    }
}
