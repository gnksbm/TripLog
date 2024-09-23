//
//  AddSchduleView.swift
//  TripLog
//
//  Created by gnksbm on 9/22/24.
//

import SwiftUI

struct AddSchduleView: View {
    @StateObject private var viewModel = AddSchduleViewModel()
    
    var body: some View {
        ScrollView {
            ScrollViewReader { proxy in
                dateView(proxy: proxy)
            }
        }
    }
    
    @ViewBuilder
    func dateView(proxy: ScrollViewProxy) -> some View {
        HStack {
            Text("날짜를 선택해주세요")
                .font(.title)
                .bold()
            Spacer()
        }
        .id(Add.date)
        CalendarView(isCompleted: $viewModel.state.isCompleted) { interval in
            proxy.scrollTo(Add.title, anchor: .top)
        }
    }
    
    enum Add {
        case date, title
    }
}

#Preview {
    AddSchduleView()
}
