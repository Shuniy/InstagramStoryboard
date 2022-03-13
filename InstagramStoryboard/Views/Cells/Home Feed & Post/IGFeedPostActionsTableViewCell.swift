//
//  IGFeedPostActionsTableViewCell.swift
//  InstagramStoryboard
//
//  Created by Shubham Kumar on 26/02/22.
//

import UIKit

class IGFeedPostActionsTableViewCell: UITableViewCell {
    static let identifier = "IGFeedPostActionsTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemGreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure() {
        //configure cell
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}
