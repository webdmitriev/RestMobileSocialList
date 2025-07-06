//
//  HomeViewController.swift
//  RestMobileSocialList
//
//  Created by Олег Дмитриев on 06.07.2025.
//

import UIKit

protocol HomeViewControllerProtocol: AnyObject {
//    func setupUI()
}

class HomeViewController: UIViewController, HomeViewControllerProtocol {

    var presenter: HomeViewPresenterProtocol!
    
    private lazy var posts: [Post] = Post.mockData()
    
    private lazy var tableView: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .appBg
        $0.separatorStyle = .none
        
        $0.dataSource = self
        $0.delegate = self
        
        $0.register(PostCell.self, forCellReuseIdentifier: PostCell.reuseID)
        
        return $0
    }(UITableView(frame: .zero))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brown
        
        view.addSubview(tableView)
        
        constraintsUI()
    }
    
    private func constraintsUI() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.reuseID, for: indexPath) as! PostCell
        let item = posts[indexPath.item]
        cell.configure(item: item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 382
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("\(posts[indexPath.item].postTitle)")
    }
}
