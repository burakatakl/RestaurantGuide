import SwiftUI

struct PreferenceView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var selectedCuisines: Set<String> = []
    @State private var selectedPriceRange: String = ""
    @State private var selectedDistance: Double = 5
    @State private var selectedDietaryOptions: Set<String> = []
    @State private var showAdvancedSearch = false
    @State private var showProfile = false
    @State private var navigateToRestaurantList = false
    @ObservedObject private var languageManager = LanguageManager.shared
    
    let cuisines = ["turkish".localized, "italian".localized, "chinese".localized, "japanese".localized, 
                   "indian".localized, "mexican".localized, "french".localized, "american".localized]
    let priceRanges = ["₺", "₺₺", "₺₺₺", "₺₺₺₺"]
    let dietaryOptions = ["vegetarian".localized, "vegan".localized, "gluten free".localized, 
                         "lactose free".localized, "halal".localized]
    
    var body: some View {
        ZStack {
            Color(.systemGray6)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 25) {
                    // Başlık
                    VStack(spacing: 8) {
                        Text("preferences".localized)
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.primary)
                        
                        Text("preferences subtitle".localized)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 20)
                    
                    // Mutfak Tercihleri
                    createSection(title: "cuisine preferences".localized, items: cuisines, selectedItems: $selectedCuisines)
                    
                    // Fiyat Tercihleri
                    createSection(title: "price preferences".localized, items: priceRanges, selectedItems: $selectedPriceRange)
                    
                    // Mesafe Tercihi
                    VStack(alignment: .leading, spacing: 15) {
                        Text("distance preferences".localized)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Slider(value: $selectedDistance, in: 1...20, step: 1)
                            .accentColor(.orange)
                        
                        Text("\(Int(selectedDistance)) km")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                    
                    // Diyet Tercihleri
                    createSection(title: "dietary preferences".localized, items: dietaryOptions, selectedItems: $selectedDietaryOptions)
                    
                    // Gelişmiş Arama Butonu
                    Button(action: {
                        showAdvancedSearch = true
                    }) {
                        HStack {
                            Image(systemName: "slider.horizontal.3")
                                .font(.headline)
                            Text("advanced search".localized)
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.orange)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    }
                    .padding(.horizontal)
                    
                    // Restoran Ara Butonu
                    NavigationLink(destination: RestaurantListView(
                        selectedCuisines: selectedCuisines,
                        selectedPriceRange: selectedPriceRange,
                        selectedDistance: selectedDistance,
                        selectedDietaryOptions: selectedDietaryOptions
                    )) {
                        HStack {
                            Text("search restaurants".localized)
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Image(systemName: "magnifyingglass")
                                .font(.headline)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.orange, Color.orange.opacity(0.8)]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )
                        .shadow(color: Color.orange.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("preferences".localized)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showProfile = true
                }) {
                    Image(systemName: "person.circle.fill")
                        .font(.title2)
                        .foregroundColor(.orange)
                }
            }
        }
        .sheet(isPresented: $showAdvancedSearch) {
            AdvancedSearchView()
        }
        .sheet(isPresented: $showProfile) {
            ProfileView()
                .environmentObject(authManager)
        }
    }
    
    private func createSection(title: String, items: [String], selectedItems: Binding<Set<String>>) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(items, id: \.self) { item in
                    Button(action: {
                        withAnimation(.spring()) {
                            if selectedItems.wrappedValue.contains(item) {
                                selectedItems.wrappedValue.remove(item)
                            } else {
                                selectedItems.wrappedValue.insert(item)
                            }
                        }
                    }) {
                        HStack {
                            Text(item)
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            Spacer()
                            
                            if selectedItems.wrappedValue.contains(item) {
                                Image(systemName: "checkmark")
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.horizontal, 15)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(selectedItems.wrappedValue.contains(item) ? Color.orange : Color.white)
                        )
                        .foregroundColor(selectedItems.wrappedValue.contains(item) ? .white : .primary)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
    
    private func createSection(title: String, items: [String], selectedItems: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            HStack(spacing: 12) {
                ForEach(items, id: \.self) { item in
                    Button(action: {
                        withAnimation(.spring()) {
                            selectedItems.wrappedValue = item
                        }
                    }) {
                        Text(item)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(selectedItems.wrappedValue == item ? Color.orange : Color.white)
                            )
                            .foregroundColor(selectedItems.wrappedValue == item ? .white : .primary)
                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    PreferenceView()
} 