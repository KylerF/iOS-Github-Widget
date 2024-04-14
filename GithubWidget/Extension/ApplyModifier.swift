//
//  ApplyModifier.swift
//  GithubWidgetExtension
//
//  Created by Kyler Freas on 4/13/24.
//

import SwiftUI

extension View {
    func apply<V: View>(@ViewBuilder _ block: (Self) -> V) -> V { block(self) }
}
