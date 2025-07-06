//
//  PostCell.swift
//  RestMobileSocialList
//
//  Created by Олег Дмитриев on 06.07.2025.
//

import UIKit

class PostCell: UITableViewCell {
    static let reuseID = "PostCell"
    
    private lazy var builder = UIBuilder()
    
    private lazy var cellPost: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .appWhite
        $0.addSubviews(userAvatar, userName, postDate, postThumbnail, postCommentStackView, postLikeStackView)
        return $0
    }(UIView())
    
    private lazy var userAvatar: UIImageView = builder.addImage("gabriella-avatar", scale: .scaleAspectFill)
    private lazy var userName: UILabel = builder.addLabel("", fz: 20, numLine: 1)
    private lazy var postDate: UILabel = builder.addLabel("", color: .appGray)

    private lazy var postThumbnail: UIImageView = builder.addImage("gabriella-avatar", scale: .scaleAspectFill)
    
    // MARK: CommentView + Label + Button
    private lazy var postCommentStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fillProportionally
        $0.alignment = .trailing

        $0.addArrangedSubview(postCommentsCount)
        $0.addArrangedSubview(postCommentsIcon)
        return $0
    }(UIStackView())
    private lazy var postCommentsCount: UILabel = builder.addLabel("", fz: 18, numLine: 1)
    private lazy var postCommentsIcon: UIImageView = builder.addImage("icon-comment")
    
    // MARK: LikeView + Label + Button
    private lazy var postLikeStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fillProportionally
        $0.alignment = .trailing

        $0.addArrangedSubview(postLikeCount)
        $0.addArrangedSubview(postLikeBtn)
        return $0
    }(UIStackView())
    private lazy var postLikeCount: UILabel = builder.addLabel("", fz: 18, numLine: 1)
    private lazy var postLikeBtn: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.widthAnchor.constraint(equalToConstant: 24).isActive = true
        $0.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        $0.setBackgroundImage(UIImage(named: "icon-heart"), for: .normal)
        $0.contentMode = .scaleAspectFill
        
        $0.addTarget(self, action: #selector(handleLikeBtnTapped), for: .touchUpInside)
        
        return $0
    }(UIButton())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .appBg
        contentView.addSubview(cellPost)

        setupUIAndConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUIAndConstraints() {
        cellPost.layer.cornerRadius = 12
        cellPost.layer.masksToBounds = true
        
        let userAvatarWidth: CGFloat = 42
        userAvatar.layer.cornerRadius = userAvatarWidth / 2
        
        postCommentsCount.textAlignment = .right
        postCommentsIcon.widthAnchor.constraint(equalToConstant: 24).isActive = true
        postCommentsIcon.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        postLikeCount.textAlignment = .right

        NSLayoutConstraint.activate([
            cellPost.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 9),
            cellPost.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: builder.offsetPage),
            cellPost.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -builder.offsetPage),
            
            userAvatar.topAnchor.constraint(equalTo: cellPost.topAnchor, constant: 12),
            userAvatar.leadingAnchor.constraint(equalTo: cellPost.leadingAnchor, constant: 12),
            userAvatar.widthAnchor.constraint(equalToConstant: userAvatarWidth),
            userAvatar.heightAnchor.constraint(equalToConstant: userAvatarWidth),
            
            userName.centerYAnchor.constraint(equalTo: userAvatar.centerYAnchor),
            userName.leadingAnchor.constraint(equalTo: userAvatar.trailingAnchor, constant: 12),
            userName.widthAnchor.constraint(equalToConstant: 180),
            
            postDate.centerYAnchor.constraint(equalTo: userAvatar.centerYAnchor),
            postDate.trailingAnchor.constraint(equalTo: cellPost.trailingAnchor, constant: -12),
            postDate.widthAnchor.constraint(equalToConstant: 80),
            
            postThumbnail.topAnchor.constraint(equalTo: userAvatar.bottomAnchor, constant: 12),
            postThumbnail.leadingAnchor.constraint(equalTo: cellPost.leadingAnchor, constant: 0),
            postThumbnail.trailingAnchor.constraint(equalTo: cellPost.trailingAnchor, constant: 0),
            postThumbnail.heightAnchor.constraint(equalToConstant: 244),

            postCommentStackView.topAnchor.constraint(equalTo: postThumbnail.bottomAnchor, constant: 12),
            postCommentStackView.trailingAnchor.constraint(equalTo: cellPost.trailingAnchor, constant: -12),
            postCommentStackView.widthAnchor.constraint(equalToConstant: 62),
            
            postLikeStackView.topAnchor.constraint(equalTo: postThumbnail.bottomAnchor, constant: 12),
            postLikeStackView.trailingAnchor.constraint(equalTo: postCommentStackView.leadingAnchor, constant: -12),
            postLikeStackView.widthAnchor.constraint(equalToConstant: 62),
            
            cellPost.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -9),
        ])
    }
    
    func configure(item: Post) {
        self.userAvatar.image = UIImage(named: item.userAvatar)
        self.userName.text = item.userName
        
        self.postDate.text = item.postDate
        self.postThumbnail.image = UIImage(named: item.postThumbnail)
        
        self.postCommentsCount.text = "\(item.comments.count)"
        self.postLikeCount.text = "\(item.like)"
    }
    
    @objc
    func handleLikeBtnTapped() {
        print("Like")
    }
}
