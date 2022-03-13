//
//  SettingsViewController.swift
//  InstagramStoryboard
//
//  Created by Shubham Kumar on 25/02/22.
//

import UIKit
import SafariServices

struct SettingCellModel {
    let title: String
    let handler: () -> Void
}

/// View Controller to show user settings
final class SettingsViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var data = [[SettingCellModel]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureModels()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func configureModels() {
        
        data.append([
            SettingCellModel(title: "Edit Profile", handler: {
                [weak self] in
                self?.didTapEditProfile()
            }),
            SettingCellModel(title: "Invite Friends", handler: {
                [weak self] in
                self?.didTapInviteFriends()
            }),
            SettingCellModel(title: "Save Original Posts", handler: {
                [weak self] in
                self?.didTapSaveOriginalPosts()
            })
        ])
        data.append([
            SettingCellModel(title: "Terms of Service", handler: {
                [weak self] in
                self?.openUrl(type: .terms)
            }),
            SettingCellModel(title: "Privacy Policy", handler: {
                [weak self] in
                self?.openUrl(type: .privacy)
            }),
            SettingCellModel(title: "Help/Feedback", handler: {
                [weak self] in
                self?.openUrl(type: .help)
            })
        ])
        data.append([
            SettingCellModel(title: "Log Out", handler: {
                [weak self] in
                self?.didTapLogOut()
            })
        ])
    }
    
    func didTapLogOut() {
        let actionSheet = UIAlertController(title:"Log Out", message: "Are you sure you want to log out?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { _ in
            AuthManager.shared.logOut { success in
                DispatchQueue.main.async {
                    if success {
                        let loginVC = LoginViewController()
                        loginVC.modalPresentationStyle = .fullScreen
                        self.present(loginVC, animated: true) {
                            self.navigationController?.popToRootViewController(animated: true)
                            self.tabBarController?.selectedIndex = 0
                        }
                    } else {
                        //error occured
                        fatalError("Could Not logout user!")
                    }
                }
            }
        }))
        actionSheet.popoverPresentationController?.sourceView = tableView
        actionSheet.popoverPresentationController?.sourceRect = tableView.bounds
        present(actionSheet, animated: true)
    }
    
    enum SettingsURLType {
        case terms, privacy, help
    }
    
    private func didTapEditProfile() {
        let vc = EditProfileViewController()
        vc.title = "Edit Profile"
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
    
    private func didTapInviteFriends() {
        //SHow share sheet to invite friends
    }
    
    private func didTapSaveOriginalPosts() {
        
    }
    
    private func openUrl(type: SettingsURLType) {
        let urlString:String
        switch type {
        case .terms:
            urlString = "https://help.instagram.com/581066165581870"
        case .privacy:
            urlString = "https://help.instagram.com/519522125107875/?maybe_redirect_pol=0"
        case .help:
            urlString = "https://help.instagram.com/"
        }
        
        guard let url = URL(string: urlString) else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //handle call selection here
        let model = data[indexPath.section][indexPath.row]
        model.handler()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.section][indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}
