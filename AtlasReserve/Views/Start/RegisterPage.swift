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
    @State private var showPasswordErrorText = false
    @State private var registerSuccess = false
    @State private var showAlert = false
    @State private var usernameAlert = false;
    @State private var passwordAlert = false;
    @State private var emailAlert = false;
    var body: some View {
        VStack{
            Text("sign-up").font(.largeTitle)
            
            Form{
                HStack{
                    Text("username")
                    TextField("", text:$account.username)
                        .autocorrectionDisabled(true)
                        .onChange(of: account.username){ user in
                            usernameAlert = user.count>=6
                        }
                        .textInputAutocapitalization(.never)
                }
                HStack{
                    Text("email")
                    TextField("", text:$account.email)
                        .autocorrectionDisabled(true)
                        .onChange(of: account.email){
                            email in
                            emailAlert =
                            NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}").evaluate(with: email)
                            
                        }
                        .textInputAutocapitalization(.never)
                        
                }
                HStack{
                    Text("password")
                    SecureField("", text:$account.password)
                        .onChange(of: account.password){
                            passwordConfirm in
                            showPasswordErrorText = account.checkTwoPasswordEqual( pass1: passwordConfirm,pass2: confirmedPassword);
                            passwordAlert = passwordConfirm.count>=6
                        }
                        .textInputAutocapitalization(.never)
                }
                HStack{
                    Text("confirm-password")
                    SecureField("", text:$confirmedPassword)
                        .onChange(of: confirmedPassword){
                            passwordConfirm in
                            showPasswordErrorText = account.checkTwoPasswordEqual( pass1: account.password,pass2: passwordConfirm)
                        }
                        .textInputAutocapitalization(.never)
                    
                }
                HStack{
                    Spacer()
                    Button("submit"){
                        if usernameAlert && passwordAlert && emailAlert && !showPasswordErrorText{
                            registerSuccess = account.addAccount(username:account.username,password:account.password,email:account.email)
                            if registerSuccess
                            {
                                dismiss()
                            }
                            showAlert = true
                        }
                        
                    }.buttonStyle(.borderedProminent)
                    Spacer()
                }
                
                
            }
            List {
                HStack{
                    Image(systemName: "circle.fill").imageScale(.small).foregroundColor(usernameAlert ? Color.green : Color.red)
                    Text("username-must")
                }
                HStack{
                    Image(systemName: "circle.fill").imageScale(.small).foregroundColor(passwordAlert ? Color.green : Color.red)
                    Text("password-must")
                }
                HStack{
                    Image(systemName: "circle.fill").imageScale(.small).foregroundColor(emailAlert ? Color.green : Color.red)
                    Text("email-must")
                }
            }.listStyle(.plain).frame(height:150)
            HStack{
                Text(showPasswordErrorText ? "Passwords don't match" : "").foregroundColor(showPasswordErrorText ? Color.red : Color.white)
            }
        }.alert(registerSuccess ? "register-success" : "register-fail", isPresented: $showAlert){
            Button("ok", role: .cancel){}
        }
        
    }
}

struct RegisterPage_Previews: PreviewProvider {
    static var previews: some View {
        RegisterPage().environmentObject(Account())
    }
}
