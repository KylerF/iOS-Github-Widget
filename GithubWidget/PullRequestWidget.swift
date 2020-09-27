//
//  PRWidget.swift
//  PRWidget
//
//  Created by Kyler Freas on 9/24/20.
//

import WidgetKit
import SwiftUI
import Intents

@main
struct PullRequestWidget: Widget {
    private let kind: String = "PullRequestWidget"
    private let timeline = PullRequestWidgetTimeline()

    public var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: timeline) { entry in
            PullRequestWidgetView(entry: entry)
        }
        .configurationDisplayName("Latest Pull Request")
        .description("Shows the latest Pull Request for a repo")
    }
}
