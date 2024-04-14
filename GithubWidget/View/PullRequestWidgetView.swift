//
//  PullRequestWidgetView.swift
//  Github Tracker
//
//  Created by Kyler Freas on 9/27/20.
//

import SwiftUI
import WidgetKit

/// Main view for the Pull Request widget
struct PullRequestWidgetView : View {
    let entry: LatestPullRequest

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(entry.repo.account)/\(entry.repo.name)")
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
        }
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .leading
        )
        .padding()
        
        // Tell the main app to link to the Pull Request when
        // opened from this widget
        .widgetURL(URL(
            string: "https://github.com/\(entry.repo.account)/\(entry.repo.name)/pull/\(entry.pr?.number ?? 1)"
        ))
        .background(
            LinearGradient(
                gradient: Gradient(
                    colors: [
                        Color(UIColor.darkGray),
                        .black
                    ]
                ),
                startPoint: .top,
                endPoint: .bottom
            )
        ).apply {
            if #available(iOS 17.0, *) {
                $0.containerBackground(for: .widget) {
                    LinearGradient(
                        gradient: Gradient(
                            colors: [
                                Color(UIColor.darkGray),
                                .black
                            ]
                        ),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                }
            }
        }
    }
}

struct PullRequestWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        let widget = PullRequestWidgetView(
            entry: LatestPullRequest.helloWorld
        )

        Group {
            widget.previewContext(WidgetPreviewContext(
                family: .systemSmall
            ))
            widget.previewContext(WidgetPreviewContext(
                family: .systemMedium
            ))
            widget.previewContext(WidgetPreviewContext(
                family: .systemLarge
            ))
            widget.previewContext(WidgetPreviewContext(
                family: .systemExtraLarge
            ))
        }
    }
}
