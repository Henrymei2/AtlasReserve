//
//  OwnerControlView.swift
//  AtlasReserve
//
//  Created by Hengyu Mei on 2/11/24.
//

import SwiftUI

struct OwnerControlView: View {
    @EnvironmentObject var account: Account
    var body: some View {
        ScrollView {
            Text("Your Courts").font(.largeTitle).fontDesign(.serif).bold()
            if account.isOwner {
                
                if account.responses["courtFetch"] == 0 {
                    ProgressView("Fetching Courts").onAppear {
                        account.getCourts(clearImageCache: false)
                    }
                } else {
                    
                    ForEach(account.courts, id: \.id) { i in
                        if (i.ownerID == account.id) {
                            CourtManageCard(court: i).environmentObject(account)
                        }
                    }
                    
                }
                
                HStack {
                    Spacer()
                    NavigationLink {
                        CourtInformationManageView(courtIndex: -1).environmentObject(account) // -1 will be processed as "create"
                    } label: {
                        Text("Add Court")
                        Image(systemName: "plus")
                    }
                }.padding()
            } else {
                Text("not-owner")
            }
        }.padding()
    }
}

#Preview {
    NavigationStack{
        OwnerControlView().environmentObject(Account())
    }
}
