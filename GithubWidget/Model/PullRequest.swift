//
//  PullRequest.swift
//  Github Tracker
//
//  Created by Kyler Freas on 9/26/20.
//

import Foundation

/// Model class for a Pull Request
struct PullRequest {
    let number: Int
    let title: String
    let created: Date
    let author: String
    let branch: String
    let base: String
    let url: String
    var mergeable: Bool?
}
