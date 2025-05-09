import SwiftUI

struct RestaurantListView: View {
    let selectedCuisines: Set<String>
    let selectedPriceRange: String
    let selectedDistance: Double
    let selectedDietaryOptions: Set<String>
    
    @State private var showProfile = false
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authManager: AuthenticationManager
    @ObservedObject private var languageManager = LanguageManager.shared
    
    var filteredRestaurants: [Restaurant] {
        Restaurant.sampleRestaurants.filter { restaurant in
            // Mutfak türü filtresi
            if !selectedCuisines.isEmpty && !selectedCuisines.contains(restaurant.cuisine) {
                return false
            }
            
            // Fiyat aralığı filtresi
            if !selectedPriceRange.isEmpty && restaurant.priceRange != selectedPriceRange {
                return false
            }
            
            // Mesafe filtresi
            if restaurant.distance > selectedDistance {
                return false
            }
            
            // Diyet seçenekleri filtresi
            if !selectedDietaryOptions.isEmpty {
                let restaurantOptions = Set(restaurant.dietaryOptions)
                if !selectedDietaryOptions.isSubset(of: restaurantOptions) {
                    return false
                }
            }
            
            return true
        }
        .sorted { $0.rating > $1.rating } // Puanı yüksek olanlar önce
    }
    
    var body: some View {
        List(filteredRestaurants) { restaurant in
            NavigationLink(destination: RestaurantDetailView(restaurant: restaurant)) {
                RestaurantRowView(restaurant: restaurant)
            }
        }
        .navigationTitle("restaurants".localized)
        .overlay {
            if filteredRestaurants.isEmpty {
                VStack {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    Text("no_restaurants_found".localized)
                        .font(.headline)
                        .foregroundColor(.gray)
                    Text("try_changing_preferences".localized)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    showProfile = true
                }) {
                    Image(systemName: "person.circle.fill")
                        .font(.title2)
                        .foregroundColor(.orange)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.orange)
                }
            }
        }
        .sheet(isPresented: $showProfile) {
            ProfileView()
                .environmentObject(authManager)
        }
    }
}

struct RestaurantRowView: View {
    let restaurant: Restaurant
    
    var body: some View {
        HStack(spacing: 15) {
            // Restoran resmi
            Image(systemName: "fork.knife.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundColor(.orange)
            
            VStack(alignment: .leading, spacing: 5) {
                // Restoran adı
                Text(restaurant.name)
                    .font(.headline)
                
                // Mutfak türü
                Text(restaurant.cuisine)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                // Puan ve mesafe
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text(String(format: "%.1f", restaurant.rating))
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "location.fill")
                            .foregroundColor(.blue)
                        Text(String(format: "%.1f km", restaurant.distance))
                    }
                }
                .font(.caption)
            }
        }
        .padding(.vertical, 8)
    }
}

struct RestaurantDetailView: View {
    let restaurant: Restaurant
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Restoran resmi
                Image(systemName: "fork.knife.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .foregroundColor(.orange)
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.1))
                
                VStack(alignment: .leading, spacing: 15) {
                    // Restoran adı
                    Text(restaurant.name)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    // Mutfak türü ve fiyat aralığı
                    HStack {
                        Text(restaurant.cuisine)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.orange.opacity(0.2))
                            .cornerRadius(8)
                        
                        Text(restaurant.priceRange)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.green.opacity(0.2))
                            .cornerRadius(8)
                    }
                    
                    // Puan ve mesafe
                    HStack(spacing: 20) {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text(String(format: "%.1f", restaurant.rating))
                        }
                        
                        HStack(spacing: 4) {
                            Image(systemName: "location.fill")
                                .foregroundColor(.blue)
                            Text(String(format: "%.1f km", restaurant.distance))
                        }
                    }
                    
                    // Açıklama
                    Text(restaurant.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    // Menü ve Yorumlar butonları
                    HStack(spacing: 15) {
                        NavigationLink(destination: RestaurantMenuView(restaurant: restaurant)) {
                            HStack {
                                Image(systemName: "menucard")
                                Text("Menü")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(12)
                        }
                        
                        NavigationLink(destination: RestaurantReviewsView(restaurant: restaurant)) {
                            HStack {
                                Image(systemName: "star.bubble")
                                Text("Yorumlar")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(12)
                        }
                    }
                    .padding(.top, 10)
                }
                .padding()
            }
        }
        .navigationTitle(restaurant.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    RestaurantListView(
        selectedCuisines: ["Türk Mutfağı", "İtalyan"],
        selectedPriceRange: "Orta",
        selectedDistance: 5,
        selectedDietaryOptions: []
    )
} 