//
//  SliderView.swift
//  TripLog
//
//  Created by gnksbm on 9/13/24.
//

import SwiftUI

protocol SliderItemType: Identifiable, Equatable {
    var title: String { get }
}

extension SliderItemType {
    var id: Self { self }
}

struct SliderView<Item: SliderItemType>: View {
    let items: [Item]
    let titleColor: Color
    let fillColor: Color
    let lineColor: Color
    let maxItem: CGFloat
    let onSelected: (Item) -> Void
    let barHeight: CGFloat
    
    @State private var selectedItem: Item?
    @State private var selectedIndex: CGFloat = 0
    
    var body: some View {
        HStack(spacing: .zero) {
            ForEach(
                Array(zip(items.indices, items)),
                id: \.1.id
            ) { index, item in
                Text(item.title)
                    .frame(width: itemWidth)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(titleColor)
                    .onTapGesture {
                        selectedItem = item
                        onSelected(item)
                        withAnimation {
                            selectedIndex = CGFloat(index)
                        }
                    }
            }
        }
        .overlay {
            GeometryReader { proxy in
                RoundedRectangle(cornerRadius: 3)
                    .frame(
                        width: itemWidth,
                        height: proxy.size.height
                    )
                    .offset(
                        x: itemWidth * selectedIndex,
                        y: proxy.frame(in: .local).minY
                    )
                    .foregroundStyle(fillColor)
            }
        }
        GeometryReader { proxy in
            let global = proxy.frame(in: .global)
            Capsule()
                .frame(width: itemWidth, height: barHeight)
                .offset(
                    x: global.width / CGFloat(items.count) * selectedIndex,
                    y: proxy.frame(in: .local).minY
                )
                .foregroundStyle(lineColor)
        }
        .onAppear {
            selectedItem = items.first
        }
    }
    
    private var screenWidth: CGFloat { UIScreen.main.bounds.width }
    
    private var itemWidth: CGFloat {
        CGFloat(items.count) < maxItem ?
        screenWidth / max(1, CGFloat(items.count)) : screenWidth / maxItem
    }
    
    init(
        items: [Item],
        titleColor: Color = .black,
        fillColor: Color = .clear,
        lineColor: Color = .black,
        maxItem: CGFloat = 5,
        barHeight: CGFloat = 3,
        onSelected: @escaping (Item) -> Void
    ) {
        self.items = items
        self.titleColor = titleColor
        self.fillColor = fillColor
        self.lineColor = lineColor
        self.maxItem = maxItem
        self.onSelected = onSelected
        self.barHeight = barHeight
    }
}

#Preview {
    enum SliderTestItem: SliderItemType, CaseIterable {
        case a, b, c
        
        var title: String { "\(self)" }
    }
    return SliderView(
        items: SliderTestItem.allCases,
        fillColor: .red.opacity(0.4)
    ) { item in
        print(item)
    }
}
