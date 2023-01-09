//
//  ContentView.swift
//  LululemonTakeHomeProject
//
//  Created by Samuel Adama on 1/6/23.
//

import SwiftUI

struct HomeView: View {
    var garmentManager = GarmentStorePersistentManager()
    @State var garments: [Garment] = []

    private func getAllGarments() {
        garments = garmentManager.getAllGarments()
    }
    
    @State private var segment: SegControl = .alphabetic
    var segmentNames: [SegControl] = [.alphabetic, .date]
    
    init(){
        UISegmentedControl.appearance().selectedSegmentTintColor = .orange
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Picker(Title.sortOrder.rawValue, selection: $segment) {
                    ForEach(segmentNames, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                .padding([.trailing, .leading], 35)
                
                List {
                    
                    ForEach(garments, id: \.self) { garment in
                        
                        if let name = garment.name {
                            
                            NavigationLink(destination: AddGarmentView(garment: garment, garmentManager: garmentManager, name: name)) {
                                Text(name)
                            }
                        }
                    }.onDelete(perform: { indexSet in
                        indexSet.forEach { index in
                            let garment = garments[index]
                            garmentManager.deleteGarment(clothes: garment)
                            garments.remove(at: index)
                            self.garments = sortedResults(segment: segment, array: garments)
                        }
                    })
                }
            }
            .padding()
            .navigationTitle(Title.navigationTitle.rawValue)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    NavigationLink(destination: AddGarmentView(garment: nil, garmentManager: garmentManager)) {
                        Image(systemName: "plus.circle")
                    }
                }
            }
            .onAppear {
                garments = []
                getAllGarments()
                self.garments = sortedResults(segment: segment, array: garments)
            }
            .onChange(of: segment) { newValue in
                self.garments = sortedResults(segment: newValue, array: garments)
            }
        }
    }
    
    func sortedResults(segment: SegControl, array: [Garment]) -> [Garment] {
        
        var garments = array
        
        switch segment {
        case .alphabetic:
            garments.sort { $0.name?.lowercased() ?? "" < $1.name?.lowercased() ?? "" }
        case .date:
            garments.sort { $0.dateCreated ?? Date() < $1.dateCreated ?? Date()}
        }
        return garments
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
