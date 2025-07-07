//
//  FavoritePostsViewController.swift
//  RestMobileSocialList
//
//  Created by Олег Дмитриев on 07.07.2025.
//

import UIKit

class FavoritePostsViewController: UIViewController {
    private var savedPosts: [Post] = []
    private lazy var builder = UIBuilder()
    
    private lazy var tableView: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .appBg
        $0.separatorStyle = .none
        
        $0.dataSource = self
        $0.delegate = self
        
        $0.register(PostCell.self, forCellReuseIdentifier: PostCell.reuseID)
        
        return $0
    }(UITableView(frame: .zero))
    
    private lazy var emptyStateLabel: UILabel = builder.addLabel("Нет сохранённых постов")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appBg
        
        view.addSubviews(tableView, emptyStateLabel)
        
        navigationController?.topViewController?.title = "Favorite"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        constraintsUI()
        loadSavedPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadSavedPosts()
    }
    
    private func constraintsUI() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: builder.offsetPage),
            emptyStateLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -builder.offsetPage)
        ])
    }
    
    private func loadSavedPosts() {
        savedPosts = CoreDataManager.shared.fetchSavedPosts()
        tableView.reloadData()
        updateEmptyState()
    }
    
    private func showEmptyState() {
        UIView.animate(withDuration: 0.3) {
            self.emptyStateLabel.isHidden = false
            self.tableView.isHidden = true
        }
    }

    private func hideEmptyState() {
        UIView.animate(withDuration: 0.3) {
            self.emptyStateLabel.isHidden = true
            self.tableView.isHidden = false
        }
    }

    private func updateEmptyState() {
        if savedPosts.isEmpty {
            showEmptyState()
        } else {
            hideEmptyState()
        }
    }
}

extension FavoritePostsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.reuseID, for: indexPath) as! PostCell
        let item = savedPosts[indexPath.row]
        cell.configure(item: item)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        382
    }
}

extension FavoritePostsViewController: PostCellDelegate {
    func postDidUpdateSaveState(postId: Int, isSaved: Bool) {
        if !isSaved {
            if let index = savedPosts.firstIndex(where: { $0.id == postId }) {
                savedPosts.remove(at: index)
                tableView.performBatchUpdates({
                    tableView.deleteRows(at: [IndexPath(row: index, section: 0)],
                                       with: .automatic)
                }, completion: { [weak self] _ in
                    self?.updateEmptyState()
                })
            }
        }
    }
}
