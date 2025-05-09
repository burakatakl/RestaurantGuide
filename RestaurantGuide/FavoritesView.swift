import SwiftUI

struct FavoritesView: View {
    @State private var favoriteRestaurants: [Restaurant] = []
    @State private var selectedGroup: String? = nil
    @State private var showingAddGroup = false
    @State private var newGroupName = ""
    @State private var groups: [String: [Restaurant]] = [:]
    @ObservedObject private var languageManager = LanguageManager.shared
    
    var body: some View {
        NavigationView {
            List {
                // Grup seçimi
                Section {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            GroupButton(
                                title: "all".localized,
                                isSelected: selectedGroup == nil,
                                action: { selectedGroup = nil }
                            )
                            
                            ForEach(groups.keys.sorted(), id: \.self) { group in
                                GroupButton(
                                    title: group,
                                    isSelected: group == selectedGroup,
                                    action: { selectedGroup = group }
                                )
                            }
                            
                            Button(action: { showingAddGroup = true }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.orange)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .listRowInsets(EdgeInsets())
                }
                
                // Favori restoranlar
                Section(header: Text("favorite_restaurants".localized)) {
                    if favoriteRestaurants.isEmpty {
                        Text("no_favorite_restaurants".localized)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                    } else {
                        ForEach(filteredRestaurants) { restaurant in
                            NavigationLink(destination: RestaurantDetailView(restaurant: restaurant)) {
                                RestaurantRowView(restaurant: restaurant)
                            }
                        }
                        .onDelete(perform: deleteRestaurants)
                    }
                }
            }
            .navigationTitle("favorites".localized)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Favori restoran ekleme işlemi
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddGroup) {
                NavigationView {
                    Form {
                        Section(header: Text("Yeni Grup")) {
                            TextField("Grup Adı", text: $newGroupName)
                        }
                    }
                    .navigationTitle("Grup Ekle")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("İptal") {
                                showingAddGroup = false
                                newGroupName = ""
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Ekle") {
                                if !newGroupName.isEmpty {
                                    groups[newGroupName] = []
                                    showingAddGroup = false
                                    newGroupName = ""
                                }
                            }
                        }
                    }
                }
            }
        }
        .languageAware()
    }
    
    private var filteredRestaurants: [Restaurant] {
        if let group = selectedGroup {
            return groups[group] ?? []
        }
        return favoriteRestaurants
    }
    
    private func deleteRestaurants(at offsets: IndexSet) {
        if let group = selectedGroup {
            groups[group]?.remove(atOffsets: offsets)
        } else {
            favoriteRestaurants.remove(atOffsets: offsets)
        }
    }
}

struct GroupButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
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

#Preview {
    FavoritesView()
} 