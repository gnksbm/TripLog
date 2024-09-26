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
            ForEach(TabKind.allCases) { tabKind in
                tabKind.view
                    .tabItem { tabKind.tabItem }
            }
        }
    }
    
    enum TabKind: CaseIterable, Identifiable {
        case scheduleList, recordList, eventList, touristMap
        
        var id: Self { self }
        
        @ViewBuilder
        var view: some View {
            switch self {
            case .eventList:
                EventListView()
            case .touristMap:
                TouristMapView()
            case .scheduleList:
                ScheduleListView()
            case .recordList:
                RecordListView()
            }
        }
        
        @ViewBuilder
        var tabItem: some View {
            VStack {
                switch self {
                case .eventList:
                    Image.festival
                    Text("행사")
                case .touristMap:
                    Image(systemName: "map")
                    Text("관광지")
                case .scheduleList:
                    Image(systemName: "list.bullet")
                    Text("일정")
                case .recordList:
                    Image(systemName: "note.text")
                    Text("나의 기록")
                }
            }
        }
    }
}

#Preview {
    MainTab()
}
