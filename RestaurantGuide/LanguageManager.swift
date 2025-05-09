import Foundation
import SwiftUI

class LanguageManager: ObservableObject {
    @Published var currentLanguage: Language {
        didSet {
            UserDefaults.standard.set(currentLanguage.rawValue, forKey: "AppLanguage")
            // Dil değişikliğini bildirme
            NotificationCenter.default.post(name: Notification.Name("LanguageChanged"), object: nil)
            // Locale'i güncelle
            UserDefaults.standard.set([currentLanguage.rawValue], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
        }
    }
    
    static let shared = LanguageManager()
    
    init() {
        // Kaydedilmiş dili yükle veya varsayılan olarak sistem dilini kullan
        if let savedLanguage = UserDefaults.standard.string(forKey: "AppLanguage"),
           let language = Language(rawValue: savedLanguage) {
            currentLanguage = language
        } else {
            // Sistem dilini kontrol et
            let systemLanguage = Locale.current.language.languageCode?.identifier ?? "tr"
            currentLanguage = Language(rawValue: systemLanguage) ?? .turkish
        }
    }
    
    enum Language: String, CaseIterable {
        case turkish = "tr"
        case english = "en"
        
        var displayName: String {
            switch self {
            case .turkish: return "Türkçe"
            case .english: return "English"
            }
        }
        
        var locale: Locale {
            return Locale(identifier: self.rawValue)
        }
    }
    
    // Dil değişikliğini uygula ve görünümleri yenile
    func setLanguage(_ language: Language) {
        currentLanguage = language
        // View'ları yeniden yükle
        NotificationCenter.default.post(name: NSNotification.Name("RefreshViews"), object: nil)
    }
}

// String uzantısı ile lokalizasyon desteği
extension String {
    var localized: String {
        let language = LanguageManager.shared.currentLanguage
        guard let path = Bundle.main.path(forResource: language.rawValue, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return NSLocalizedString(self, comment: "")
        }
        return bundle.localizedString(forKey: self, value: nil, table: nil)
    }
}

// Dil değişikliğini dinleyen view modifier
struct LanguageAwareModifier: ViewModifier {
    @ObservedObject private var languageManager = LanguageManager.shared
    @State private var refreshID = UUID()
    
    func body(content: Content) -> some View {
        content
            .id(refreshID) // View'ı yeniden oluştur
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("RefreshViews"))) { _ in
                refreshID = UUID() // ID'yi değiştirerek view'ı yenile
            }
    }
}

extension View {
    func languageAware() -> some View {
        modifier(LanguageAwareModifier())
    }
}

// Dil seçimi için view
struct LanguageSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var languageManager = LanguageManager.shared
    
    var body: some View {
        NavigationView {
            List {
                ForEach(LanguageManager.Language.allCases, id: \.self) { language in
                    Button(action: {
                        languageManager.setLanguage(language)
                        dismiss()
                    }) {
                        HStack {
                            Text(language.displayName)
                            Spacer()
                            if languageManager.currentLanguage == language {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.green)
                            }
                        }
                    }
                    .foregroundColor(.primary)
                }
            }
            .navigationTitle("language_selection".localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("done".localized) {
                        dismiss()
                    }
                }
            }
        }
    }
} 