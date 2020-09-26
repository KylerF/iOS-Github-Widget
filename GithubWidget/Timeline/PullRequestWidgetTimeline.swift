//
//  PullRequestWidgetTimeline.swift
//  Github Tracker
//
//  Created by Kyler Freas on 9/26/20.
//

import Foundation
import WidgetKit

/// Widget timeline provider to manage updates
struct PullRequestWidgetTimeline: IntentTimelineProvider {
    typealias Intent = ConfigurationIntent
    typealias Entry = LatestPullRequest
    
    func placeholder(in context: Context) -> LatestPullRequest {
        let entry = LatestPullRequest(
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
                repo: "Hello-World"
            )
        )
        
        return entry
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (LatestPullRequest) -> Void) {
        completion(self.placeholder(in: context))
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<LatestPullRequest>) -> Void) {
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!

        guard let account = configuration.account,
              let repo = configuration.repo
        
        else {
            let entry = self.placeholder(in: context)
            let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
            
            completion(timeline)
            return
        }

        PullRequestLoader.fetch(account: account, repo: repo) { result in
            let pr: PullRequest?
            
            if case .success(let fetchedPR) = result {
                pr = fetchedPR
            } else {
                pr = nil
            }

            let entry = LatestPullRequest(date: currentDate, pr: pr, repo: Repo(account: account, repo: repo))
            
            let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
            completion(timeline)
        }
    }
}
