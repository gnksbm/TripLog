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
                    .tabItem { 
                        tabKind.tabItem
                            .font(TLFont.caption)
                            .foregroundColor(TLColor.primaryText)
                    }
                    .background(TLColor.backgroundGray)
                    .accentColor(TLColor.oceanBlue)
                    .toolbarBackground(TLColor.skyBlueMedium, for: .navigationBar)
            }
        }
        .accentColor(TLColor.skyBlue)
        .background(TLColor.backgroundGray.ignoresSafeArea())
    }
    
    enum TabKind: CaseIterable, Identifiable {
        case scheduleList, eventList, touristMap
        
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
            }
        }
        
        @ViewBuilder
        var tabItem: some View {
            VStack(spacing: 4) {
                switch self {
                case .eventList:
                    Image.festival
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                    Text("행사")
                case .touristMap:
                    Image(systemName: "mappin.and.ellipse")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                    Text("주변")                case .scheduleList:
                    Image(systemName: "calendar")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                    Text("일정")
                }
            }
            .padding(.top, 8)
            .padding(.bottom, 4)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(TLColor.skyBlueLight.opacity(0.3))
            )
        }
    }
}

#Preview {
    MainTab()
}
