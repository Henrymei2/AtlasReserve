//
//  FieldManageView.swift
//  AtlasReserve
//
//  Created by Hengyu Mei on 2/13/24.
//

import SwiftUI

// Checkbox Toggle Style Source: https://www.hackingwithswift.com/quick-start/swiftui/customizing-toggle-with-togglestyle
struct CheckToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            Label {
                configuration.label
            } icon: {
                Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(configuration.isOn ? Color.accentColor : .secondary)
                    .accessibility(label: Text(configuration.isOn ? "Checked" : "Unchecked"))
                    .imageScale(.medium)
            }
        }
        .buttonStyle(.plain)
    }
}
//Optional Text Field: https://stackoverflow.com/a/61002589
func ??<T>(lhs: Binding<Optional<T>>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}

struct FieldManageView: View {
    @EnvironmentObject var account: Account
    @Environment(\.presentationMode) var presentationMode
    private var field: Int // field can be passed as -1 -> this means that the View is being used as a FieldCreator
    private var courtID: Int = 0// courtID used for field creation, not used normally
    @State private var isStartDatePickerVisible = false
    @State private var isEndDatePickerVisible = false
    @State private var showAlert = false
    private var timeFormatter: DateFormatter = DateFormatter()
    @State private var pendingFieldType: Int = 1
    @State private var pendingFieldStartTime: Date = Date()
    @State private var pendingFieldCount: Int? = 1;
    @State private var pendingFieldEndTime: Date = Date()
    @State private var pendingFieldAvailabilityArray: [Bool] = [false,false,false,false,false,false,false]
    private var readOnly: Bool = false; // This variable is set to true to remove the delete and create button
    @State private var toReturn: Bool? = false;
    init(field: Int, courtID: Int = 0, readOnly: Bool = false) {
        self.field = field
        self.timeFormatter.dateFormat = "HH:mm"
        self.pendingFieldStartTime = timeFormatter.date(from: "00:00")!
        self.pendingFieldEndTime = timeFormatter.date(from: "00:00")!
        self.courtID = courtID
        self.readOnly = readOnly
    }
    
    var body: some View {
        VStack {
            HStack {
                VStack{
                    Text("Type")
                    Picker("Type", selection: (self.field >= 0) ? $account.fieldsManage[self.field].type : $pendingFieldType) {
                        ForEach(FieldType.types, id: \.self) { type in
                            Text(FieldType.convert[type]!)
                        }
                    }.disabled(self.readOnly)
                }.frame(maxWidth: .infinity)
                VStack{
                    Text("Count")
                    
                    TextField(value: self.field >= 0 ? $account.fieldsManage[self.field].count : $pendingFieldCount ?? 1, formatter: NumberFormatter.init()) {
                        Text("Field Count")
                    }.textFieldStyle(.roundedBorder).multilineTextAlignment(.center)
                        .frame(maxWidth: 50)
                        .disabled(self.readOnly)
                }.frame(maxWidth: .infinity)
                VStack{
                    Text("Start Time")
                    Button(timeFormatter.string(from: (self.field >= 0 ) ? account.fieldsManage[self.field].startTime : pendingFieldStartTime)){
                        isStartDatePickerVisible.toggle()
                    }.disabled(self.readOnly)
                        .sheet(isPresented: $isStartDatePickerVisible) {
                        } content: {
                            DatePicker("Select a time", selection: (self.field >= 0 ) ? $account.fieldsManage[self.field].startTime : $pendingFieldStartTime, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .datePickerStyle(WheelDatePickerStyle())
                            Button("ok") {
                                isStartDatePickerVisible.toggle()
                            }.buttonStyle(.borderedProminent)
                        }

                }.frame(maxWidth: .infinity)
                VStack{
                    Text("End Time")
                    Button(timeFormatter.string(from: (self.field >= 0 ) ? account.fieldsManage[self.field].endTime : pendingFieldEndTime)){
                        isEndDatePickerVisible.toggle()
                    }.disabled(self.readOnly)
                        .sheet(isPresented: $isEndDatePickerVisible) {
                        } content: {
                            DatePicker("Select a time", selection: (self.field >= 0 ) ? $account.fieldsManage[self.field].endTime : $pendingFieldEndTime, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .datePickerStyle(WheelDatePickerStyle())
                            Button("ok") {
                                isEndDatePickerVisible.toggle()
                            }.buttonStyle(.borderedProminent)
                        }
                }.frame(maxWidth: .infinity)
                
            }
            HStack{
                VStack{
                    Text("Mon")
                    Toggle("", isOn: (self.field >= 0 ) ? $account.fieldsManage[self.field].availabilityArray[0]: $pendingFieldAvailabilityArray[0]) .toggleStyle(CheckToggleStyle())
                        .disabled(self.readOnly)
                }
                VStack{
                    Text("Tue")
                    Toggle("", isOn:  (self.field >= 0 ) ? $account.fieldsManage[self.field].availabilityArray[1]: $pendingFieldAvailabilityArray[1]).toggleStyle(CheckToggleStyle())
                        .disabled(self.readOnly)
                }
                VStack{
                    Text("Wed")
                    Toggle("", isOn:  (self.field >= 0 ) ? $account.fieldsManage[self.field].availabilityArray[2]: $pendingFieldAvailabilityArray[2]).toggleStyle(CheckToggleStyle())
                        .disabled(self.readOnly)
                }
                VStack{
                    Text("Thu")
                    Toggle("", isOn:  (self.field >= 0 ) ? $account.fieldsManage[self.field].availabilityArray[3]: $pendingFieldAvailabilityArray[3]).toggleStyle(CheckToggleStyle())
                        .disabled(self.readOnly)
                }
                VStack{
                    Text("Fri")
                    Toggle("", isOn:  (self.field >= 0 ) ? $account.fieldsManage[self.field].availabilityArray[4]: $pendingFieldAvailabilityArray[4]).toggleStyle(CheckToggleStyle())
                        .disabled(self.readOnly)
                }
                VStack{
                    Text("Sat")
                    Toggle("", isOn:  (self.field >= 0 ) ? $account.fieldsManage[self.field].availabilityArray[5]: $pendingFieldAvailabilityArray[5]).toggleStyle(CheckToggleStyle())
                        .disabled(self.readOnly)
                }
                VStack{
                    Text("Sun")
                    Toggle("", isOn:  (self.field >= 0 ) ? $account.fieldsManage[self.field].availabilityArray[6]: $pendingFieldAvailabilityArray[6]).toggleStyle(CheckToggleStyle())
                        .disabled(self.readOnly)
                }
                if self.field >= 0 && (!self.readOnly) {
                    VStack {
                        Text("Delete")
                        Button {
                            showAlert = true
                        } label: {
                            Text("Delete").foregroundStyle(.red)
                        }.alert("confirm-delete-field", isPresented: $showAlert) {
                            HStack{
                                Button (role: .cancel) {
                                    showAlert = false
                                } label: {
                                    Text("Cancel")
                                }
                                NavigationLink {
                                    RequestResult(loadingText: "Deleting the Field", responseKey: "deleteField", successCode: 3) {code in
                                        Text("An unhandled error occured")
                                    }.environmentObject(account)
                                        .onAppear {
                                            account.deleteField(fieldID: account.fieldsManage[self.field].id)
                                    }
                                } label: {
                                    Text("Delete")
                                }
                            }
                        }
                    }

                }
            }
            
            if self.field < 0 {
                NavigationLink {
                    RequestResult(loadingText: "Creating a Field", responseKey: "addField", successCode: 3, toReturn: $toReturn) {code in
                        Text(code == 1 ? "local-error-unreasonable" : "An unhandled error occured")
                        }.environmentObject(account)
                        .onAppear {
                            account.addField(courtID: self.courtID, type: self.pendingFieldType, startTime: self.pendingFieldStartTime, endTime: self.pendingFieldEndTime, count: self.pendingFieldCount ?? 1, availability: self.pendingFieldAvailabilityArray)
                        }
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 25.0).foregroundStyle(.blue).frame(width:80, height:40)
                        Text("Submit").foregroundStyle(.white)
                    }
                }
            }
        }.padding(.vertical).background(HColor.rgb(r: 234, g: 234, b: 244))
            .onAppear {
                if self.field < 0 && toReturn ?? false {
                    presentationMode.wrappedValue.dismiss()
                }
            }
    }
}
#Preview {
    NavigationStack {
        FieldManageView(field: -1, courtID: 1).environmentObject(Account())
        
    }
}
