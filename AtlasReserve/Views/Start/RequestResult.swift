//
//  ReservationResult.swift
//  AtlasReserve
//
//  Created by Hengyu Mei on 2/9/24.
//

import SwiftUI

struct RequestResult: View {
    @EnvironmentObject var account: Account
    private var loadingText: LocalizedStringKey;
    private var responseKey: String;
    private var successCode: Int;
    private var fail: (Int) -> Text;
    private var holdCodes: [Int]
    init(loadingText: LocalizedStringKey, responseKey: String, successCode: Int, holdCodes: [Int] = [], fail: @escaping (Int) -> Text) {
        self.loadingText = loadingText
        self.responseKey = responseKey
        self.successCode = successCode
        self.fail = fail
        self.holdCodes = holdCodes
    }
    var body: some View {
        VStack{
            if account.responses[self.responseKey] == 0 || self.holdCodes.contains(where: { code in
                return code == account.responses[self.responseKey]
            }) {
                ZStack{
                    RoundedRectangle(cornerRadius: 25)
                        .frame(width:350, height:150)
                        .foregroundStyle(.yellow)
                    VStack{
                        ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .blue))
                            .padding()
                            .scaleEffect(CGSize(width: 2, height: 2))
                        
                        Text(self.loadingText).font(.title2)
                    }
                }
            } else {
                Image(systemName: account.responses[self.responseKey] == self.successCode ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .font(.system(size: 100))
                    .foregroundColor(account.responses[self.responseKey] == self.successCode ? .green : .red)
                    .padding(.horizontal)
                Text(account.responses[self.responseKey] == self.successCode ? "Success!" : "Error!")
                    .font(.title2)
                    .padding()
                if (account.responses[self.responseKey] != self.successCode) {
                    self.fail(self.successCode)
                }
            }
        }
    }
}

#Preview {
    RequestResult(
        loadingText: "Trying to make a reservation...", responseKey: "reserve", successCode: 3, fail: { code in
            return Text(code == 1 ? "While updating, it is discovered that there are no available places for this field" : "An error occured while updating the database")
        }
    ).environmentObject(Account())
}
