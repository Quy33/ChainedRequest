//
//  ViewController.swift
//  ChainedRequest
//
//  Created by Mcrew Tech on 19/07/2021.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

struct Repo: Decodable {
    let name : String
    
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
