import Foundation

struct Restaurant: Identifiable {
    let id = UUID()
    let name: String
    let cuisine: String
    let priceRange: String
    let rating: Double
    let distance: Double
    let imageName: String
    let description: String
    let reviews: [Review]
    let menuItems: [MenuItem]
    let dietaryOptions: [String]
    
    var averageRating: Double {
        if reviews.isEmpty { return rating }
        return reviews.map { $0.rating }.reduce(0, +) / Double(reviews.count)
    }
    
    var menuCategories: [String] {
        Array(Set(menuItems.map { $0.category })).sorted()
    }
}

// Örnek veriler
extension Restaurant {
    static let sampleRestaurants = [
        Restaurant(
            name: "Lezzet Durağı",
            cuisine: "Türk Mutfağı",
            priceRange: "Orta",
            rating: 4.5,
            distance: 2.5,
            imageName: "restaurant1",
            description: "Geleneksel Türk mutfağının en seçkin lezzetleri",
            reviews: Review.sampleReviews,
            menuItems: MenuItem.sampleMenuItems,
            dietaryOptions: ["vegetarian".localized, "halal".localized]
        ),
        Restaurant(
            name: "Pizza Express",
            cuisine: "İtalyan",
            priceRange: "Ucuz",
            rating: 4.2,
            distance: 1.8,
            imageName: "restaurant2",
            description: "İtalyan mutfağının en lezzetli pizzaları",
            reviews: Review.sampleReviews,
            menuItems: MenuItem.sampleMenuItems,
            dietaryOptions: ["vegetarian".localized]
        ),
        Restaurant(
            name: "Sushi Master",
            cuisine: "Japon",
            priceRange: "Pahalı",
            rating: 4.8,
            distance: 3.2,
            imageName: "restaurant3",
            description: "Otantik Japon mutfağı deneyimi",
            reviews: Review.sampleReviews,
            menuItems: MenuItem.sampleMenuItems,
            dietaryOptions: ["gluten free".localized]
        ),
        Restaurant(
            name: "Noodle House",
            cuisine: "Çin",
            priceRange: "Orta",
            rating: 4.0,
            distance: 4.5,
            imageName: "restaurant4",
            description: "Geleneksel Çin mutfağından lezzetler",
            reviews: Review.sampleReviews,
            menuItems: MenuItem.sampleMenuItems,
            dietaryOptions: ["vegetarian".localized, "vegan".localized]
        ),
        Restaurant(
            name: "Burger King",
            cuisine: "Fast Food",
            priceRange: "Ucuz",
            rating: 3.8,
            distance: 1.2,
            imageName: "restaurant5",
            description: "Hızlı ve lezzetli fast food seçenekleri",
            reviews: Review.sampleReviews,
            menuItems: MenuItem.sampleMenuItems,
            dietaryOptions: ["halal".localized]
        )
    ]
} 