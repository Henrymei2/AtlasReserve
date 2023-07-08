//
//  Court.swift
//  AtlasReserve
//
//  Created by Hengyu Mei on 8/20/23.
//

import SwiftUI

struct CourtView: View {
    @EnvironmentObject var account:Account;
    var body: some View {
        
        NavigationStack {
            ScrollView{
                HStack{
                    Text("Available Courts")
                        .font(.largeTitle).bold()
                        .fontDesign(.serif)
                    Spacer()
                }.padding()
                if !(account.responses["courtFetch"] == 1) {
                    ProgressView("Loading").onAppear {
                        account.getCourts()
                    }
                } else {
                    HStack{
                        Text("Pull down to refresh")
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
            }
            
        }
    }
}

struct Court_Previews: PreviewProvider {
    static var previews: some View {
        CourtView().environmentObject(Account())
    }
}
