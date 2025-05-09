import Foundation

// Sosyal özellikler için modeller
struct User: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let profileImage: String
    let favoriteRestaurants: [Restaurant]
    let friends: [User]
    
    // Hashable için gerekli fonksiyonlar
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct GroupReservation: Identifiable {
    let id = UUID()
    let restaurant: Restaurant
    let date: Date
    let participants: [User]
    let status: ReservationStatus
}

enum ReservationStatus: String {
    case pending
    case confirmed
    case cancelled
    
    var localizedName: String {
        switch self {
        case .pending: return "reservation pending".localized
        case .confirmed: return "reservation confirmed".localized
        case .cancelled: return "reservation cancelled".localized
        }
    }
}

// İstatistikler için modeller
struct RestaurantStatistics {
    let restaurant: Restaurant
    let totalVisits: Int
    let averageRating: Double
    let popularHours: [String: Int] // Saat: Ziyaret sayısı
    let trendingItems: [MenuItem]
    let userDemographics: UserDemographics
}

struct UserDemographics {
    let ageGroups: [String: Int] // Yaş grubu: Kullanıcı sayısı
    let genderDistribution: [String: Int] // Cinsiyet: Kullanıcı sayısı
    let visitFrequency: [String: Int] // Sıklık: Kullanıcı sayısı
}

// Gelişmiş arama için modeller
struct AdvancedSearchFilters {
    var isChildFriendly: Bool = false
    var isPetFriendly: Bool = false
    var hasOutdoorSeating: Bool = false
    var hasParking: Bool = false
    var hasWifi: Bool = false
    var hasDelivery: Bool = false
    var hasTakeout: Bool = false
    var hasReservation: Bool = false
    var hasWheelchairAccess: Bool = false
    var hasLiveMusic: Bool = false
    var hasAlcohol: Bool = false
    var hasVegetarianOptions: Bool = false
    var hasVeganOptions: Bool = false
    var hasGlutenFreeOptions: Bool = false
}

// Örnek veriler
extension User {
    static let sampleUsers = [
        User(
            name: "Burak Atakli",
            profileImage: "person.circle.fill",
            favoriteRestaurants: [Restaurant.sampleRestaurants[0], Restaurant.sampleRestaurants[1]],
            friends: []
        ),
        User(
            name: "Ayşe Demir",
            profileImage: "person.circle.fill",
            favoriteRestaurants: [Restaurant.sampleRestaurants[2]],
            friends: []
        )
    ]
}

extension GroupReservation {
    static let sampleReservations = [
        GroupReservation(
            restaurant: Restaurant.sampleRestaurants[0],
            date: Date().addingTimeInterval(86400),
            participants: User.sampleUsers,
            status: .confirmed
        )
    ]
}

extension RestaurantStatistics {
    static let sampleStatistics = RestaurantStatistics(
        restaurant: Restaurant.sampleRestaurants[0],
        totalVisits: 1500,
        averageRating: 4.5,
        popularHours: [
            "12:00": 120,
            "13:00": 150,
            "19:00": 200,
            "20:00": 180
        ],
        trendingItems: MenuItem.sampleMenuItems,
        userDemographics: UserDemographics(
            ageGroups: [
                "18-24": 300,
                "25-34": 500,
                "35-44": 400,
                "45+": 300
            ],
            genderDistribution: [
                "gender male".localized: 800,
                "gender female".localized: 700
            ],
            visitFrequency: [
                "visit weekly".localized: 200,
                "visit monthly".localized: 500,
                "visit yearly".localized: 800
            ]
        )
    )
} 
