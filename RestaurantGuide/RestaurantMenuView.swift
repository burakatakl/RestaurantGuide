import SwiftUI

struct RestaurantMenuView: View {
    let restaurant: Restaurant
    @State private var selectedCategory: String?
    @State private var selectedDietaryOptions: Set<DietaryOption> = []
    @ObservedObject private var languageManager = LanguageManager.shared
    
    var filteredMenuItems: [MenuItem] {
        restaurant.menuItems.filter { item in
            // Kategori filtresi
            let categoryMatch = selectedCategory == nil || item.category == selectedCategory
            // Diyet seçenekleri filtresi
            let dietaryMatch = selectedDietaryOptions.isEmpty || !selectedDietaryOptions.isDisjoint(with: item.dietaryOptions)
            return categoryMatch && dietaryMatch
        }
    }
    
    var body: some View {
        List {
            // Kategori seçimi
            Section {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        CategoryButton(
                            title: "all".localized,
                            isSelected: selectedCategory == nil,
                            action: { selectedCategory = nil }
                        )
                        
                        ForEach(restaurant.menuCategories, id: \.self) { category in
                            CategoryButton(
                                title: category,
                                isSelected: category == selectedCategory,
                                action: { selectedCategory = category }
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                .listRowInsets(EdgeInsets())
            }
            
            // Diyet seçenekleri
            Section {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(DietaryOption.allCases, id: \.self) { option in
                            DietaryOptionButton(
                                option: option,
                                isSelected: selectedDietaryOptions.contains(option),
                                action: {
                                    if selectedDietaryOptions.contains(option) {
                                        selectedDietaryOptions.remove(option)
                                    } else {
                                        selectedDietaryOptions.insert(option)
                                    }
                                }
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                .listRowInsets(EdgeInsets())
            }
            
            // Menü öğeleri
            ForEach(restaurant.menuCategories, id: \.self) { category in
                let categoryItems = filteredMenuItems.filter { $0.category == category }
                if !categoryItems.isEmpty {
                    Section(header: Text(category)) {
                        ForEach(categoryItems) { item in
                            MenuItemRow(item: item)
                        }
                    }
                }
            }
        }
        .navigationTitle("menu".localized)
        .languageAware()
    }
}

struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    @ObservedObject private var languageManager = LanguageManager.shared
    
    var body: some View {
        Button(action: action) {
            Text(title.localized)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.orange : Color.gray.opacity(0.1))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
    }
}

struct DietaryOptionButton: View {
    let option: DietaryOption
    let isSelected: Bool
    let action: () -> Void
    @ObservedObject private var languageManager = LanguageManager.shared
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                Text(option.rawValue.localized)
            }
            .font(.subheadline)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(isSelected ? Color.green.opacity(0.2) : Color.gray.opacity(0.1))
            .foregroundColor(isSelected ? .green : .primary)
            .cornerRadius(15)
        }
    }
}

struct MenuItemRow: View {
    let item: MenuItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.name)
                        .font(.headline)
                    
                    Text(item.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text(String(format: "₺%.2f", item.price))
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            if !item.dietaryOptions.isEmpty {
                HStack(spacing: 8) {
                    ForEach(Array(item.dietaryOptions), id: \.self) { option in
                        Text(option.rawValue.localized)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.green.opacity(0.1))
                            .foregroundColor(.green)
                            .cornerRadius(8)
                    }
                }
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    NavigationView {
        RestaurantMenuView(restaurant: Restaurant.sampleRestaurants[0])
    }
} 