//
//  AccountView.swift
//  AtlasReserve
//
//  Created by Hengyu Mei on 2/1/24.
//

import SwiftUI

struct AccountView: View {
    @State private var showAlert = false
    @EnvironmentObject var account:Account;
    var body: some View {
        ScrollView {
            HStack{
                Text("Account Management")
                    .font(.largeTitle).bold()
                    .fontDesign(.serif)
                    .padding()
                Spacer()
            }
            if account.isOwner {
                NavigationLink (destination: OwnerControlView().environmentObject(account)) {
                    Image(systemName: "hammer.fill").scaleEffect(1.2).foregroundStyle(.black)
                    Text("Court Owner Control Panel").font(.title2).foregroundStyle(.black)
                    Spacer()
                    Image(systemName: "chevron.right").foregroundStyle(.black)
                }.padding()
            }
            NavigationLink (destination: ReservationHistory(courtID: -1).environmentObject(account)) {
                Image(systemName: "book.fill").scaleEffect(1.2).foregroundStyle(.black)
                Text("User Reservation History").font(.title2).foregroundStyle(.black)
                Spacer()
                Image(systemName: "chevron.right").foregroundStyle(.black)
            }.padding()
            NavigationLink (destination: ChangeLanguage()) {
                Image(systemName: "globe").scaleEffect(1.2).foregroundStyle(.black)
                Text("Change Language").font(.title2).foregroundStyle(.black)
                Spacer()
                Image(systemName: "chevron.right").foregroundStyle(.black)
            }.padding()

                
            Button("Log Out") {
                showAlert = true
            }
            .font(.title2)
            .buttonStyle(.borderedProminent)
            .alert("Confirm Log Out", isPresented: $showAlert) {
                Button("Log Out") {
                    account.loggedIn = false
                    UserDefaults.standard.set(false, forKey: "loggedIn")
                    UserDefaults.standard.set(0, forKey: "id")
                    UserDefaults.standard.set(false, forKey: "isOwner")
                    UserDefaults.standard.set("", forKey: "username")
                }
                Button("Cancel") {
                    showAlert = false
                }
            }.padding()
        }
    }
}

#Preview {
    NavigationStack{
        AccountView().environmentObject(Account())
        
    }
}
