//
//  AtlasReserveApp.swift
//  AtlasReserve
//
//  Created by Hengyu Mei on 7/1/23.
//

import SwiftUI

@main
struct AtlasReserveApp: App {
    @StateObject var account = Account();
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                if account.loggedIn {
                    ContentView()
                }else{
                    StartingPage()
                }
            }.environmentObject(account)
                .onAppear {
                    guard UserDefaults.standard.object(forKey: "loggedIn") != nil else {
                        account.loggedIn = false
                        return
                    }
                    if UserDefaults.standard.bool(forKey: "loggedIn") {
                        account.loggedIn = true
                        account.id = UserDefaults.standard.integer(forKey: "id")
                        account.isOwner = UserDefaults.standard.bool(forKey: "isOwner")
                        account.username = UserDefaults.standard.string(forKey: "username") ?? "user"
                    }
                }
        }
    }
}
