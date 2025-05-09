import SwiftUI

struct SettingsView: View {
    @ObservedObject private var languageManager = LanguageManager.shared
    @State private var showingLanguageSelection = false
    
    var body: some View {
        NavigationView {
            Form {
                // Dil ayarları
                Section(header: Text("language_selection".localized)) {
                    Button(action: { showingLanguageSelection = true }) {
                        HStack {
                            Text(languageManager.currentLanguage.displayName)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                // Diğer ayarlar buraya eklenebilir
                Section(header: Text("notifications".localized)) {
                    Toggle("push_notifications".localized, isOn: .constant(true))
                    Toggle("email_notifications".localized, isOn: .constant(false))
                }
                
                Section(header: Text("about".localized)) {
                    NavigationLink(destination: Text("Version 1.0")) {
                        Text("app_version".localized)
                    }
                    
                    Button(action: {
                        // Gizlilik politikası
                    }) {
                        Text("privacy_policy".localized)
                    }
                    
                    Button(action: {
                        // Kullanım koşulları
                    }) {
                        Text("terms_of_service".localized)
                    }
                }
            }
            .navigationTitle("settings".localized)
            .sheet(isPresented: $showingLanguageSelection) {
                LanguageSelectionView()
            }
        }
        .languageAware()
    }
}

#Preview {
    SettingsView()
} 