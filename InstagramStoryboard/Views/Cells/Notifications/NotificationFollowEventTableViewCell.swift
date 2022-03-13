//
//  NotificationFollowEventTableViewCell.swift
//  InstagramStoryboard
//
//  Created by Shubham Kumar on 09/03/22.
//

import UIKit

protocol NotificationFollowEventTableViewCellDelegate: AnyObject {
    func didTapFollowUnFollowButton(model: UserNotification)
}

class NotificationFollowEventTableViewCell: UITableViewCell {
    static let identifier = "NotificationFollowEventTableViewCell"
    
    weak var delegate: NotificationFollowEventTableViewCellDelegate?
    private var model: UserNotification?
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .tertiarySystemBackground
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .label
        label.text = "@jhonny started following you"
        return label
    }()
    
    private let followButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(profileImageView)
        contentView.addSubview(label)
        contentView.addSubview(followButton)
        configureForFollow()
        followButton.addTarget(self, action: #selector(didTapFollowButton), for: .touchUpInside)
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapFollowButton() {
        guard let model = model else {
            return
        }
        
        delegate?.didTapFollowUnFollowButton(model: model)
    }
    
    public func configure(with model: UserNotification) {
        self.model = model
        switch model.type {
        case .like(let post):
            break
        case .follow(let state):
            // configure button here
            switch state {
            case .following:
                configureForFollow()
            case .not_following:
                followButton.setTitle("Follow", for: .normal)
                followButton.setTitleColor(.white, for: .normal)
                followButton.layer.borderWidth = 0
                followButton.backgroundColor = .link
            }
        }
        label.text = model.text
        profileImageView.sd_setImage(with: model.user.profilePhoto, completed: nil)
    }
    
    func configureForFollow() {
        followButton.setTitle("Unfollow", for: .normal)
        followButton.setTitleColor(.label, for: .normal)
        followButton.layer.borderColor = UIColor.secondaryLabel.cgColor
        followButton.layer.borderWidth = 1
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        followButton.setTitle(nil, for: .normal)
        followButton.backgroundColor = nil
        followButton.layer.borderWidth = 0
        label.text = nil
        profileImageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // photo, text, post button
        profileImageView.frame = CGRect(x: 3, y: 3, width: contentView.height - 6, height: contentView.height - 6)
        profileImageView.layer.cornerRadius = profileImageView.height / 2
        let size: CGFloat = 100
        let buttonHeight: CGFloat = 40
        followButton.frame = CGRect(x: contentView.width - size - 5, y: (contentView.height - 44) / 2, width: size, height: buttonHeight)
        label.frame = CGRect(x: profileImageView.right + 5, y: 0, width: contentView.width - size - profileImageView.width - 16, height: contentView.height)
    }
}
