//
//  ContentView.swift
//  AtlasReserve
//
//  Created by Hengyu Mei on 7/1/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var account:Account


    var body: some View {
        VStack {
            if account.viewingPage == 1{
                HomeView()
            } else if account.viewingPage == 2 {
                CourtView().environmentObject(account)
            } else if account.viewingPage == 3 {
                CalendarPage().environmentObject(account)
            } else if account.viewingPage == 4 {
                AccountView().environmentObject(account)
            }
            Spacer()
            BottomNavigation()
            
        }
        .padding()
        
    }
}
#Preview {
    NavigationStack {
        ContentView().environmentObject(Account())
    }
}

