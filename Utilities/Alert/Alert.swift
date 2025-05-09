import SwiftUI

struct AlertItem: Identifiable, Equatable {
    static func == (lhs: AlertItem, rhs: AlertItem) -> Bool {
        lhs.message == rhs.message
    }
    
    let id = UUID()
    let title: Text
    let message: Text
    let dismissButton : Alert.Button
}

struct AlertContext {
    // MARK: - Sign Up Alerts
    
    static let invalidEmail = AlertItem (
        title: Text("Invalid email"),
        message: Text("Please provide a valid e-mail address."),
        dismissButton: .default(Text("OK"))
    )
    
    static let invalidRecipientEmail = AlertItem (
        title: Text("Invalid recipient email"),
        message: Text("Email does not exist"),
        dismissButton: .default(Text("OK"))
    )
    
    static let emptyFields = AlertItem (
        title: Text("Missing Information"),
        message: Text("All fields must be filled."),
        dismissButton: .default(Text("OK"))
    )
    
    static let passwordsDoNotMatch = AlertItem (
        title: Text("Password Mismatch"),
        message: Text("Passwords do not match."),
        dismissButton: .default(Text("OK"))
    )
    
    static let weakPassword = AlertItem (
        title: Text("Weak Password"),
        message: Text("Your password must contain at least 8 characters, including a number, a letter, and a special character."),
        dismissButton: .default(Text("OK"))
    )
    
    static let firebaseError = AlertItem (
        title: Text("Sign Up Failed"),
        message: Text("An error occurred while creating the account. Please try again."),
        dismissButton: .default(Text("OK"))
    )
    
    static let userNotFound = AlertItem (
        title: Text("User Not Found"),
        message: Text("No user found with the provided email and password.Try again."),
        dismissButton: .default(Text("OK"))
    )
    
    static let wrongPassword = AlertItem(
        title: Text("Incorrect Password"),
        message: Text("The password you entered is incorrect. Please try again."),
        dismissButton: .default(Text("OK"))
    )
    
    static let resetPasswordSuccess = AlertItem(
        title: Text("Success"),
        message: Text("The password reset success"),
        dismissButton: .default(Text("OK"))
    )
    
    static let emailAlreadyExsists = AlertItem(
        title: Text("Sign up failed"),
        message: Text("User with the provided email already exists."),
        dismissButton: .default(Text("OK"))
    )
    
    static let defaultError = AlertItem(
        title: Text("Error"),
        message: Text("Something went wrong, please try again."),
        dismissButton: .default(Text("OK"))
    )
    
    //MARK: Reset credentials
    
    static let succesfulPasswordUpdate = AlertItem(
        title: Text("Succesfull"),
        message: Text("Password updated succesfully"),
        dismissButton: .default(Text("OK"))
    )
    
    static let succesfulEmailUpdate = AlertItem(
        title: Text("Succesfull"),
        message: Text("Email updated succesfully"),
        dismissButton: .default(Text("OK"))
    )
    
    //MARK: Delete user
    
    static let succesfulyDeletedUser = AlertItem (
        title: Text("Succesfull"),
        message: Text("Account deleted succesfully"),
        dismissButton: .default(Text("OK"))
    )
    
    //MARK: Update credentials
    static let updatePasswordError = AlertItem (
        title: Text("Error updating password"),
        message: Text("Error while updating password"),
        dismissButton: .default(Text("OK"))
    )
    
    static let updateEmailError = AlertItem (
        title: Text("Error updating email"),
        message: Text("Error while updating email"),
        dismissButton: .default(Text("OK"))
    )
    
    //MARK: Update user
    
    static let updateUserBioSucessfull = AlertItem (
        title: Text("Updated user bio"),
        message: Text("User bio is updated succesfully"),
        dismissButton: .default(Text("OK"))
    )
    
    static let updateUserBioError = AlertItem (
        title: Text("Error"),
        message: Text("Error while updating user biography"),
        dismissButton: .default(Text("OK"))
    )
    
}
