import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authManager: AuthenticationManager
    
    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var rememberMe = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false
    @State private var showForgotPassword = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // Logo ve başlık
                VStack(spacing: 10) {
                    Image(systemName: "fork.knife.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.orange)
                    
                    Text("welcome back".localized)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text("welcome back subtitle".localized)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 20)
                
                // Form alanları
                VStack(spacing: 20) {
                    // Email
                    VStack(alignment: .leading) {
                        Text("email".localized)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        TextField("email".localized, text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                    }
                    
                    // Şifre
                    VStack(alignment: .leading) {
                        Text("password".localized)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        HStack {
                            if showPassword {
                                TextField("password".localized, text: $password)
                                    .textContentType(.password)
                            } else {
                                SecureField("password".localized, text: $password)
                                    .textContentType(.password)
                            }
                            
                            Button(action: {
                                showPassword.toggle()
                            }) {
                                Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(.secondary)
                            }
                        }
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    // Beni Hatırla ve Şifremi Unuttum
                    HStack {
                        Toggle("remember me".localized, isOn: $rememberMe)
                            .toggleStyle(SwitchToggleStyle(tint: .orange))
                        
                        Spacer()
                        
                        Button(action: {
                            showForgotPassword = true
                        }) {
                            Text("forgot password".localized)
                                .foregroundColor(.orange)
                        }
                    }
                }
                .padding(.horizontal)
                
                // Giriş Yap butonu
                Button(action: {
                    Task {
                        await signIn()
                    }
                }) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("sign in".localized)
                            .font(.headline)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)
                .disabled(isLoading)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .alert(alertMessage, isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        }
        .sheet(isPresented: $showForgotPassword) {
            ForgotPasswordView()
        }
    }
    
    private func signIn() async {
        isLoading = true
        do {
            try await authManager.signIn(email: email, password: password)
            dismiss()
        } catch let error as AuthError {
            alertMessage = error.description
            showAlert = true
        } catch {
            alertMessage = "Beklenmeyen bir hata oluştu."
            showAlert = true
        }
        isLoading = false
    }
}

struct ForgotPasswordView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var email = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Email")) {
                    TextField("email".localized, text: $email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
                
                Section {
                    Button(action: {
                        Task {
                            await resetPassword()
                        }
                    }) {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                        } else {
                            Text("Şifre Sıfırlama Bağlantısı Gönder")
                        }
                    }
                    .disabled(email.isEmpty || isLoading)
                }
            }
            .navigationTitle("Şifremi Unuttum")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("İptal") {
                        dismiss()
                    }
                }
            }
            .alert(alertMessage, isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            }
        }
    }
    
    private func resetPassword() async {
        isLoading = true
        do {
            try await authManager.resetPassword(email: email)
            alertMessage = "Şifre sıfırlama bağlantısı email adresinize gönderildi."
            showAlert = true
            dismiss()
        } catch {
            alertMessage = "Şifre sıfırlama bağlantısı gönderilirken bir hata oluştu."
            showAlert = true
        }
        isLoading = false
    }
}

#Preview {
    LoginView()
} 