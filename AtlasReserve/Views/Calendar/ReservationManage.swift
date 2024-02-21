//
//  ReservationManage.swift
//  AtlasReserve
//
//  Created by Hengyu Mei on 2/20/24.
//

import SwiftUI

struct ReservationManage: View {
    @EnvironmentObject var account: Account
    private var reservation: Reservation
    private var fieldID: Int
    private var courtID: Int
    private var yearMonthDay: DateFormatter = DateFormatter.yearMonthDay
    @State private var reasonForCancel: String = ""
    @State private var confirmed: Bool = false
    init(reservation: Reservation, fieldID: Int, courtID: Int) {
        self.reservation = reservation
        self.fieldID = fieldID
        self.courtID = courtID
    }
    var body: some View {
        if account.responses["fieldFetch"] == 0 {
            ProgressView("Loading Fields").onAppear {
                account.getFieldsByCourtID(court: self.courtID)
            }
        } else {
            VStack{
                HStack{
                    Text("Reservation Information").font(.largeTitle)
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
                    Text(FieldType.convert[account.fields.first(where: { field in
                        field.id == self.fieldID
                    })!.type]!)
                    Spacer()
                }
            }.padding()
            VStack{
                NavigationLink {
                    RequestResult(loadingText: "Archiving Reservation", responseKey: "cancelReservation", successCode: 2) {code in
                        Text("An unhandled error occured")
                    }.environmentObject(account)
                        .onAppear {
                            account.cancelReservation(resID: reservation.id, courtID: self.courtID, userID: account.id, reason: reasonForCancel, by: 1, resType: reservation.id, date: reservation.date, fieldID: self.fieldID)
                        }
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 10.0).foregroundStyle(.green).frame(width:300, height:35)
                        Text("Mark this reservation as completed").foregroundStyle(.white)
                    }
                }.padding()
                Text("reason-for-cancel")
                TextField("Reason for cancelation", text: $reasonForCancel, prompt: Text("optional")).onChange(of: reasonForCancel) { _ in
                    self.reasonForCancel = String(self.reasonForCancel.prefix(255))
                }
                
            }.padding()
            if !self.confirmed {
                ZStack{
                    RoundedRectangle(cornerRadius: 10.0).foregroundStyle(.red).frame(width:180, height:35)
                    Button("Delete Reservation") {
                        confirmed = true
                    }.foregroundStyle(.white)
                }.padding()
            } else {
                NavigationLink {
                    RequestResult(loadingText: "Canceling Reservation", responseKey: "cancelReservation", successCode: 2) {code in
                        Text("An unhandled error occured")
                    }.environmentObject(account)
                        .onAppear {
                            account.cancelReservation(resID: reservation.id, courtID: self.courtID, userID: account.id, reason: reasonForCancel, by: 2, resType: reservation.resType, date: reservation.date, fieldID: self.fieldID)
                        }
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 10.0).foregroundStyle(.red).frame(width:180, height:35)
                        Text("Click Again to Confirm").foregroundStyle(.white)
                    }
                }.padding()
                
            }
        }
    }
}

