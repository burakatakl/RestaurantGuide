import SwiftUI

struct AdvancedSearchView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedDietaryRestrictions: Set<String> = []
    @State private var selectedAmbience: Set<String> = []
    @State private var selectedFeatures: Set<String> = []
    @State private var ratingRange: ClosedRange<Double> = 0...5
    @State private var selectedTime: Date = Date()
    @State private var isOpenNow = true
    
    let dietaryRestrictions = ["vegetarian".localized, "vegan".localized, "gluten free".localized, "lactose free".localized, "halal".localized]
    let ambienceOptions = ["romantic".localized, "family".localized, "business".localized, "friends".localized, "quiet".localized]
    let featureOptions = ["wifi".localized, "terrace".localized, "parking".localized, "reservation".localized, "delivery".localized]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGray6)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        // Başlık
                        VStack(spacing: 8) {
                            Text("advanced search".localized)
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.primary)
                            
                            Text("advanced search subtitle".localized)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 20)
                        
                        // Diyet Kısıtlamaları
                        createSection(title: "dietary restrictions".localized, items: dietaryRestrictions, selectedItems: $selectedDietaryRestrictions)
                        
                        // Ortam
                        createSection(title: "ambience".localized, items: ambienceOptions, selectedItems: $selectedAmbience)
                        
                        // Özellikler
                        createSection(title: "features".localized, items: featureOptions, selectedItems: $selectedFeatures)
                        
                        // Puan Aralığı
                        VStack(alignment: .leading, spacing: 15) {
                            Text("rating range".localized)
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            VStack(spacing: 10) {
                                Text("\(String(format: "%.1f", ratingRange.lowerBound)) - \(String(format: "%.1f", ratingRange.upperBound))")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.orange)
                                
                                RangeSlider(value: $ratingRange, in: 0...5, step: 0.5)
                                    .accentColor(.orange)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                        
                        // Zaman Seçimi
                        VStack(alignment: .leading, spacing: 15) {
                            Text("time selection".localized)
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            VStack(spacing: 15) {
                                Toggle("open now".localized, isOn: $isOpenNow)
                                    .tint(.orange)
                                
                                if !isOpenNow {
                                    DatePicker("date time".localized, selection: $selectedTime, displayedComponents: [.date, .hourAndMinute])
                                        .datePickerStyle(.compact)
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                        
                        // Arama Butonu
                        Button(action:  {
                            // Arama işlemi burada yapılacak
                            dismiss()
                        }) {
                            HStack {
                                Text("start search".localized)
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
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.orange)
                    }
                }
            }
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
}

#Preview {
    AdvancedSearchView()
} 
