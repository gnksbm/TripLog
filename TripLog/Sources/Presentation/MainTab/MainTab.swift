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
                    .background(TLColor.backgroundGray)
                    .accentColor(TLColor.coralOrange)
            }
        }
        .accentColor(.orange)
        .background(TLColor.backgroundGray.ignoresSafeArea())
    }
    
    enum TabKind: CaseIterable, Identifiable {
        case scheduleList, recordList, eventList, touristMap
        
        var id: Self { self }
        
        @ViewBuilder
        var view: some View {
            switch self {
            case .eventList:
                EventListView()
                    .navigationTitle("행사 목록")
                    .toolbarBackground(TLColor.lightPeach, for: .navigationBar)
            case .touristMap:
                TouristMapView()
                    .navigationTitle("관광지도")
                    .toolbarBackground(TLColor.lightPeach, for: .navigationBar)
            case .scheduleList:
                ScheduleListView()
                    .navigationTitle("일정 관리")
                    .toolbarBackground(TLColor.lightPeach, for: .navigationBar)
            case .recordList:
                RecordListView()
                    .navigationTitle("여행 기록")
                    .toolbarBackground(TLColor.lightPeach, for: .navigationBar)
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
                        .font(TLFont.caption)
                        .foregroundColor(TLColor.primaryText)
                case .touristMap:
                    Image(systemName: "map.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                    Text("관광지")
                        .font(TLFont.caption)
                        .foregroundColor(TLColor.primaryText)
                case .scheduleList:
                    Image(systemName: "list.bullet.rectangle") 
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                    Text("일정")
                        .font(TLFont.caption)
                        .foregroundColor(TLColor.primaryText)
                case .recordList:
                    Image(systemName: "note.text")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                    Text("나의 기록")
                        .font(TLFont.caption)
                        .foregroundColor(TLColor.primaryText)
                }
            }
            .padding(.top, 8)
            .padding(.bottom, 4)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(TLColor.lightPeach.opacity(0.3))
            )
        }
    }
}

#Preview {
    MainTab()
}
