//
//  LoadingView.swift
//  AtlasReserve
//
//  Created by Hengyu Mei on 8/24/23.
//

import SwiftUI

struct LoadingView: View {
    @State private var isAnimating = false;
    var body: some View {
        Spacer()
        Circle()
            .trim(from: 0, to: 0.8)
            .stroke(Color.blue, lineWidth: 2)
            .frame(width: 75, height: 75)
            .rotationEffect(.degrees(isAnimating ? 360 : 0))
            .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses:false), value: isAnimating)
            .onAppear {
                isAnimating = true
            }
        Spacer()
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
