//
//  LatestPullRequestData.swift
//  Github Tracker
//
//  Created by Kyler Freas on 6/4/22.
//

import Foundation

extension LatestPullRequest {
    static let helloWorld = LatestPullRequest(
        date: Date(),
        pr: PullRequest(
            number: 1,
            title: "Read me update",
            created: Date(),
            author: "octocat",
            branch: "ReadMe_Update",
            base: "master",
            url: "https://api.github.com/repos/octocat/Hello-World/pulls/631",
            mergeable: true
        ),
        repo: Repo(
            account: "octocat",
            name: "Hello-World"
        )
    )
}
