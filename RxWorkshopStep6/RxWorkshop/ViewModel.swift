//
//  ViewModel.swift
//  RxWorkshop
//
//  Created by Khoi Truong Minh on 12/7/16.
//  Copyright © 2016 Khoi Truong Minh. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct ViewModel: ViewModelType {

    let query: Variable<String> = Variable<String>("")
    var minimumStars: Variable<Int> = Variable<Int>(500)

    let searchDescription: Observable<String>
    let results: Observable<String>
    let showNoStarWarning: Observable<Void>

    init() {
        searchDescription = query.asObservable()
            .map(toSearchDescription)
            .observeOn(MainScheduler.instance)

        results = MockGitHubAPI
            .getRepositories()
            .map(toString)

        showNoStarWarning = minimumStars.asObservable()
            .filter { $0 < 10 }
            .map { _ in }
    }

}

fileprivate func toSearchDescription(query: String) -> String {
    return "Searching for \(query.uppercased())"
}

fileprivate func toString(repos: [Repository]) -> String {
    return repos.reduce("", { (result, repo) -> String in
        return result + "\n"
            + "📦 " + repo.owner.login + "/" + repo.name + "\n"
            + "⭐️ " + String(repo.starCount) + "\n"
            + "     " + repo.description + "\n" + "\n\n"
            + "----------------------" + "\n"
    })
}
