//
//  GitUserDetailVC.swift
//  GitSearcher
//
//  Created by Dinesh Danda on 4/2/20.
//  Copyright © 2020 Dinesh Danda. All rights reserved.
//

import UIKit
import Alamofire

class GitUserDetailVC: UIViewController {
    
    @IBOutlet weak var reposCount: UILabel!
    @IBOutlet weak var aviatorImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var repositoriesTableView: UITableView!
    @IBOutlet weak var lcoationLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var joiningDateLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    var userDetails: [String: Any]!
    var repositoryList = [[String: Any]]()
    var filteredReposList = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUP()
        getRepoDetails()
        getUserDetails()
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func initialSetUP() {
        detailsLabel.text = AppLocalizedStrings.details.rawValue
        searchBar.delegate = self
        self.titleLabel.text = userDetails["login"] as? String
        if let imageUrl = userDetails["avatar_url"] as? String, let id = userDetails["id"] as? NSNumber {
            aviatorImage.downloadImage(from: imageUrl, folder: "userImages", name: "\(id)")
        }
        if let followersCount = userDetails["followers"] {
            self.followersLabel.text = "\(followersCount) Followers"
            
        }
        if let followingCount = userDetails["following"] {
            self.followingLabel.text = "\(followingCount) Following"
            
        }
        if let emailTexst = userDetails["email"] as? String {
            self.emailLabel.text = emailTexst
            
        }
        if let locationString = userDetails["location"] as? String {
            self.lcoationLabel.text = locationString
            
        }
        if let joiningDate = userDetails["created_at"] as? String {
            self.joiningDateLabel.text = "Join Dt: \(joiningDate)"
            
        }
        if let repos = userDetails["public_repos"] {
            self.reposCount.text = "\(repos) Repos"
            
        }
        aviatorImage.layer.cornerRadius = aviatorImage.frame.size.height/2.0
        aviatorImage.layer.masksToBounds = true
    }
}

//MARK:- UITableview delegate and datasource methods

extension GitUserDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredReposList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryTableViewCell") as? RepositoryTableViewCell else {
            return UITableViewCell()
        }
        let item = filteredReposList[indexPath.row]
        cell.titleLabel.text = item["name"] as? String
        if let starsCount = item["watchers_count"] {
            cell.starsLabel.text = "Stars: \(starsCount)"
        }
        if let forksCount = item["forks_count"] {
            cell.forksLabel.text = "Forks: \(forksCount)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

//MARK:- UISearchBarDelegate methods

extension  GitUserDetailVC: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        // getUserWithName()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            filteredReposList = repositoryList
            repositoriesTableView.reloadData()
            return
        }
        if searchBar.text?.count ?? 0 >= 3 {
            filteredReposList = repositoryList.filter({ (repoDict) -> Bool in
                if let name = repoDict["name"] as? String {
                    return (name.lowercased()).contains(searchText.lowercased())
                }
                return false
            })
            repositoriesTableView.reloadData()
        }
    }
}

//MARK:- API Calls

extension GitUserDetailVC {
    
    func getRepoDetails() {
        guard let url = userDetails["repos_url"] as? String else {
            return
        }
        self.displaySpinner()
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response: DataResponse) in
            print("Response Dict === \(response)")
            self.removeSpinner()
            response.result.ifSuccess {
                self.repositoryList = response.result.value as! [[String : Any]]
                self.filteredReposList = self.repositoryList
                self.repositoriesTableView.reloadData()
            }
            response.result.ifFailure {
            }
        }
    }
    
    func getUserDetails() {
        guard let url = userDetails["url"] as? String else {
            return
        }
        self.displaySpinner()
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response: DataResponse) in
            print("Response Dict === \(response)")
            self.removeSpinner()
            response.result.ifSuccess {
                if let owner = response.result.value as? [String: Any] {
                    self.userDetails = owner
                }
                self.initialSetUP()
            }
            response.result.ifFailure {
            }
        }
    }
}
