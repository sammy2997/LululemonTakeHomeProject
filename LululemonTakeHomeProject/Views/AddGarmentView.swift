//
//  AddGarmentView.swift
//  LululemonTakeHomeProject
//
//  Created by Samuel Adama on 1/6/23.
//

import SwiftUI
import CoreData

struct AddGarmentView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let garment: Garment?
    
    var garmentManager: GarmentStorePersistentManager
    @State private var isDisabled: Bool = true
    @State var name: String = ""
    
    var body: some View {
        VStack {
           Text("Garment Name: ")
                .bold()
                .font(.largeTitle)
            
            TextField("Enter garment name", text: $name)
                .foregroundColor(.black)
                .padding([.leading, .trailing], 25)
                .padding(.top, 10)
                .textFieldStyle(.roundedBorder)
            
            Spacer()
        }
        .onChange(of: name) { _ in
            if !name.isEmpty {
                isDisabled = false
            } else {
                isDisabled = true
            }
        }
        .navigationTitle("Add")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    if garment == nil {
                        garmentManager.addNewGarment(name)
                        self.presentationMode.wrappedValue.dismiss()
                    } else {
                        if !name.isEmpty {
                            garment?.name = name
                            garmentManager.updateGarment()
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
                .disabled(isDisabled)
            }
        }
    }
}

struct AddGarmentView_Previews: PreviewProvider {
    static var previews: some View {
        AddGarmentView(garment: nil, garmentManager: GarmentStorePersistentManager())
    }
}
