//
//  ViewController.swift
//  ChainedRequest
//
//  Created by Mcrew Tech on 19/07/2021.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    
    
    @IBOutlet weak var tableView: UITableView!
    
    private let gitHubRepository = GitHubRepository()
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gitHubRepository.getRepos().flatMap{
            repos -> Observable<[Branch]> in
            
            let randomNumber = Int.random(in: 0...50)
            let repo = repos[randomNumber]
            
            return self.gitHubRepository.getBranches(ownerName: repo.owner.login, repoName: repo.name)
        }.bind(to: tableView.rx.items(cellIdentifier: "branchCell", cellType: BranchTableViewCell.self)){
            index, branch, cell in
            cell.branchNameLabel.text = branch.name
            
        }.disposed(by: bag)
    }


}

struct Repo: Decodable {
    let name : String
    let owner : Owner
    
    
}

struct Owner: Decodable {
    let login : String
}

struct Branch: Decodable {
    let name : String
    
}

class GitHubRepository{
    private let netWorkService = NetWorkService()
    private let baseURLString = "https://api.github.com"
    
    func getRepos() -> Observable<[Repo]>{
        return netWorkService.execute(url: URL(string: baseURLString + "/repositories")! )
    
    }
    
    func getBranches(ownerName: String, repoName: String) -> Observable<[Branch]>{
        return netWorkService.execute(url: URL(string: baseURLString + "/repos/\(ownerName)/\(repoName)/branches")! )
    }
}

class NetWorkService {
    func execute<T: Decodable>(url: URL) -> Observable<T>{
        return Observable.create{ observer -> Disposable in
            let task = URLSession.shared.dataTask(with: url){ data, _, _ in
                
                guard let data = data, let decoded = try? JSONDecoder().decode(T.self, from: data) else {return}
            observer.onNext(decoded)
                observer.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
