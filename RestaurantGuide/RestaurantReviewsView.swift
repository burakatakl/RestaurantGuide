import SwiftUI

struct RestaurantReviewsView: View {
    let restaurant: Restaurant
    @State private var showAddReview = false
    
    var body: some View {
        List {
            // Genel değerlendirme
            Section {
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Text("Genel Değerlendirme")
                            .font(.headline)
                        Spacer()
                        Text(String(format: "%.1f", restaurant.averageRating))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.orange)
                    }
                    
                    // Yıldızlar
                    HStack(spacing: 4) {
                        ForEach(1...5, id: \.self) { index in
                            Image(systemName: index <= Int(restaurant.averageRating) ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                        }
                    }
                    
                    Text("\(restaurant.reviews.count) değerlendirme")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 8)
            }
            
            // Yorumlar
            Section(header: Text("Yorumlar")) {
                ForEach(restaurant.reviews) { review in
                    ReviewRowView(review: review)
                }
            }
        }
        .navigationTitle("Değerlendirmeler")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showAddReview = true
                }) {
                    Image(systemName: "square.and.pencil")
                }
            }
        }
        .sheet(isPresented: $showAddReview) {
            AddReviewView(restaurant: restaurant)
        }
    }
}

struct ReviewRowView: View {
    let review: Review
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Kullanıcı ve tarih
            HStack {
                Text(review.userName)
                    .font(.headline)
                Spacer()
                Text(review.date.formatted(date: .numeric, time: .omitted))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // Yıldızlar
            HStack(spacing: 4) {
                ForEach(1...5, id: \.self) { index in
                    Image(systemName: index <= Int(review.rating) ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                        .font(.subheadline)
                }
                Text(String(format: "%.1f", review.rating))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // Yorum
            Text(review.comment)
                .font(.body)
            
            // Fotoğraflar
            if !review.photos.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(review.photos, id: \.self) { photo in
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipped()
                                .cornerRadius(8)
                        }
                    }
                }
            }
        }
        .padding(.vertical, 8)
    }
}

struct AddReviewView: View {
    let restaurant: Restaurant
    @Environment(\.dismiss) private var dismiss
    @State private var rating: Double = 4
    @State private var comment: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Değerlendirmeniz")) {
                    // Yıldız değerlendirmesi
                    HStack {
                        Text("Puan")
                        Spacer()
                        ForEach(1...5, id: \.self) { index in
                            Image(systemName: index <= Int(rating) ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                                .onTapGesture {
                                    rating = Double(index)
                                }
                        }
                    }
                    
                    // Yorum
                    VStack(alignment: .leading) {
                        Text("Yorumunuz")
                        TextEditor(text: $comment)
                            .frame(height: 100)
                    }
                }
            }
            .navigationTitle("Yorum Ekle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("İptal") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Paylaş") {
                        // Yorum paylaşma işlemi
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        RestaurantReviewsView(restaurant: Restaurant.sampleRestaurants[0])
    }
} 