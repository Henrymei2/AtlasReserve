//
//  CourtDetailsView.swift
//  AtlasReserve
//
//  Created by Hengyu Mei on 2/1/24.
//

import SwiftUI

struct CourtDetailsView: View {
    var court: Court
    @EnvironmentObject var account:Account;
    init(court: Court) {
        self.court = court
    }
    var body: some View {
        if !(account.responses["fieldFetch"] == 1) {
            ProgressView("Loading").onAppear {
                account.getFieldsByCourtID(court: court.id)
            }
        } else {
            ScrollView {
                Text(court.name)
                    .font(.largeTitle).bold()
                    .fontDesign(.serif)
                Image(uiImage: court.previewImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 350, height:180)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(color:.gray.opacity(0.5), radius: 5.0, x: 0, y: 2)
                    .padding(.bottom)
                Text("Available Court Types: ").font(.title2)
                LazyVStack() {
                    
                    ForEach(account.fields.indices, id: \.self) {
                        i in
                        FieldView(field: account.fields[i])
                        
                    }
                }
                Divider()
                
            }.refreshable {
                account.responses["fieldFetch"] = 0
            }
        }
    }
}

//#Preview {
//    CourtDetailsView(court: Court(id: 1, name: "Test", owner: "Test", address: "Test", courtNumber: 1, previewImage: UIImage(systemName: "a")!)).environmentObject(Account())
//}
