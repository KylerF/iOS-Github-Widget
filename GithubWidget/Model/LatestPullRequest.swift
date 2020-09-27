//
//  LatestPullRequest.swift
//  Github Tracker
//
//  Created by Kyler Freas on 9/26/20.
//

import Foundation
import WidgetKit

/// Holds the most recent Pull Request for a repo
struct LatestPullRequest: TimelineEntry {
    public let date: Date
    public let pr: PullRequest?
    public let repo: Repo
}
