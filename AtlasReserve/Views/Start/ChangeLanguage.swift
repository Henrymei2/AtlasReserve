//
//  ChangeLanguage.swift
//  AtlasReserve
//
//  Created by Hengyu Mei on 7/1/23.
//

import SwiftUI

struct ChangeLanguage: View {
    var body: some View {
        HStack{
            Text("app-name").font(.title)
                .fontDesign(.serif)
                .bold()
            Spacer()
            Button(action:redirectSetting){
                
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                
                Text(Locale.preferredLanguages[0].uppercased())
                
            }.buttonStyle(.bordered)
        }.frame(maxWidth: .infinity)
            .padding()
            .background(Color.yellow)
    }
}

struct ChangeLanguage_Previews: PreviewProvider {
    static var previews: some View {
        ChangeLanguage()
    }
}
