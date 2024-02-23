//
//  LoginPage.swift
//  AtlasReserve
//
//  Created by Hengyu Mei on 7/2/23.
//

import SwiftUI

struct RegisterPage: View {
    @EnvironmentObject var account:Account
    @Environment(\.dismiss) private var dismiss
    @State private var confirmedPassword:String = ""
    @State private var registerSuccess = 0
    @State private var showPasswordErrorText = false
    @State private var usernameAlert = false
    @State private var passwordAlert = false
    @State private var emailAlert = false
    @State private var success: Bool? = false
    @State private var showResult = false
    @State private var attemptToLogin = false;
    var body: some View {
        if showResult {
            RequestResult(loadingText: "Registering Account", responseKey: "addAccount", successCode: 3, toReturn: $success) { code in
                Text(code == 1 ? "Username / Email already taken" : "An unhandled issue occured.")
            }
        } else {
            ScrollView{
                Text("sign-up").font(.largeTitle)
                
                HStack{
                    Image(systemName: "circle.fill").imageScale(.small).foregroundStyle(usernameAlert ? Color.green : Color.red)
                    Text("username-must")
                }
                HStack{
                    Image(systemName: "circle.fill").imageScale(.small).foregroundStyle(passwordAlert ? Color.green : Color.red)
                    Text("password-must")
                }
                HStack{
                    Image(systemName: "circle.fill").imageScale(.small).foregroundStyle(emailAlert ? Color.green : Color.red)
                    Text("email-must")
                }
                HStack {
                    Text(showPasswordErrorText ? "Passwords must match" : "").foregroundStyle(.red)
                    Spacer()
                }.padding(.horizontal)
                VStack{
                    HStack{
                        Text("Username")
                            .font(.title3)
                        Spacer()
                    }
                    TextField("Username", text:$account.username)
                        .autocorrectionDisabled(true)
                        .onChange(of: account.username){ user in
                            usernameAlert = user.count>=2
                        }
                        .textInputAutocapitalization(.never)
                        .padding()
                        .background(HColor.rgb(r: 244, g: 244, b: 250))
                    
                    HStack{
                        Text("email")
                            .font(.title3)
                        Spacer()
                    }
                    TextField("Email", text:$account.email)
                        .autocorrectionDisabled(true)
                        .onChange(of: account.email){
                            email in
                            emailAlert =
                            NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}").evaluate(with: email)
                            
                        }
                        .textInputAutocapitalization(.never)
                        .padding()
                        .background(HColor.rgb(r: 244, g: 244, b: 250))
                    
                    HStack{
                        Text("password")
                            .font(.title3)
                        Spacer()
                    }
                    SecureField("password", text:$account.password)
                        .onChange(of: account.password){ new in
                            passwordAlert = new.count>=6
                        }
                        .textInputAutocapitalization(.never)
                        .padding()
                        .background(HColor.rgb(r: 244, g: 244, b: 250))
                    
                    HStack{
                        Text("confirm-password")
                            .font(.title3)
                        Spacer()
                    }
                    SecureField("confirm-password", text:$confirmedPassword)
                        .textInputAutocapitalization(.never)
                        .padding()
                        .background(HColor.rgb(r: 244, g: 244, b: 250))
                    
                        
                    HStack{
                        Button("submit"){
                            if account.password != confirmedPassword {
                                showPasswordErrorText = true
                            }
                            if usernameAlert && passwordAlert && emailAlert && !showPasswordErrorText{
                                showResult = true; account.addAccount(username:account.username,password:account.password,email:account.email)
                            }
                            
                        }.buttonStyle(.borderedProminent)
                            .padding()
                            .frame(maxWidth: .infinity)
                    }
                }.padding()
                
            }.onAppear {
                usernameAlert = account.username.count>=2
                emailAlert =
                NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}").evaluate(with: account.email)
                if success ?? false {
                    attemptToLogin = true
                }
                
            }
        }
        
    }
}
#Preview {
    NavigationStack{
        RegisterPage().environmentObject(Account())
        
    }
}
