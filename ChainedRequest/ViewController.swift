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
