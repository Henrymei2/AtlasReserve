//
//  HomeCard.swift
//  AtlasReserve
//
//  Created by Hengyu Mei on 2/21/24.
//

import SwiftUI

struct HomeCard: View {
    private var startColor: Color
    private var endColor: Color    
    private var content: AnyView
    init(startColor: Color, endColor: Color, content: @escaping () -> any View) {
        self.startColor = startColor
        self.endColor = endColor
        self.content = AnyView(content())
    }
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 12.0)
                .fill(LinearGradient(colors: [startColor, endColor], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(maxWidth: .infinity , maxHeight: .infinity)
                .shadow(color: startColor.opacity(0.5),radius: 10)
            self.content
            
        }
    }
}

#Preview {
    HomeCard(startColor: Color(red: 1, green: 184/255, blue: 179/255), endColor: Color(red: 250/255, green: 220/255, blue: 217/255)) {
        VStack{
            Text("A")
        }
    }
}
