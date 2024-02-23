//
//  LoginPage.swift
//  AtlasReserve
//
//  Created by Hengyu Mei on 7/2/23.
//

import SwiftUI

struct LoginPage: View {
    @EnvironmentObject var account:Account
    @Environment(\.dismiss) private var dismiss
    @State private var showAlert = false;
    @State private var alertText = "";
    @State private var showResult = false;
    var body: some View {
        if showResult {
            RequestResult(loadingText: "Logging In", responseKey: "login", successCode: 4) { code in
                if code == 1 {
                    return Text("Cannot find Account associated with the given username / email")
                } else if code == 2 {
                    return Text("Incorrect Username or Password")
                } else {
                    return Text("An unhandled issue occured")
                }
            }
        } else {
            ScrollView{
                Text("log-in").font(.largeTitle)
                VStack{
                    HStack{
                        Text("Username / Email")
                            .font(.title3)
                        Spacer()
                    }
                    TextField("Username / Email", text:$account.username)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                        .padding()
                        .background(HColor.rgb(r: 244, g: 244, b: 250))
                    HStack{
                        Text("password")
                            .font(.title3)
                        Spacer()
                    }
                    SecureField("password", text:$account.password)
                        .textInputAutocapitalization(.never)
                        .padding()
                        .background(HColor.rgb(r: 244, g: 244, b: 250))
                    
                
                }.padding()
                    HStack{
                        Spacer()
                        Button("submit"){
                            account.logIn(username: account.username, password: account.password)
                            showResult = true
                        }.buttonStyle(.borderedProminent)
                        Spacer()
                    }
                    
                
            }
            
        }

    }
}

struct LoginPage_Previews: PreviewProvider {
    static var previews: some View {
        LoginPage().environmentObject(Account())
    }
}
