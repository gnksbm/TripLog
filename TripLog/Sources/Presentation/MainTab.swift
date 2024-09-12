//
//  MainTab.swift
//  TripLog
//
//  Created by gnksbm on 9/10/24.
//

import SwiftUI

struct MainTab: View {
    var body: some View {
        TabView {
            EventListView()
            TouristMapView()
            ScheduleListView()
            RecordListView()
        }
    }
}

#Preview {
    MainTab()
}
