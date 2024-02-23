//
//  DatePickerView.swift
//  AtlasReserve
//
//  Created by Hengyu Mei on 2/22/24.
//

import SwiftUI

struct DatePickerView: View {
    @State var selected: Date = Date()
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var account: Account
    init(selected: Date) {
        self.selected = selected
    }
    var body: some View {
        DatePicker("Select a time", selection: $selected, displayedComponents: .hourAndMinute)
            .labelsHidden()
            .datePickerStyle(WheelDatePickerStyle())
            .onAppear {
                account.changedDate = selected
            }
        Button("ok"){
            account.changedDate = selected
            presentationMode.wrappedValue.dismiss()
        }
        .buttonStyle(.borderedProminent)
    }
}

#Preview {
    DatePickerView(selected: Date()).environmentObject(Account())
}
