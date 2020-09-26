//
//  PRWidget.swift
//  PRWidget
//
//  Created by Kyler Freas on 9/24/20.
//

import WidgetKit
import SwiftUI
import Intents

/// Main view for the Pull Request widget
struct PullRequestWidgetView : View {
    let entry: LatestPullRequest

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(entry.repo.account)/\(entry.repo.repo)")
                .font(.system(.title3))
                .foregroundColor(.white)
            
            if let pr = entry.pr {
                HStack {
                    Image("PullRequestIcon")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.white)
                        .frame(width: 20.0, height: 20.0)
                    Text(pr.title)
                        .font(.system(.callout))
                        .foregroundColor(.white)
                        .bold()
                }
                
                // Show head/base branches and mergeable status
                HStack(spacing: 3) {
                    Text("\(pr.branch)")
                        .font(.system(.caption))
                        .foregroundColor(.white)
                        .bold()
                    
                    // Show icon if there are merge conflicts
                    if let mergeable = pr.mergeable {
                        if !mergeable {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .frame(width: 10.0, height: 10.0)
                                .foregroundColor(.red)
                        }
                    } else {
                        // Mergeable status unknown
                        Image(systemName: "exclamationmark.circle.fill")
                            .resizable()
                            .frame(width: 10.0, height: 10.0)
                            .foregroundColor(.yellow)
                    }
                    
                    Image(systemName: "arrow.right")
                        .resizable()
                        .frame(width: 10.0, height: 8.0)
                        .foregroundColor(.white)
                    
                    Text("\(pr.base)")
                        .font(.system(.caption))
                        .foregroundColor(.white)
                        .bold()
                }
                
                Text("by \(pr.author), \(pr.created.getElapsedInterval())")
                    .font(.system(.caption))
                    .foregroundColor(.white)
            } else {
                // No open pull requests found
                Text("No open Pull Requests")
            }
            
        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
            .padding()
        .background(LinearGradient(gradient: Gradient(colors: [Color(UIColor.darkGray), .black]), startPoint: .top, endPoint: .bottom))
        
        // Tell the main app to link to the Pull Request when
        // opened from this widget
        .widgetURL(URL(string: "https://github.com/\(entry.repo.account)/\(entry.repo.repo)/pull/\(entry.pr?.number ?? 1)"))
    }
}


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
