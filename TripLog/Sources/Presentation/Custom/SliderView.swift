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
    let barHeight: CGFloat
    let onSelected: (Item) -> Void
    
    @State private var selectedItem: Item?
    @State private var selectedIndex: CGFloat = 0
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(zip(items.indices, items)), id: \.1.id) { index, item in
                Text(item.title)
                    .font(TLFont.body)
                    .fontWeight(item == selectedItem ? .black : .regular)
                    .frame(width: itemWidth)
                    .multilineTextAlignment(.center)
                    .foregroundColor(item == selectedItem ? lineColor : titleColor)
                    .onTapGesture {
                        selectItem(item, at: index)
                    }
            }
        }
        .background(
            GeometryReader { proxy in
                RoundedRectangle(cornerRadius: 3)
                    .frame(width: itemWidth, height: proxy.size.height)
                    .offset(x: itemWidth * selectedIndex)
                    .foregroundStyle(fillColor)
            }
        )
        .overlay(
            GeometryReader { proxy in
                Capsule()
                    .frame(width: itemWidth, height: barHeight)
                    .offset(x: itemWidth * selectedIndex, y: proxy.size.height - barHeight)
                    .foregroundStyle(lineColor)
            }
        )
        .onChange(of: items) { newValue in
            selectedItem = newValue.first
        }
        .onChange(of: selectedItem) { newValue in
            if let newValue {
                onSelected(newValue)
            }
        }
    }
    
    private var screenWidth: CGFloat { UIScreen.main.bounds.width }
    private var itemCount: CGFloat { max(1, CGFloat(items.count)) }
    private var itemWidth: CGFloat {
        itemCount < maxItem ? screenWidth / itemCount : screenWidth / maxItem
    }
    
    private func selectItem(_ item: Item, at index: Int) {
        selectedItem = item
        onSelected(item)
        withAnimation {
            selectedIndex = CGFloat(index)
        }
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
        self.barHeight = barHeight
        self.onSelected = onSelected
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
