//
//  PeopleListView.swift
//  DemoMafia
//
//  Created by Conner Yoon on 4/7/25.
//

import SwiftUI

struct PeopleListView: View {
    @State var people: [Player] = []
    var body: some View {
        ScrollView
        {
            ForEach($people) { person in
                HStack{
                    Text("Hi")
                    
                }
                
            }
        }
    }
}

#Preview {
    PeopleListView()
}
