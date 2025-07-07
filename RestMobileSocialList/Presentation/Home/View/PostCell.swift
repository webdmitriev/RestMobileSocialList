//
//  PostCell.swift
//  RestMobileSocialList
//
//  Created by Олег Дмитриев on 06.07.2025.
//

import UIKit

protocol PostCellDelegate: AnyObject {
    func postDidUpdateSaveState(postId: Int, isSaved: Bool)
}

class PostCell: UITableViewCell {
    static let reuseID = "PostCell"
    weak var delegate: PostCellDelegate?
    
    private lazy var builder = UIBuilder()
    private var imageLoadTask: URLSessionDataTask?
    private var currentAvatarURL: String?
    private var currentThumbnailURL: String?
    private var currentPost: Post?
    
    // MARK: UIs
    private lazy var cellPost: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .appWhite
        $0.addSubviews(userAvatar, userName, postDate, postThumbnail, postCommentStackView, postLikeStackView)
        return $0
    }(UIView())
    
    private lazy var userAvatar: UIImageView = builder.addImage("default", scale: .scaleAspectFill)
    private lazy var userName: UILabel = builder.addLabel("", fz: 20, numLine: 1)
    private lazy var postDate: UILabel = builder.addLabel("", color: .appGray)

    private lazy var postThumbnail: UIImageView = builder.addImage("default", scale: .scaleAspectFill)
    
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
        $0.setBackgroundImage(UIImage(named: "icon-heart-active"), for: .selected)
        $0.contentMode = .scaleAspectFill
        
        $0.addTarget(self, action: #selector(savePost), for: .touchUpInside)
        
        return $0
    }(UIButton())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageLoadTask?.cancel()
        userAvatar.image = UIImage(named: "default")
        postThumbnail.image = UIImage(named: "default")
    }
    
    func configure(item: Post) {
        self.currentPost = item

        loadImage(from: item.userAvatar, into: userAvatar)

        self.userAvatar.image = UIImage(named: item.userAvatar)
        self.userName.text = item.userName
        
        loadImage(from: item.postThumbnail, into: postThumbnail)
        
        self.postDate.text = item.postDate
        self.postCommentsCount.text = "\(item.comments.count)"
        self.postLikeCount.text = "\(item.like)"
        
        checkIfPostIsSaved()
    }
    
    private func loadImage(from urlString: String, into imageView: UIImageView) {
        guard let url = URL(string: urlString) else {
            imageView.image = UIImage(named: "image_placeholder")
            return
        }
        
        // Заглушка
        imageView.image = UIImage(named: "image_placeholder")
        
        // Загружаем картинку
        imageLoadTask = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self,
                  error == nil,
                  let data = data,
                  let image = UIImage(data: data) else {
                return
            }
            
            DispatchQueue.main.async {
                if imageView == self.userAvatar && url.absoluteString == self.currentAvatarURL ||
                   imageView == self.postThumbnail && url.absoluteString == self.currentThumbnailURL {
                    UIView.transition(with: imageView,
                                    duration: 0.3,
                                    options: .transitionCrossDissolve,
                                    animations: {
                                        imageView.image = image
                                    },
                                    completion: nil)
                }
            }
        }
        imageLoadTask?.resume()
        
        // Сохраняем текущие URL для проверки в prepareForReuse
        if imageView == userAvatar {
            currentAvatarURL = urlString
        } else if imageView == postThumbnail {
            currentThumbnailURL = urlString
        }
    }
    
    private func checkIfPostIsSaved() {
        guard let post = currentPost else { return }
        let savedPosts = CoreDataManager.shared.fetchSavedPosts()
        postLikeBtn.isSelected = savedPosts.contains { $0.id == post.id }
    }
    
    @objc
    func savePost() {
        guard let post = currentPost else { return }
        let newState = !postLikeBtn.isSelected
                
        if newState {
            CoreDataManager.shared.savePost(post)
        } else {
            CoreDataManager.shared.deletePost(withId: post.id)
        }
        
        postLikeBtn.isSelected = newState
        delegate?.postDidUpdateSaveState(postId: post.id, isSaved: newState)
    }
}
