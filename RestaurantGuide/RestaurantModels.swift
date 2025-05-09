import Foundation

// Yorum modeli
struct Review: Identifiable {
    let id = UUID()
    let userName: String
    let rating: Double
    let comment: String
    let date: Date
    let photos: [String]  // Fotoğraf URL'leri
}

// Menü öğesi modeli
struct MenuItem: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let price: Double
    let category: String
    let photo: String  // Fotoğraf URL'i
    let dietaryOptions: Set<DietaryOption>
}

// Diyet seçenekleri
enum DietaryOption: String, CaseIterable {
    case vegetarian
    case vegan
    case glutenFree
    case dairyFree
    
    var localizedName: String {
        switch self {
        case .vegetarian: return "vegetarian".localized
        case .vegan: return "vegan".localized
        case .glutenFree: return "gluten free".localized
        case .dairyFree: return "dairy free".localized
        }
    }
}

// Menü kategorileri
enum MenuCategory: String, CaseIterable {
    case starters
    case mainCourse
    case desserts
    case drinks
    
    var localizedName: String {
        switch self {
        case .starters: return "appetizers".localized
        case .mainCourse: return "main courses".localized
        case .desserts: return "desserts".localized
        case .drinks: return "drinks".localized
        }
    }
}

// Örnek veriler
extension Review {
    static let sampleReviews = [
        Review(
            userName: "Ahmet Y.",
            rating: 4.5,
            comment: "Harika bir deneyimdi. Özellikle servis çok iyiydi.",
            date: Date().addingTimeInterval(-86400),
            photos: ["review_photo1", "review_photo2"]
        ),
        Review(
            userName: "Ayşe K.",
            rating: 5.0,
            comment: "Yemekler muhteşemdi. Kesinlikle tekrar geleceğim.",
            date: Date().addingTimeInterval(-172800),
            photos: ["review_photo3"]
        )
    ]
}

extension MenuItem {
    static let sampleMenuItems = [
        MenuItem(
            name: "Mercimek Çorbası",
            description: "Geleneksel Türk mercimek çorbası",
            price: 45.0,
            category: MenuCategory.starters.localizedName,
            photo: "menu_soup",
            dietaryOptions: [.vegetarian, .glutenFree]
        ),
        MenuItem(
            name: "Izgara Köfte",
            description: "El yapımı ızgara köfte, yanında pilav ve ızgara sebze",
            price: 120.0,
            category: MenuCategory.mainCourse.localizedName,
            photo: "menu_kofte",
            dietaryOptions: []
        ),
        MenuItem(
            name: "Künefe",
            description: "Geleneksel künefe, kaymak ile servis edilir",
            price: 75.0,
            category: MenuCategory.desserts.localizedName,
            photo: "menu_kunefe",
            dietaryOptions: [.vegetarian]
        )
    ]
} 