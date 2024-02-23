//
//  ReservationDetailManage.swift
//  AtlasReserve
//
//  Created by Hengyu Mei on 2/19/24.
//

import SwiftUI

struct ReservationDetailManage: View {
    @EnvironmentObject var account: Account
    private var reservation: Reservation
    private var field: Field
    private var yearMonthDay: DateFormatter = DateFormatter.yearMonthDay
    @State private var reasonForCancel: String = ""
    @State private var confirmed: Bool = false
    init(reservation: Reservation, field: Field) {
        self.reservation = reservation
        self.field = field
    }
    var body: some View {
        if account.responses["userByUserIDFetch"] == 0 {
            ProgressView("Fetching reservation user").onAppear {
                account.getUserByUserID(userID: self.reservation.userID)
            }
        } else {
            VStack{
                HStack{
                    Text("Reservation Information").font(.largeTitle)
                    Spacer()
                }
                HStack{
                    Text("This reservation is made by ").font(.title3)
                    Text(self.reservation.resType == 1 ? "a user" : "you").font(.title3).bold()
                    Spacer()
                }
                HStack {
                    Text("Date: ")
                    Text(self.yearMonthDay.string(from: self.reservation.date))
                    Spacer()
                }
                HStack{
                    Text("Start Time: ")
                    Text(self.reservation.startTime)
                    Spacer()
                }
                HStack{
                    Text("End Time: ")
                    Text(self.reservation.endTime)
                    Spacer()
                }
                HStack {
                    Text("Field Type")
                    Text(FieldType.convert[self.field.type]!)
                    Spacer()
                }
            }.padding()
            
            if self.reservation.resType == 1 {
                VStack{
                    HStack {
                        Text("Reserver Information").font(.title2)
                        Spacer()
                    }
                    HStack{
                        Text("User ID: ")
                        Text(String(account.fetchedUser.id))
                        Spacer()
                    }
                    HStack{
                        Text("Username: ")
                        Text(String(account.fetchedUser.username))
                        Spacer()
                    }
                    HStack {
                        Text("Telephone: ")
                        Text(account.fetchedUser.telephone)
                        Spacer()
                    }
                    Spacer()
                    Text("reason-for-cancel")
                    TextField("Reason for cancelation", text: $reasonForCancel, prompt: Text("optional")).onChange(of: reasonForCancel) { _ in
                        self.reasonForCancel = String(self.reasonForCancel.prefix(255))
                    }
                    
                    
                }.padding()
            }
            if !self.confirmed {
                Button("Delete Reservation") {
                    confirmed = true
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10.0).foregroundStyle(.red)
                )
                .foregroundStyle(.white)
            } else {
                NavigationLink {
                    RequestResult(loadingText: "Canceling Reservation", responseKey: "cancelReservation", successCode: 2) {code in
                        Text("An unhandled error occured")
                    }.environmentObject(account)
                        .onAppear {
                            account.cancelReservation(resID: reservation.id, courtID: field.courtID, userID: account.id, reason: reasonForCancel, by: 3, resType: reservation.resType, date: reservation.date, fieldID: self.field.id)
                        }
                } label: {
                    Text("Click Again to Confirm")
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10.0).foregroundStyle(.red)
                        )
                        .foregroundStyle(.white)
                }.padding()
                
            }
        }
    }
}

#Preview {
    NavigationStack{
        ReservationDetailManage(reservation: Reservation(id: 1, field: 1, date: "2020-12-21",resType: 1, startTime: "10:00", endTime: "11:00", userID: 10031), field: Field(id: 1, type: 1, startTime: "", endTime: "", availability: 0, count: 0, courtID: 0)).environmentObject(Account())
        
    }
}
