import SwiftUI
import Charts

struct StatisticsView: View {
    @State private var selectedRestaurant: Restaurant?
    @State private var showingRestaurantPicker = false
    @ObservedObject private var languageManager = LanguageManager.shared
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Restoran seçimi
                    Button(action: { showingRestaurantPicker = true }) {
                        HStack {
                            if let restaurant = selectedRestaurant {
                                Text(restaurant.name)
                                    .font(.headline)
                            } else {
                                Text("select restaurant".localized)
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                    if selectedRestaurant != nil {
                        let statistics = RestaurantStatistics.sampleStatistics
                        
                        // Genel istatistikler
                        VStack(spacing: 15) {
                            StatisticCard(
                                title: "total visits".localized,
                                value: "\(statistics.totalVisits)",
                                icon: "person.3.fill"
                            )
                            
                            StatisticCard(
                                title: "average rating".localized,
                                value: String(format: "%.1f", statistics.averageRating),
                                icon: "star.fill"
                            )
                        }
                        .padding(.horizontal)
                        
                        // Popüler saatler grafiği
                        VStack(alignment: .leading, spacing: 10) {
                            Text("popular hours".localized)
                                .font(.headline)
                                .padding(.horizontal)
                            
                            Chart {
                                ForEach(Array(statistics.popularHours.keys.sorted()), id: \.self) { hour in
                                    BarMark(
                                        x: .value("Saat", hour),
                                        y: .value("Ziyaret", statistics.popularHours[hour] ?? 0)
                                    )
                                    .foregroundStyle(Color.orange.gradient)
                                }
                            }
                            .frame(height: 200)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                            .padding(.horizontal)
                        }
                        
                        // Trend menü öğeleri
                        VStack(alignment: .leading, spacing: 10) {
                            Text("trending items".localized)
                                .font(.headline)
                                .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(statistics.trendingItems) { item in
                                        TrendingItemCard(item: item)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        // Kullanıcı demografisi
                        VStack(alignment: .leading, spacing: 10) {
                            Text("user demographics".localized)
                                .font(.headline)
                                .padding(.horizontal)
                            
                            // Yaş grupları
                            Chart {
                                ForEach(Array(statistics.userDemographics.ageGroups.keys.sorted()), id: \.self) { ageGroup in
                                    BarMark(
                                        x: .value("Yaş Grubu", ageGroup),
                                        y: .value("Kullanıcı", statistics.userDemographics.ageGroups[ageGroup] ?? 0)
                                    )
                                    .foregroundStyle(Color.blue.gradient)
                                }
                            }
                            .frame(height: 200)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                            .padding(.horizontal)
                            
                            // Cinsiyet dağılımı
                            Chart {
                                ForEach(Array(statistics.userDemographics.genderDistribution.keys.sorted()), id: \.self) { gender in
                                    BarMark(
                                        x: .value("Cinsiyet", gender),
                                        y: .value("Kullanıcı", statistics.userDemographics.genderDistribution[gender] ?? 0)
                                    )
                                    .foregroundStyle(Color.purple.gradient)
                                }
                            }
                            .frame(height: 200)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                            .padding(.horizontal)
                            
                            // Ziyaret sıklığı
                            Chart {
                                ForEach(Array(statistics.userDemographics.visitFrequency.keys.sorted()), id: \.self) { frequency in
                                    BarMark(
                                        x: .value("Sıklık", frequency),
                                        y: .value("Kullanıcı", statistics.userDemographics.visitFrequency[frequency] ?? 0)
                                    )
                                    .foregroundStyle(Color.green.gradient)
                                }
                            }
                            .frame(height: 200)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("statistics".localized)
            .sheet(isPresented: $showingRestaurantPicker) {
                RestaurantPickerView(selectedRestaurant: $selectedRestaurant)
            }
        }
        .languageAware()
    }
}

struct StatisticCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(.orange)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

struct TrendingItemCard: View {
    let item: MenuItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: "photo")
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 80)
                .clipped()
                .cornerRadius(8)
            
            Text(item.name)
                .font(.subheadline)
                .fontWeight(.medium)
            
            Text(String(format: "₺%.2f", item.price))
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(width: 120)
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

struct RestaurantPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedRestaurant: Restaurant?
    
    var body: some View {
        NavigationView {
            List(Restaurant.sampleRestaurants) { restaurant in
                Button(action: {
                    selectedRestaurant = restaurant
                    dismiss()
                }) {
                    HStack {
                        Text(restaurant.name)
                        
                        Spacer()
                        
                        if selectedRestaurant?.id == restaurant.id {
                            Image(systemName: "checkmark")
                                .foregroundColor(.green)
                        }
                    }
                }
                .foregroundColor(.primary)
            }
            .navigationTitle("Restoran Seç")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("İptal") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    StatisticsView()
} 
 