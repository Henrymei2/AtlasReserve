//
//  BottomNavigation.swift
//  AtlasReserve
//
//  Created by Hengyu Mei on 7/10/23.
//

import SwiftUI

public struct Pages: Identifiable {
    public var id: Int
    let name: String
    let desc: String
}

struct BottomNavigation: View {
    @EnvironmentObject var account:Account
    var body: some View {
        HStack{
            ForEach(account.PAGES) { page in
                Button(action: {
                    account.viewingPage = page.id
                }) {
                    VStack{
                        Image(systemName: page.name)
                            .frame(maxWidth:.infinity)
                            .imageScale(.large)
                            .foregroundColor(page.id == account.viewingPage ? Color.blue : Color.black)
                        Text(LocalizedStringKey(page.desc)).font(.caption2).foregroundColor(page.id == account.viewingPage ? Color.blue : Color.black)
                    }
                    .padding(.top)
                    .padding(.bottom)
                    .background(page.id == account.viewingPage ? Color.yellow.opacity(0.8) : Color.yellow.opacity(0.0))
                    .clipShape(Circle())
                    .animation(.default,value:page.id == account.viewingPage)
                    
                }
            }
            
            
                
            
            
        }
    }
}

struct BottomNavigation_Previews: PreviewProvider {
    static var previews: some View {
        BottomNavigation().environmentObject(Account())
    }
}
