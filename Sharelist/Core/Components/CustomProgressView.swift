//
//  CustomProgressView.swift
//  Sharelist
//
//  Created by Hugues Fils on 30/10/2023.
//

import SwiftUI

struct CustomProgressView: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(.circular)
            .accentColor(.white)
            .scaleEffect(x: 1.5, y: 1.5, anchor: .center)
            .frame(width: 80, height: 80)
            .background(Color(.systemGray4))
            .cornerRadius(20)
    }
}

#Preview {
    CustomProgressView()
}
