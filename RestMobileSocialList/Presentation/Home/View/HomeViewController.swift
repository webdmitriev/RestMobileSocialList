//
//  HomeViewController.swift
//  RestMobileSocialList
//
//  Created by Олег Дмитриев on 06.07.2025.
//

import UIKit
import Combine

protocol HomeViewControllerProtocol: AnyObject {
    func displayPosts(_ posts: [Post])
}

class HomeViewController: UIViewController, HomeViewControllerProtocol {
    var presenter: HomeViewPresenterProtocol!
    
    private var cancellables: Set<AnyCancellable> = []
    private lazy var posts: [Post] = []

    private lazy var filteredPosts: [Post] = []
    private var isSearching = false
    
    private lazy var tableView: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .appBg
        $0.separatorStyle = .none
        
        $0.dataSource = self
        $0.delegate = self
        
        $0.register(PostCell.self, forCellReuseIdentifier: PostCell.reuseID)
        
        return $0
    }(UITableView(frame: .zero))
    
    private let searchBar: UISearchBar = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.placeholder = "Search post title"
        $0.searchTextField.backgroundColor = .appBlack.withAlphaComponent(0.1)
        $0.tintColor = .appGray
        $0.backgroundImage = UIImage()
        return $0
    }(UISearchBar())
    
    private let headerContainer = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appBg
        
        view.addSubview(tableView)
        
        presenter = HomeViewPresenter()
        presenter.view = self
        presenter.fetchPosts()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        setupHeaderAndSearchbar()
        constraintsUI()
    }
    
    private func setupHeaderAndSearchbar() {
        headerContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerContainer)
        
        headerContainer.addSubview(searchBar)
        
        searchBar.delegate = self
        searchBar.searchTextField.clearButtonMode = .whileEditing
        
        NSLayoutConstraint.activate([
            headerContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            searchBar.topAnchor.constraint(equalTo: headerContainer.topAnchor, constant: 0),
            searchBar.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor, constant: -8),
            searchBar.bottomAnchor.constraint(equalTo: headerContainer.bottomAnchor, constant: -8),
            searchBar.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func constraintsUI() {
        tableView.keyboardDismissMode = .interactive
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: headerContainer.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - HomeViewControllerProtocol
    func displayPosts(_ posts: [Post]) {
        self.posts = posts
        tableView.reloadData()
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isSearching ? filteredPosts.count : posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.reuseID, for: indexPath) as! PostCell
        let item = isSearching ? filteredPosts[indexPath.row] : posts[indexPath.row]
        cell.configure(item: item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 382
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedPost = isSearching ? filteredPosts[indexPath.item] : posts[indexPath.item]
        print("\(selectedPost.postTitle)")
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            filteredPosts.removeAll()
        } else {
            isSearching = true
            filteredPosts = posts.filter { $0.postTitle.lowercased().contains(searchText.lowercased()) }
        }
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        isSearching = false
        filteredPosts.removeAll()
        tableView.reloadData()
    }
}
