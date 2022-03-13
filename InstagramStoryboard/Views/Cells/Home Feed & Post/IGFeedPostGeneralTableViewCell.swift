//
//  IGFeedPostGeneralTableViewCell.swift
//  InstagramStoryboard
//
//  Created by Shubham Kumar on 26/02/22.
//

import UIKit

class IGFeedPostGeneralTableViewCell: UITableViewCell {
    static let identifier = "IGFeedPostGeneralTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemOrange
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
