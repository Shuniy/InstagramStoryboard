//
//  ExploreViewController.swift
//  InstagramStoryboard
//
//  Created by Shubham Kumar on 25/02/22.
//

import UIKit

class ExploreViewController: UIViewController {
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.backgroundColor = .secondarySystemBackground
        return searchBar
    }()
    
    private var models = [UserPost]()
    
    private var collectionView: UICollectionView?
    private var tabbedSearchCollectionView: UICollectionView?
    
    private let dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        view.isHidden = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Explore"
        
        view.backgroundColor = .systemBackground
        
        configureExploreCollectionView()
        configureSearchBar()
        configureDimmedView()
        configureTabbedSearch()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
        dimmedView.frame = view.bounds
        tabbedSearchCollectionView?.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: 72)
    }
    
    private func configureTabbedSearch() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.width / 3, height: 52)
        layout.scrollDirection = .horizontal
        tabbedSearchCollectionView?.backgroundColor = .yellow
        tabbedSearchCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        tabbedSearchCollectionView?.isHidden = true
        guard let tabbedSearchCollectionView = tabbedSearchCollectionView else {
            return
        }
        tabbedSearchCollectionView.delegate = self
        tabbedSearchCollectionView.dataSource = self
        view.addSubview(tabbedSearchCollectionView)
    }
    
    private func configureExploreCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: (view.width - 4) / 3, height: (view.width - 4) / 3)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        navigationController?.navigationBar.topItem?.titleView = searchBar
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        guard let collectionView = collectionView else {
            return
        }
        view.addSubview(collectionView)
    }
    
    private func configureSearchBar() {
        navigationController?.navigationBar.topItem?.titleView = searchBar
        searchBar.delegate = self
    }
    
    private func configureDimmedView() {
        view.addSubview(dimmedView)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didCancelSearch))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        dimmedView.addGestureRecognizer(gesture)
    }
}

extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == tabbedSearchCollectionView {
            return 0
        }
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == tabbedSearchCollectionView {
            return UICollectionViewCell()
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        //        cell.configure(with: <#T##UserPost#>)
        cell.configure(debug: "test")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == tabbedSearchCollectionView {
            // change search context
            return
        }
        collectionView.deselectItem(at: indexPath, animated: true)
        //        let model = models[indexPath.row]
        let user = User(username: "Shubham", name: (first: "Shubham", last: "Kumar"), birthDate: Date(), gender: .male, profilePhoto: URL(string: "https://google.com")!, bio: "", counts: UserCount(followers: 1, following: 1, posts: 1), joinDate: Date())
        let userPost = UserPost(identifier: "", postType: .photo, thumbnailImage: URL(string: "https://www.google.com")!, postURL: URL(string: "https://www.google.com")!, caption: "Hello", likeCount: [], comments: [], createdDate: Date(), taggedUser: [], owner: user)
        
        let vc = PostViewController(model: userPost)
        vc.title = userPost.postType.rawValue
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ExploreViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        didCancelSearch()
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        
        query(text)
    }
    
    private func query(_ text: String) {
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didCancelSearch))
        dimmedView.isHidden = false
        UIView.animate(withDuration: 0.2) {
            self.dimmedView.alpha = 0.5
        } completion: { done in
            self.tabbedSearchCollectionView?.isHidden = false
        }
        
    }
    
    @objc func didCancelSearch() {
        searchBar.resignFirstResponder()
        navigationItem.rightBarButtonItem = nil
        dimmedView.isHidden = true
        UIView.animate(withDuration: 0.2) {
            self.dimmedView.alpha = 0
        } completion: { done in
            if done {
                self.dimmedView.isHidden = true
                self.tabbedSearchCollectionView?.isHidden = true
            }
        }
        
    }
}
