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
    var body: some View {
        VStack{
            Text("log-in").font(.largeTitle)
            Form{
                HStack{
                    Text("username")
                    Text("/")
                    Text("email")
                    TextField("", text:$account.username)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                }
                HStack{
                    Text("password")
                    SecureField("", text:$account.password)
                        .textInputAutocapitalization(.never)
                        
                }
                HStack{
                    Spacer()
                    Button("submit"){
                        let loggedInResult = account.logIn(username: account.username, password: account.password)
                        
                        switch loggedInResult {
                        case 3:
                            account.loggedIn = true
                            alertText = "login-success"
                            UserDefaults.standard.set(true, forKey: "loggedIn")
                            dismiss()
                        case 2:
                            alertText = "incorrect"
                        case 1:
                            alertText = "user-not-found"
                        default:
                            alertText = "an-error-occured"
                        }
                        showAlert = true;
                        
                        
                        
                    }.buttonStyle(.borderedProminent)
                    Spacer()
                }
                
            }
        }.alert(NSLocalizedString(alertText, comment: ""), isPresented: $showAlert) {
            Button("ok", role: .cancel){}
        }

    }
}

struct LoginPage_Previews: PreviewProvider {
    static var previews: some View {
        LoginPage().environmentObject(Account())
    }
}
