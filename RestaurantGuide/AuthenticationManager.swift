import Foundation
import FirebaseAuth

enum AuthError: Error {
    case signInError
    case signUpError
    case signOutError
    case passwordResetError
    case userNotFound
    case invalidEmail
    case weakPassword
    case emailAlreadyInUse
    
    var description: String {
        switch self {
        case .signInError:
            return "Giriş yapılırken bir hata oluştu."
        case .signUpError:
            return "Kayıt olurken bir hata oluştu."
        case .signOutError:
            return "Çıkış yapılırken bir hata oluştu."
        case .passwordResetError:
            return "Şifre sıfırlanırken bir hata oluştu."
        case .userNotFound:
            return "Kullanıcı bulunamadı."
        case .invalidEmail:
            return "Geçersiz email adresi."
        case .weakPassword:
            return "Şifre çok zayıf. En az 6 karakter kullanın."
        case .emailAlreadyInUse:
            return "Bu email adresi zaten kullanımda."
        }
    }
}

struct UserData {
    let uid: String
    let email: String?
    let displayName: String?
    let photoURL: URL?
    
    init(user: FirebaseAuth.User) {
        self.uid = user.uid
        self.email = user.email
        self.displayName = user.displayName
        self.photoURL = user.photoURL
    }
}

@MainActor
class AuthenticationManager: ObservableObject {
    @Published var currentUser: UserData?
    @Published var isAuthenticated = false
    
    init() {
        if let user = Auth.auth().currentUser {
            self.currentUser = UserData(user: user)
            self.isAuthenticated = true
        }
    }
    
    func signIn(email: String, password: String) async throws {
        do {
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            currentUser = UserData(user: authResult.user)
            isAuthenticated = true
        } catch {
            throw AuthError.signInError
        }
    }
    
    func signUp(email: String, password: String) async throws {
        do {
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            currentUser = UserData(user: authResult.user)
            isAuthenticated = true
        } catch let error as NSError {
            switch error.code {
            case AuthErrorCode.invalidEmail.rawValue:
                throw AuthError.invalidEmail
            case AuthErrorCode.weakPassword.rawValue:
                throw AuthError.weakPassword
            case AuthErrorCode.emailAlreadyInUse.rawValue:
                throw AuthError.emailAlreadyInUse
            default:
                throw AuthError.signUpError
            }
        }
    }
    
    func signOut() throws {
        do {
            try Auth.auth().signOut()
            currentUser = nil
            isAuthenticated = false
        } catch {
            throw AuthError.signOutError
        }
    }
    
    func resetPassword(email: String) async throws {
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        } catch {
            throw AuthError.passwordResetError
        }
    }
    
    func updateEmail(to newEmail: String) async throws {
        do {
            try await Auth.auth().currentUser?.updateEmail(to: newEmail)
            if let user = Auth.auth().currentUser {
                currentUser = UserData(user: user)
            }
        } catch {
            throw AuthError.signInError
        }
    }
    
    func updatePassword(to newPassword: String) async throws {
        do {
            try await Auth.auth().currentUser?.updatePassword(to: newPassword)
        } catch {
            throw AuthError.signInError
        }
    }
} 