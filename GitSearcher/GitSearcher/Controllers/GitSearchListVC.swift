//
//  GitSearchListVC.swift
//  GitSearcher
//
//  Created by Dinesh Danda on 4/1/20.
//  Copyright © 2020 Dinesh Danda. All rights reserved.
//

import UIKit
import Alamofire

let spinner_Tag = 108

extension UIViewController {
    
    //MARK:- This method will start displaying loading indicator on the view and starts animating
    
    func displaySpinner() {
        let spinnerView = UIView.init(frame: self.view.bounds)
        spinnerView.tag = spinner_Tag
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            self.view.addSubview(spinnerView)
        }
    }
    
    //MARK:- This method will remove loading indicator on the view and starts animating
    
    func removeSpinner() {
        DispatchQueue.main.async {
            if let spinnerView = self.view.viewWithTag(spinner_Tag) {
                spinnerView.removeFromSuperview()
            }
        }
    }
}

enum WSResult {
    case success([String: Any])
    case error(String)
}


class GitSearchListVC: UIViewController {
    
    @IBOutlet weak var discriptionLabel: UILabel!
    @IBOutlet weak var gitListTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var totalUsersList = [[String: Any]]()
    var filterUserList = [[String: Any]]()
    
    var searchResults : [(title: String, image: String)] = []
    let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpSearchBar()
    }
    
    func setUpUI() {
        discriptionLabel.text = AppLocalizedStrings.discription.rawValue
    }
    
    func setUpSearchBar() {
        searchBar.delegate = self
    }
    
}

//MARK:- UITableview delegate and datasource methods

extension GitSearchListVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterUserList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "gitListCell") as? GitListTableViewCell else {
            return UITableViewCell()
        }
        let item = filterUserList[indexPath.row]
        if let imageUrl = item["avatar_url"] as? String, let id = item["id"] as? NSNumber {
            cell.userImage.downloadImage(from: imageUrl, folder: "userImages", name: "\(id)")
        }
        cell.userNameLbl.text = item["login"] as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = filterUserList[indexPath.row]
        if let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "GitUserDetailVC") as? GitUserDetailVC {
            vc.userDetails = item
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MARK:- UISearchBarDelegate methods

extension  GitSearchListVC: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        getUserWithName()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count ?? 0 >= 3 {
            if searchBar.text?.count == 3 {
                getUserWithName()
            }
            else {
                filterUserList = totalUsersList.filter({ (userDict) -> Bool in
                    if let name = userDict["login"] as? String {
                        return (name.lowercased()).contains(searchText.lowercased())
                    }
                    return false
                })
                gitListTableView.reloadData()
            }
        }
    }
}

//MARK:- API Calls

extension GitSearchListVC {
    func getUserWithName() {
        guard let searchString = searchBar.text else {
            return
        }
        let url = "https://api.github.com/search/users?q=\(searchString)"
        self.displaySpinner()
        self.getRequest(url: url) { (wsResult) in
            self.removeSpinner()
            switch wsResult {
            case .success(let dictionary):
                print(dictionary)
                if let items = dictionary["items"] as? [[String : Any]] {
                    self.totalUsersList = items
                    self.filterUserList = self.totalUsersList
                    self.gitListTableView.reloadData()
                }
                break
            case .error(let errorDescription):
                print(errorDescription)
                break
            }
        }
    }
    
    func getRequest(url: String, completion: @escaping (_ result: WSResult) -> ()) {
        let headers = ["Accept": "application/json"]
        print("url === \(url)")
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { (response: DataResponse) in
            print("Response Dict === \(response)")
            response.result.ifSuccess {
                completion(.success(response.result.value as! [String: Any]))
            }
            response.result.ifFailure {
                completion(.error(response.result.error.debugDescription))
            }
        }
    }
}
