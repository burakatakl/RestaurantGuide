import SwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var showingSettings = false
    @State private var showingSignOutAlert = false
    @ObservedObject private var languageManager = LanguageManager.shared
    
    var body: some View {
        NavigationView {
            List {
                // Profil başlığı
                Section {
                    HStack(spacing: 15) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.orange)
                            .padding()
                            .background(Color.orange.opacity(0.1))
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(authManager.currentUser?.displayName ?? "Kullanıcı")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text(authManager.currentUser?.email ?? "")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                // Ana menü seçenekleri
                Section {
                    NavigationLink(destination: FavoritesView()) {
                        ProfileMenuRow(
                            icon: "heart.fill",
                            iconColor: .red,
                            title: "favorites".localized
                        )
                    }
                    
                    NavigationLink(destination: SocialView()) {
                        ProfileMenuRow(
                            icon: "person.2.fill",
                            iconColor: .blue,
                            title: "social".localized
                        )
                    }
                    
                    NavigationLink(destination: StatisticsView()) {
                        ProfileMenuRow(
                            icon: "chart.bar.fill",
                            iconColor: .purple,
                            title: "statistics".localized
                        )
                    }
                }
                
                // Ayarlar ve destek
                Section {
                    Button(action: { showingSettings = true }) {
                        ProfileMenuRow(
                            icon: "gearshape.fill",
                            iconColor: .gray,
                            title: "settings".localized
                        )
                    }
                    
                    NavigationLink(destination: Text("Help & Support")) {
                        ProfileMenuRow(
                            icon: "questionmark.circle.fill",
                            iconColor: .green,
                            title: "help_support".localized
                        )
                    }
                }
                
                // Çıkış yap
                Section {
                    Button(action: {
                        showingSignOutAlert = true
                    }) {
                        ProfileMenuRow(
                            icon: "rectangle.portrait.and.arrow.right",
                            iconColor: .red,
                            title: "sign out".localized
                        )
                    }
                }
            }
            .navigationTitle("profile".localized)
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
            .alert("sign out".localized, isPresented: $showingSignOutAlert) {
                Button("cancel".localized, role: .cancel) { }
                Button("sign out".localized, role: .destructive) {
                    do {
                        try authManager.signOut()
                        dismiss()
                    } catch {
                        print("Çıkış yapılırken hata oluştu: \(error)")
                    }
                }
            } message: {
                Text("sign out confirmation".localized)
            }
        }
        .languageAware()
    }
}

struct ProfileMenuRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(iconColor)
                .font(.system(size: 20))
                .frame(width: 24, height: 24)
            
            Text(title)
                .foregroundColor(.primary)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthenticationManager())
} 