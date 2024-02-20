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
            NavigationLink (destination: OwnerControlView().environmentObject(account)) {
                Text("Court Owner Control Panel").font(.title2).foregroundStyle(.black)
                Spacer()
                Image(systemName: "chevron.right").foregroundStyle(.black)
            }.padding()
            NavigationLink (destination: ReservationHistory(courtID: 0).environmentObject(account)) {
                Text("Reservation History").font(.title2).foregroundStyle(.black)
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
                }
                Button("Cancel") {
                    showAlert = false
                }
            }.padding()
        }.padding()
    }
}

#Preview {
    NavigationStack{
        AccountView().environmentObject(Account())
        
    }
}
