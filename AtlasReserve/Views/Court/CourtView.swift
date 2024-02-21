//
//  Court.swift
//  AtlasReserve
//
//  Created by Hengyu Mei on 8/20/23.
//

import SwiftUI

struct CourtView: View {
    @EnvironmentObject var account:Account;
    @State var refreshed = false;
    var body: some View {
        NavigationStack {
            ScrollView{
                HStack{
                    Text("Available Courts")
                        .font(.largeTitle).bold()
                        .fontDesign(.serif)
                    Spacer()
                }.padding()
                if account.responses["courtFetch"] == 0 {
                    ProgressView("Loading").onAppear {
                        if !refreshed {
                            account.getCourts(clearImageCache: false)
                        } else {
                            account.getCourts()
                        }
                    }
                } else {
                    HStack{
                        Text("Pull Down to refresh")
                        Spacer()
                    }.padding()
                    LazyVStack() {
                        
                        ForEach(account.courts.indices, id: \.self) {
                            i in
                            CourtCard(court:account.courts[i])
                        }
                    }
                }
            }.refreshable {
                account.responses["courtFetch"] = 0
                refreshed = true;
            }
            
        }
    }
}

struct Court_Previews: PreviewProvider {
    static var previews: some View {
        CourtView().environmentObject(Account())
    }
}
