import SwiftUI

struct SocialView: View {
    @State private var selectedTab = 0
    @State private var showingShareSheet = false
    @State private var showingNewGroupReservation = false
    @ObservedObject private var languageManager = LanguageManager.shared
    
    var body: some View {
        NavigationView {
            VStack {
                // Tab seçimi
                Picker("", selection: $selectedTab) {
                    Text("friends".localized).tag(0)
                    Text("group_reservations".localized).tag(1)
                    Text("shared_reviews".localized).tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // Seçilen tab içeriği
                TabView(selection: $selectedTab) {
                    FriendsView()
                        .tag(0)
                    
                    GroupReservationsView()
                        .tag(1)
                    
                    SharedReviewsView()
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .navigationTitle("social".localized)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        if selectedTab == 1 {
                            showingNewGroupReservation = true
                        } else {
                            showingShareSheet = true
                        }
                    }) {
                        Image(systemName: selectedTab == 1 ? "calendar.badge.plus" : "square.and.arrow.up")
                    }
                }
            }
            .sheet(isPresented: $showingNewGroupReservation) {
                NewGroupReservationView()
            }
            .sheet(isPresented: $showingShareSheet) {
                ShareSheet(activityItems: ["Restoran önerisi paylaşıyorum!"])
            }
        }
        .languageAware()
    }
}

struct FriendsView: View {
    var body: some View {
        List {
            ForEach(User.sampleUsers) { user in
                HStack {
                    Image(systemName: user.profileImage)
                        .font(.title)
                        .foregroundColor(.orange)
                    
                    VStack(alignment: .leading) {
                        Text(user.name)
                            .font(.headline)
                        
                        Text("\(user.favoriteRestaurants.count) favori restoran")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // Arkadaş ekleme işlemi
                    }) {
                        Image(systemName: "person.badge.plus")
                            .foregroundColor(.orange)
                    }
                }
                .padding(.vertical, 8)
            }
        }
    }
}

struct GroupReservationsView: View {
    var body: some View {
        List {
            ForEach(GroupReservation.sampleReservations) { reservation in
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text(reservation.restaurant.name)
                            .font(.headline)
                        
                        Spacer()
                        
                        Text(reservation.status.rawValue)
                            .font(.subheadline)
                            .foregroundColor(reservation.status == .confirmed ? .green : .orange)
                    }
                    
                    Text(reservation.date.formatted(date: .long, time: .shortened))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        ForEach(reservation.participants) { participant in
                            Image(systemName: participant.profileImage)
                                .font(.caption)
                                .foregroundColor(.orange)
                        }
                    }
                }
                .padding(.vertical, 8)
            }
        }
    }
}

struct SharedReviewsView: View {
    var body: some View {
        List {
            ForEach(Restaurant.sampleRestaurants) { restaurant in
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text(restaurant.name)
                            .font(.headline)
                        
                        Spacer()
                        
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text(String(format: "%.1f", restaurant.rating))
                        }
                    }
                    
                    ForEach(restaurant.reviews) { review in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(review.userName)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                
                                Spacer()
                                
                                Text(review.date.formatted(date: .numeric, time: .omitted))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Text(review.comment)
                                .font(.body)
                        }
                        .padding(.vertical, 4)
                    }
                }
                .padding(.vertical, 8)
            }
        }
    }
}

struct NewGroupReservationView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedRestaurant: Restaurant?
    @State private var selectedDate = Date()
    @State private var selectedFriends: Set<User> = []
    @ObservedObject private var languageManager = LanguageManager.shared
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("restaurant".localized)) {
                    NavigationLink(destination: RestaurantListView(
                        selectedCuisines: [],
                        selectedPriceRange: "",
                        selectedDistance: 0,
                        selectedDietaryOptions: []
                    )) {
                        if let restaurant = selectedRestaurant {
                            Text(restaurant.name)
                        } else {
                            Text("select_restaurant".localized)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Section(header: Text("date_time".localized)) {
                    DatePicker("date".localized, selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                }
                
                Section(header: Text("friends".localized)) {
                    ForEach(User.sampleUsers) { user in
                        Button(action: {
                            if selectedFriends.contains(user) {
                                selectedFriends.remove(user)
                            } else {
                                selectedFriends.insert(user)
                            }
                        }) {
                            HStack {
                                Image(systemName: user.profileImage)
                                    .foregroundColor(.orange)
                                
                                Text(user.name)
                                
                                Spacer()
                                
                                if selectedFriends.contains(user) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.green)
                                }
                            }
                        }
                        .foregroundColor(.primary)
                    }
                }
            }
            .navigationTitle("new_group_reservation".localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("cancel".localized) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("create".localized) {
                        dismiss()
                    }
                    .disabled(selectedRestaurant == nil || selectedFriends.isEmpty)
                }
            }
        }
        .languageAware()
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    SocialView()
} 