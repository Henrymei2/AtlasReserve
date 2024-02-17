//
//  CourtInformationManageView.swift
//  AtlasReserve
//
//  Created by Hengyu Mei on 2/14/24.
//

import SwiftUI
import PhotosUI

struct CourtInformationManageView: View {
    @EnvironmentObject var account: Account
    private var courtIndex: Int = 0
    @State var pendingCourtName: String = ""
    @State var pendingCourtOwner: String = ""
    @State var pendingCourtAddress: String = ""
    @State var pendingCourtNumber: Int = 0
    @State var courtPreviewItem: PhotosPickerItem?
    @State var courtPreviewImage: Image?
    @State var courtPreviewUIImage: UIImage = UIImage(systemName: "folder")!
    private var isModifying: Bool
    @State private var changedImage: Bool = false;
    init(courtIndex: Int) {
        self.courtIndex = courtIndex
        self.isModifying = courtIndex >= 0
    }
    var body: some View {
        ScrollView {
            PhotosPicker("Pick A photo", selection: $courtPreviewItem, matching: .images)
            courtPreviewImage?
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 300, height: 180)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .shadow(color:.gray.opacity(0.5), radius: 5.0, x: 0, y: 2)
            HStack{
                Text("Court Name").font(.title2)
                Spacer()
            }
            TextField(text: self.isModifying ? $account.courts[self.courtIndex].name : $pendingCourtName) {
                Text("Name")
            }.textFieldStyle(.roundedBorder)
            HStack {
                Text("Court Owner Name").font(.title2)
                Spacer()
            }
            TextField(text: self.isModifying ? $account.courts[self.courtIndex].owner : $pendingCourtOwner) {
                Text("Court Owner Name")
            }.textFieldStyle(.roundedBorder)
            HStack{
                Text("Court Address").font(.title2)
                Spacer()
            }
            TextField(text: self.isModifying ? $account.courts[self.courtIndex].address : $pendingCourtAddress) {
                Text("Address")
            }.textFieldStyle(.roundedBorder)
            HStack {
                Text("Court  Number").font(.title2)
                Spacer()
            }
            TextField("Court Number", value: self.isModifying ? $account.courts[self.courtIndex].courtNumber : $pendingCourtNumber, formatter: NumberFormatter.init()).textFieldStyle(.roundedBorder)
            if self.isModifying {
                NavigationLink {
                    RequestResult(loadingText: "Modifying a Court\nIf the image is changed, uploading an image could take time", responseKey: "modifyCourt", successCode: 3) {code in
                        Text(code == 1 ? "Unreasonable data detected" : "An unhandled error occured")
                    }.environmentObject(account)
                        .onAppear {
                            account.modifyCourt(court: account.courts[self.courtIndex], changedImage:  self.changedImage)
                        }
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 15.0).foregroundStyle(.blue).frame(width:80, height:40)
                        Text("Submit").foregroundStyle(.white)
                    }
                }.padding()
            } else {
                NavigationLink {
                    RequestResult(loadingText: "Creating a Court\nUploading an image could take time", responseKey: "addCourt", successCode: 3) {code in
                        Text(code == 1 ? "Unreasonable data detected" : "An unhandled error occured")
                    }.environmentObject(account)
                        .onAppear {
                            account.addCourt(name: self.pendingCourtName, owner: self.pendingCourtOwner, address: self.pendingCourtAddress, number: self.pendingCourtNumber, image: self.courtPreviewUIImage)
                        }
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 10.0).foregroundStyle(.blue).frame(width:80, height:35)
                        Text("Submit").foregroundStyle(.white)
                    }
                }.padding()

            }
            
            
            
            
        }.onChange(of: courtPreviewItem) { newItem in
            Task {
                // Retrieve selected asset in the form of Data
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    self.changedImage = true;
                    if let uiImage = UIImage(data: data) {
                        if self.isModifying {
                            account.courts[self.courtIndex].previewImage = uiImage
                        } else {
                            self.courtPreviewUIImage = uiImage
                        }
                        self.courtPreviewImage = Image(uiImage: uiImage)
                    }
                }
            }
        }.padding()
            .onAppear {
                if self.isModifying {
                    self.courtPreviewImage = Image(uiImage: account.courts[self.courtIndex].previewImage)
                } else {
                    self.courtPreviewImage = Image(uiImage: UIImage(systemName: "folder")!)
                }
            }
        
            
        
        
    }
}

#Preview {
    NavigationStack {
        CourtInformationManageView(courtIndex: -1).environmentObject(Account())
    }
}
