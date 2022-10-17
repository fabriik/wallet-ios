// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// FIO
  internal static let sendFioToLabel = L10n.tr("Localizable", "Send_fio_toLabel", fallback: "FIO")
  /// Always require passcode
  internal static let touchIdSpendingLimit = L10n.tr("Localizable", "TouchIdSpendingLimit", fallback: "Always require passcode")
  internal enum ATMMapView {
    /// ATM Cash Locations Map
    internal static let title = L10n.tr("Localizable", "ATMMapView.title", fallback: "ATM Cash Locations Map")
  }
  internal enum About {
    /// Blog
    internal static let blog = L10n.tr("Localizable", "About.blog", fallback: "Blog")
    /// Made by the global Fabriik team.
    /// Version %1$s Build %2$s
    internal static func footer(_ p1: UnsafePointer<CChar>, _ p2: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "About.footer", p1, p2, fallback: "Made by the global Fabriik team.\nVersion %1$s Build %2$s")
    }
    /// Privacy Policy
    internal static let privacy = L10n.tr("Localizable", "About.privacy", fallback: "Privacy Policy")
    /// Reddit
    internal static let reddit = L10n.tr("Localizable", "About.reddit", fallback: "Reddit")
    /// Terms And Conditions
    internal static let terms = L10n.tr("Localizable", "About.terms", fallback: "Terms And Conditions")
    /// About
    internal static let title = L10n.tr("Localizable", "About.title", fallback: "About")
    /// Twitter
    internal static let twitter = L10n.tr("Localizable", "About.twitter", fallback: "Twitter")
    /// Fabriik Rewards ID
    internal static let walletID = L10n.tr("Localizable", "About.walletID", fallback: "Fabriik Rewards ID")
    internal enum AppName {
      /// Fabriik
      internal static let android = L10n.tr("Localizable", "About.appName.android", fallback: "Fabriik")
    }
  }
  internal enum AccessibilityLabels {
    /// Close
    internal static let close = L10n.tr("Localizable", "AccessibilityLabels.close", fallback: "Close")
    /// Support Center
    internal static let faq = L10n.tr("Localizable", "AccessibilityLabels.faq", fallback: "Support Center")
  }
  internal enum Account {
    /// ACCOUNT LIMITS
    internal static let accountLimits = L10n.tr("Localizable", "Account.AccountLimits", fallback: "ACCOUNT LIMITS")
    /// Account Verification
    internal static let accountVerification = L10n.tr("Localizable", "Account.AccountVerification", fallback: "Account Verification")
    /// Verify your account
    internal static let accountVerify = L10n.tr("Localizable", "Account.AccountVerify", fallback: "Verify your account")
    /// Balance
    internal static let balance = L10n.tr("Localizable", "Account.balance", fallback: "Balance")
    /// Before you confirm, please:
    internal static let beforeConfirm = L10n.tr("Localizable", "Account.BeforeConfirm", fallback: "Before you confirm, please:")
    /// Change your email
    internal static let changeEmail = L10n.tr("Localizable", "Account.ChangeEmail", fallback: "Change your email")
    /// Country
    internal static let country = L10n.tr("Localizable", "Account.Country", fallback: "Country")
    /// Create a Fabriik account by entering your email address.
    internal static let createAccount = L10n.tr("Localizable", "Account.CreateAccount", fallback: "Create a Fabriik account by entering your email address.")
    /// Current limit: $1,000/day
    internal static let currentLimit = L10n.tr("Localizable", "Account.CurrentLimit", fallback: "Current limit: $1,000/day")
    /// Oops! We had some issues processing your data
    internal static let dataIssues = L10n.tr("Localizable", "Account.DataIssues", fallback: "Oops! We had some issues processing your data")
    /// Date of birth
    internal static let dateOfBirth = L10n.tr("Localizable", "Account.DateOfBirth", fallback: "Date of birth")
    /// Declined
    internal static let declined = L10n.tr("Localizable", "Account.Declined", fallback: "Declined")
<<<<<<< HEAD
    /// Delete account option in menu
=======
    /// Delete account
>>>>>>> mit
    internal static let deleteAccount = L10n.tr("Localizable", "Account.DeleteAccount", fallback: "Delete account")
    /// This token has been delisted. 
    /// 
    /// You may still be able to send these tokens to another platform. For more details, visit our support page.
    internal static let delistedToken = L10n.tr("Localizable", "Account.delistedToken", fallback: "This token has been delisted. \n\nYou may still be able to send these tokens to another platform. For more details, visit our support page.")
    /// Make sure document details are clearly visible and within the frame
    internal static let documentConfirmation = L10n.tr("Localizable", "Account.DocumentConfirmation", fallback: "Make sure document details are clearly visible and within the frame")
    /// %1$@ per %2$@
    internal static func exchangeRate(_ p1: Any, _ p2: Any) -> String {
      return L10n.tr("Localizable", "Account.exchangeRate", String(describing: p1), String(describing: p2), fallback: "%1$@ per %2$@")
    }
    /// Get full access to your Fabriik wallet
    internal static let fullAccess = L10n.tr("Localizable", "Account.FullAccess", fallback: "Get full access to your Fabriik wallet")
    /// ID Verification
    internal static let idVerification = L10n.tr("Localizable", "Account.IDVerification", fallback: "ID Verification")
    /// Loading Wallet
    internal static let loadingMessage = L10n.tr("Localizable", "Account.loadingMessage", fallback: "Loading Wallet")
    /// Verify your account to get full access to your Fabriik wallet!
    internal static let messageVerifyAccount = L10n.tr("Localizable", "Account.MessageVerifyAccount", fallback: "Verify your account to get full access to your Fabriik wallet!")
    /// Pending
    internal static let pending = L10n.tr("Localizable", "Account.Pending", fallback: "Pending")
<<<<<<< HEAD
    /// Account Personal Information title
=======
    /// Personal Information
>>>>>>> mit
    internal static let personalInformation = L10n.tr("Localizable", "Account.PersonalInformation", fallback: "Personal Information")
    /// I'm ok with receiving future promotion, offers and communications
    internal static let promotion = L10n.tr("Localizable", "Account.Promotion", fallback: "I'm ok with receiving future promotion, offers and communications")
    /// Proof of Identity
    internal static let proofOfIdentity = L10n.tr("Localizable", "Account.ProofOfIdentity", fallback: "Proof of Identity")
    /// Resubmit
    internal static let resubmit = L10n.tr("Localizable", "Account.Resubmit", fallback: "Resubmit")
<<<<<<< HEAD
    /// Retake photo button on create account
=======
    /// Retake photo
>>>>>>> mit
    internal static let retakePhoto = L10n.tr("Localizable", "Account.RetakePhoto", fallback: "Retake photo")
    /// Submit your photo
    internal static let submitPhoto = L10n.tr("Localizable", "Account.SubmitPhoto", fallback: "Submit your photo")
    /// Swap limit: $10,000 USD/day
    /// Buy limit: $500 USD/day
    internal static let swapAndBuyLimit = L10n.tr("Localizable", "Account.SwapAndBuyLimit", fallback: "Swap limit: $10,000 USD/day\nBuy limit: $500 USD/day")
    /// Upgrade your limits
    internal static let upgradeLimits = L10n.tr("Localizable", "Account.UpgradeLimits", fallback: "Upgrade your limits")
    /// You need to be at least 18 years old to complete Level 1 verification
    internal static let verification = L10n.tr("Localizable", "Account.Verification", fallback: "You need to be at least 18 years old to complete Level 1 verification")
    /// Why is my verification declined?
    internal static let verificationDeclined = L10n.tr("Localizable", "Account.VerificationDeclined", fallback: "Why is my verification declined?")
    /// Verified
    internal static let verified = L10n.tr("Localizable", "Account.Verified", fallback: "Verified")
<<<<<<< HEAD
    /// Verified account message on profile screen
=======
    /// We’ll let you know when your account is verified.
>>>>>>> mit
    internal static let verifiedAccountMessage = L10n.tr("Localizable", "Account.VerifiedAccountMessage", fallback: "We’ll let you know when your account is verified.")
    /// If you verify your account, you are given access to:
    /// ・Unlimited deposits/withdrawals
    /// ・Enhanced security
    /// ・Full asset support
    /// ・Buy assets with credit card
    /// ・24/7/365 live customer support
    internal static let verifyAccountText = L10n.tr("Localizable", "Account.VerifyAccountText", fallback: "If you verify your account, you are given access to:\n・Unlimited deposits/withdrawals\n・Enhanced security\n・Full asset support\n・Buy assets with credit card\n・24/7/365 live customer support")
    /// Enter and verify your new email address for your Fabriik account.
    internal static let verifyEmail = L10n.tr("Localizable", "Account.VerifyEmail", fallback: "Enter and verify your new email address for your Fabriik account.")
    /// We need to verify your identity in order to buy/sell and swap crypto.
    internal static let verifyIdentity = L10n.tr("Localizable", "Account.VerifyIdentity", fallback: "We need to verify your identity in order to buy/sell and swap crypto.")
    /// We need to verify your personal information for compliance purposes. This information won’t be shared with outside sources unless required by law.
    internal static let verifyPersonalInformation = L10n.tr("Localizable", "Account.VerifyPersonalInformation", fallback: "We need to verify your personal information for compliance purposes. This information won’t be shared with outside sources unless required by law.")
    /// Welcome!
    internal static let welcome = L10n.tr("Localizable", "Account.Welcome", fallback: "Welcome!")
    /// Why should I verify my account?
    internal static let whyVerify = L10n.tr("Localizable", "Account.WhyVerify", fallback: "Why should I verify my account?")
    /// Write your name as it appears on your ID
    internal static let writeYourName = L10n.tr("Localizable", "Account.WriteYourName", fallback: "Write your name as it appears on your ID")
  }
  internal enum AccountCreation {
    /// Only create a Hedera account if you intend on storing HBAR in your wallet.
    internal static let body = L10n.tr("Localizable", "AccountCreation.body", fallback: "Only create a Hedera account if you intend on storing HBAR in your wallet.")
    /// Change my email
    internal static let changeEmail = L10n.tr("Localizable", "AccountCreation.ChangeEmail", fallback: "Change my email")
    /// Verification code sent.
    internal static let codeSent = L10n.tr("Localizable", "AccountCreation.CodeSent", fallback: "Verification code sent.")
    /// Create Account
    internal static let create = L10n.tr("Localizable", "AccountCreation.create", fallback: "Create Account")
    /// Creating Account
    internal static let creating = L10n.tr("Localizable", "AccountCreation.creating", fallback: "Creating Account")
    /// Please enter the code we’ve sent to
    internal static let enterCode = L10n.tr("Localizable", "AccountCreation.EnterCode", fallback: "Please enter the code we’ve sent to")
    /// An error occurred during account creation. Please try again later.
    internal static let error = L10n.tr("Localizable", "AccountCreation.error", fallback: "An error occurred during account creation. Please try again later.")
    /// Not Now
    internal static let notNow = L10n.tr("Localizable", "AccountCreation.notNow", fallback: "Not Now")
    /// Re-send my code
    internal static let resendCode = L10n.tr("Localizable", "AccountCreation.ResendCode", fallback: "Re-send my code")
    /// The Request timed out. Please try again later.
    internal static let timeout = L10n.tr("Localizable", "AccountCreation.timeout", fallback: "The Request timed out. Please try again later.")
    /// Confirm Account Creation
    internal static let title = L10n.tr("Localizable", "AccountCreation.title", fallback: "Confirm Account Creation")
    /// Verify your email
    internal static let verifyEmail = L10n.tr("Localizable", "AccountCreation.VerifyEmail", fallback: "Verify your email")
    /// If you enter an incorrect wallet PIN too many times, your wallet will become disabled for a certain amount of time.
    /// This is to prevent someone else from trying to guess your PIN by quickly making many guesses.
    /// If your wallet is disabled, wait until the time shown and you will be able to enter your PIN again.
    /// 
    /// If you continue to enter the incorrect PIN, the amount of waiting time in between attempts will increase. Eventually, the app will reset and you can start a new wallet.
    /// 
    /// If you have the recovery phrase for your wallet, you can use it to reset your PIN by clicking the “Reset PIN” button.
    internal static let walletDisabled = L10n.tr("Localizable", "AccountCreation.WalletDisabled", fallback: "If you enter an incorrect wallet PIN too many times, your wallet will become disabled for a certain amount of time.\nThis is to prevent someone else from trying to guess your PIN by quickly making many guesses.\nIf your wallet is disabled, wait until the time shown and you will be able to enter your PIN again.\n\nIf you continue to enter the incorrect PIN, the amount of waiting time in between attempts will increase. Eventually, the app will reset and you can start a new wallet.\n\nIf you have the recovery phrase for your wallet, you can use it to reset your PIN by clicking the “Reset PIN” button.")
    /// Why is my wallet disabled?
    internal static let walletDisabledTitle = L10n.tr("Localizable", "AccountCreation.WalletDisabledTitle", fallback: "Why is my wallet disabled?")
  }
  internal enum AccountDelete {
    /// Your account has been deleted.
    /// We are sorry to see you go.
    internal static let accountDeletedPopup = L10n.tr("Localizable", "AccountDelete.AccountDeletedPopup", fallback: "Your account has been deleted.\nWe are sorry to see you go.")
    /// You are about to delete your Fabriik account.
    internal static let deleteAccountTitle = L10n.tr("Localizable", "AccountDelete.DeleteAccountTitle", fallback: "You are about to delete your Fabriik account.")
    /// What does this mean?
    internal static let deleteWhatMean = L10n.tr("Localizable", "AccountDelete.DeleteWhatMean", fallback: "What does this mean?")
    /// -You will no longer be able to use your email to sign in into Fabriik Wallet
    internal static let explanationOne = L10n.tr("Localizable", "AccountDelete.ExplanationOne", fallback: "-You will no longer be able to use your email to sign in into Fabriik Wallet")
    /// -Your private keys are still yours, keep your security phrase in a safe place in case you need to restore your wallet.
    internal static let explanationThree = L10n.tr("Localizable", "AccountDelete.ExplanationThree", fallback: "-Your private keys are still yours, keep your security phrase in a safe place in case you need to restore your wallet.")
    /// -You will no longer be able to user your KYC and registration status
    internal static let explanationTwo = L10n.tr("Localizable", "AccountDelete.ExplanationTwo", fallback: "-You will no longer be able to user your KYC and registration status")
    /// I understand that the only way to recover my wallet is by entering my recovery phrase
    internal static let recoverWallet = L10n.tr("Localizable", "AccountDelete.RecoverWallet", fallback: "I understand that the only way to recover my wallet is by entering my recovery phrase")
  }
  internal enum AccountHeader {
    /// My Fabriik
    internal static let defaultWalletName = L10n.tr("Localizable", "AccountHeader.defaultWalletName", fallback: "My Fabriik")
  }
  internal enum AccountKYCLevelOne {
    /// Level 1
    internal static let levelOne = L10n.tr("Localizable", "AccountKYCLevelOne.LevelOne", fallback: "Level 1")
    /// Account limit: $1,000/day ($10,000 lifetime)
    internal static let limit = L10n.tr("Localizable", "AccountKYCLevelOne.Limit", fallback: "Account limit: $1,000/day ($10,000 lifetime)")
  }
  internal enum AccountKYCLevelTwo {
    /// You have captured the entire back page of the document
    internal static let backPageInstructions = L10n.tr("Localizable", "AccountKYCLevelTwo.BackPageInstructions", fallback: "You have captured the entire back page of the document")
    /// Before you start, please:
    internal static let beforeStart = L10n.tr("Localizable", "AccountKYCLevelTwo.BeforeStart", fallback: "Before you start, please:")
    /// Buy limits: $500 USD/day, no lifetime limit
    internal static let buyLimits = L10n.tr("Localizable", "AccountKYCLevelTwo.BuyLimits", fallback: "Buy limits: $500 USD/day, no lifetime limit")
    /// Make sure to capture the entire back page of the document
    internal static let captureBackPage = L10n.tr("Localizable", "AccountKYCLevelTwo.CaptureBackPage", fallback: "Make sure to capture the entire back page of the document")
    /// Make sure to capture the entire front page of the document
    internal static let captureFrontPage = L10n.tr("Localizable", "AccountKYCLevelTwo.CaptureFrontPage", fallback: "Make sure to capture the entire front page of the document")
    /// Checking for errors
    internal static let checkingErrors = L10n.tr("Localizable", "AccountKYCLevelTwo.CheckingErrors", fallback: "Checking for errors")
    /// Please complete Level 1 verification first.
    internal static let completeLevelOneFirst = L10n.tr("Localizable", "AccountKYCLevelTwo.CompleteLevelOneFirst", fallback: "Please complete Level 1 verification first.")
<<<<<<< HEAD
    /// Confirm ID label in KYC2 flow
=======
    /// We need to confirm your ID
>>>>>>> mit
    internal static let confirmID = L10n.tr("Localizable", "AccountKYCLevelTwo.ConfirmID", fallback: "We need to confirm your ID")
    /// You have captured the entire document
    internal static let documentConfirmation = L10n.tr("Localizable", "AccountKYCLevelTwo.DocumentConfirmation", fallback: "You have captured the entire document")
    /// We are reviewing your documents and will let you know when your account has been verified.
    internal static let documentsReview = L10n.tr("Localizable", "AccountKYCLevelTwo.DocumentsReview", fallback: "We are reviewing your documents and will let you know when your account has been verified.")
    /// Driver’s license
    internal static let drivingLicence = L10n.tr("Localizable", "AccountKYCLevelTwo.DrivingLicence", fallback: "Driver’s license")
<<<<<<< HEAD
    /// Face capture instructions text on documents for KYC2
=======
    /// You have captured your entire face in the frame.
>>>>>>> mit
    internal static let faceCaptureInstructions = L10n.tr("Localizable", "AccountKYCLevelTwo.FaceCaptureInstructions", fallback: "You have captured your entire face in the frame.")
    /// Make sure your face is in the frame and clearly visible
    internal static let faceVisible = L10n.tr("Localizable", "AccountKYCLevelTwo.FaceVisible", fallback: "Make sure your face is in the frame and clearly visible")
    /// Your face is clearly visible.
    internal static let faceVisibleConfirmation = L10n.tr("Localizable", "AccountKYCLevelTwo.FaceVisibleConfirmation", fallback: "Your face is clearly visible.")
    /// You have captured the entire front page of the document
    internal static let frontPageInstructions = L10n.tr("Localizable", "AccountKYCLevelTwo.FrontPageInstructions", fallback: "You have captured the entire front page of the document")
    /// Your ID verification is in progress
    internal static let inProgress = L10n.tr("Localizable", "AccountKYCLevelTwo.InProgress", fallback: "Your ID verification is in progress")
    /// Make sure to capture the entire document
    internal static let instructions = L10n.tr("Localizable", "AccountKYCLevelTwo.Instructions", fallback: "Make sure to capture the entire document")
    /// Level 2
    internal static let levelTwo = L10n.tr("Localizable", "AccountKYCLevelTwo.LevelTwo", fallback: "Level 2")
    /// Swap limits: $10,000 USD/day, no lifetime limit
    internal static let limits = L10n.tr("Localizable", "AccountKYCLevelTwo.Limits", fallback: "Swap limits: $10,000 USD/day, no lifetime limit")
    /// Make sure you are in a well-lit room
    internal static let makeSure = L10n.tr("Localizable", "AccountKYCLevelTwo.MakeSure", fallback: "Make sure you are in a well-lit room")
    /// National ID card
    internal static let nationalIdCard = L10n.tr("Localizable", "AccountKYCLevelTwo.NationalIdCard", fallback: "National ID card")
    /// Passport
    internal static let passport = L10n.tr("Localizable", "AccountKYCLevelTwo.Passport", fallback: "Passport")
<<<<<<< HEAD
    /// Prepare documents label in KYC2
    internal static let prepareDocument = L10n.tr("Localizable", "AccountKYCLevelTwo.PrepareDocument", fallback: "Prepare a valid government-issued identity document (Passport, National ID card or Drivers license)")
    /// Residence permit
    internal static let residencePermit = L10n.tr("Localizable", "AccountKYCLevelTwo.ResidencePermit", fallback: "Residence permit")
    /// Select documents  options text label in KYC2
=======
    /// Prepare a valid government-issued identity document (Passport, National ID card or Drivers license)
    internal static let prepareDocument = L10n.tr("Localizable", "AccountKYCLevelTwo.PrepareDocument", fallback: "Prepare a valid government-issued identity document (Passport, National ID card or Drivers license)")
    /// Residence permit
    internal static let residencePermit = L10n.tr("Localizable", "AccountKYCLevelTwo.ResidencePermit", fallback: "Residence permit")
    /// Select one of the following options:
>>>>>>> mit
    internal static let selectOptions = L10n.tr("Localizable", "AccountKYCLevelTwo.SelectOptions", fallback: "Select one of the following options:")
    /// Sending your data for verification
    internal static let sendingData = L10n.tr("Localizable", "AccountKYCLevelTwo.SendingData", fallback: "Sending your data for verification")
    /// Make sure your ID is clear and readable and fits fully in the frame
    internal static let takeIdBackPhotoContent = L10n.tr("Localizable", "AccountKYCLevelTwo.TakeIdBackPhotoContent", fallback: "Make sure your ID is clear and readable and fits fully in the frame")
    /// Please take a photo of your ID’s back page
    internal static let takeIdBackPhotoTitle = L10n.tr("Localizable", "AccountKYCLevelTwo.TakeIdBackPhotoTitle", fallback: "Please take a photo of your ID’s back page")
    /// Make sure your ID is clear and readable and fits fully in the frame
    internal static let takeIdFrontPhotoContent = L10n.tr("Localizable", "AccountKYCLevelTwo.TakeIdFrontPhotoContent", fallback: "Make sure your ID is clear and readable and fits fully in the frame")
    /// Please take a photo of your ID’s front page
    internal static let takeIdFrontPhotoTitle = L10n.tr("Localizable", "AccountKYCLevelTwo.TakeIdFrontPhotoTitle", fallback: "Please take a photo of your ID’s front page")
    /// Make sure your passport is clear and readable and fits fully in the frame.
    internal static let takePhotoPassportContent = L10n.tr("Localizable", "AccountKYCLevelTwo.TakePhotoPassportContent", fallback: "Make sure your passport is clear and readable and fits fully in the frame.")
    /// Please take a photo of your passport.
    internal static let takePhotoPassportTitle = L10n.tr("Localizable", "AccountKYCLevelTwo.TakePhotoPassportTitle", fallback: "Please take a photo of your passport.")
<<<<<<< HEAD
    /// Take photos label in KYC2
=======
    /// Be prepared to take a selfie and photos of your ID
>>>>>>> mit
    internal static let takePhotos = L10n.tr("Localizable", "AccountKYCLevelTwo.TakePhotos", fallback: "Be prepared to take a selfie and photos of your ID")
    /// Make sure your face is in the frame and it’s clearly visible.
    internal static let takeSelfieContent = L10n.tr("Localizable", "AccountKYCLevelTwo.TakeSelfieContent", fallback: "Make sure your face is in the frame and it’s clearly visible.")
    /// Please take a selfie
    internal static let takeSelfieTitle = L10n.tr("Localizable", "AccountKYCLevelTwo.TakeSelfieTitle", fallback: "Please take a selfie")
    /// If your personal information has changed, please first update Level 1 KYC and then continue with
    /// Level 2 KYC.
    internal static let updateLevelOne = L10n.tr("Localizable", "AccountKYCLevelTwo.updateLevelOne", fallback: "If your personal information has changed, please first update Level 1 KYC and then continue with\nLevel 2 KYC.")
<<<<<<< HEAD
    /// Uploading your photos label in KYC2 flow
    internal static let uploadingPhoto = L10n.tr("Localizable", "AccountKYCLevelTwo.UploadingPhoto", fallback: "Uploading your photos")
    /// Unavailable while KYC verification is pending.
    internal static let verificationPending = L10n.tr("Localizable", "AccountKYCLevelTwo.VerificationPending", fallback: "Unavailable while KYC verification is pending.")
    /// Verifying label on KYC2
=======
    /// Uploading your photos
    internal static let uploadingPhoto = L10n.tr("Localizable", "AccountKYCLevelTwo.UploadingPhoto", fallback: "Uploading your photos")
    /// Unavailable while KYC verification is pending.
    internal static let verificationPending = L10n.tr("Localizable", "AccountKYCLevelTwo.VerificationPending", fallback: "Unavailable while KYC verification is pending.")
    /// Verifying you
>>>>>>> mit
    internal static let verifying = L10n.tr("Localizable", "AccountKYCLevelTwo.Verifying", fallback: "Verifying you")
  }
  internal enum Alert {
    /// Account backed up with iCloud Keychain
    internal static let accountBackedUpiCloud = L10n.tr("Localizable", "Alert.AccountBackedUpiCloud", fallback: "Account backed up with iCloud Keychain")
    /// Account succesfully restored from Cloud backup
    internal static let accountRestorediCloud = L10n.tr("Localizable", "Alert.AccountRestorediCloud", fallback: "Account succesfully restored from Cloud backup")
    /// Error
    internal static let error = L10n.tr("Localizable", "Alert.error", fallback: "Error")
    /// Insufficient Ethereum Balance
    internal static let ethBalance = L10n.tr("Localizable", "Alert.ethBalance", fallback: "Insufficient Ethereum Balance")
    /// Hedera Account succesfully created.
    internal static let hederaAccount = L10n.tr("Localizable", "Alert.HederaAccount", fallback: "Hedera Account succesfully created.")
    /// No internet connection found. Check your connection and try again.
    internal static let noInternet = L10n.tr("Localizable", "Alert.noInternet", fallback: "No internet connection found. Check your connection and try again.")
    /// KYCCamera doesn't have permission to use the camera, please change privacy settings
    internal static let permissionCamera = L10n.tr("Localizable", "Alert.PermissionCamera", fallback: "KYCCamera doesn't have permission to use the camera, please change privacy settings")
    /// Something went wrong. Please try again.
    internal static let somethingWentWrong = L10n.tr("Localizable", "Alert.somethingWentWrong", fallback: "Something went wrong. Please try again.")
    /// Request timed out. Check your connection and try again.
    internal static let timedOut = L10n.tr("Localizable", "Alert.timedOut", fallback: "Request timed out. Check your connection and try again.")
    /// Unable to capture media
    internal static let unableCapture = L10n.tr("Localizable", "Alert.UnableCapture", fallback: "Unable to capture media")
    /// Warning
    internal static let warning = L10n.tr("Localizable", "Alert.warning", fallback: "Warning")
    internal enum CustomKeyboard {
      /// It looks like you are using a third-party keyboard, which can record what you type and steal your Recovery Phrase. Please switch to the default Android keyboard for extra protection.
      internal static let android = L10n.tr("Localizable", "Alert.customKeyboard.android", fallback: "It looks like you are using a third-party keyboard, which can record what you type and steal your Recovery Phrase. Please switch to the default Android keyboard for extra protection.")
    }
    internal enum Keystore {
      internal enum Generic {
        /// There is a problem with your Android OS keystore, please contact support@fabriik.com
        internal static let android = L10n.tr("Localizable", "Alert.keystore.generic.android", fallback: "There is a problem with your Android OS keystore, please contact support@fabriik.com")
      }
      internal enum Invalidated {
        /// Your Fabriik encrypted data was recently invalidated because your Android lock screen was disabled.
        internal static let android = L10n.tr("Localizable", "Alert.keystore.invalidated.android", fallback: "Your Fabriik encrypted data was recently invalidated because your Android lock screen was disabled.")
        internal enum Uninstall {
          /// We can't proceed because your screen lock settings have been changed (e.g. password was disabled, fingerprints were changed). For security purposes, Android has permanently locked your key store. Therefore, your Fabriik app data must be wiped by uninstalling.
          /// 
          /// Don’t worry, your funds are still secure! Reinstall the app and recover your wallet using your recovery phrase.
          internal static let android = L10n.tr("Localizable", "Alert.keystore.invalidated.uninstall.android", fallback: "We can't proceed because your screen lock settings have been changed (e.g. password was disabled, fingerprints were changed). For security purposes, Android has permanently locked your key store. Therefore, your Fabriik app data must be wiped by uninstalling.\n\nDon’t worry, your funds are still secure! Reinstall the app and recover your wallet using your recovery phrase.")
        }
        internal enum Wipe {
          /// We can't proceed because your screen lock settings have been changed (e.g. password was disabled, fingerprints were changed). For security purposes, Android has permanently locked your key store. Therefore, your Fabriik app data must be wiped.
          /// 
          /// Don’t worry, your funds are still secure! Recover your wallet using your recovery phrase.
          internal static let android = L10n.tr("Localizable", "Alert.keystore.invalidated.wipe.android", fallback: "We can't proceed because your screen lock settings have been changed (e.g. password was disabled, fingerprints were changed). For security purposes, Android has permanently locked your key store. Therefore, your Fabriik app data must be wiped.\n\nDon’t worry, your funds are still secure! Recover your wallet using your recovery phrase.")
        }
      }
      internal enum Title {
        /// Android Key Store Error
        internal static let android = L10n.tr("Localizable", "Alert.keystore.title.android", fallback: "Android Key Store Error")
      }
    }
  }
  internal enum Alerts {
    /// Addresses Copied
    internal static let copiedAddressesHeader = L10n.tr("Localizable", "Alerts.copiedAddressesHeader", fallback: "Addresses Copied")
    /// All wallet addresses successfully copied.
    internal static let copiedAddressesSubheader = L10n.tr("Localizable", "Alerts.copiedAddressesSubheader", fallback: "All wallet addresses successfully copied.")
    /// Recovery Key Set
    internal static let paperKeySet = L10n.tr("Localizable", "Alerts.paperKeySet", fallback: "Recovery Key Set")
    /// Awesome!
    internal static let paperKeySetSubheader = L10n.tr("Localizable", "Alerts.paperKeySetSubheader", fallback: "Awesome!")
    /// PIN Set
    internal static let pinSet = L10n.tr("Localizable", "Alerts.pinSet", fallback: "PIN Set")
    /// Send failed
    internal static let sendFailure = L10n.tr("Localizable", "Alerts.sendFailure", fallback: "Send failed")
    /// Send Confirmation
    internal static let sendSuccess = L10n.tr("Localizable", "Alerts.sendSuccess", fallback: "Send Confirmation")
    /// Money Sent!
    internal static let sendSuccessSubheader = L10n.tr("Localizable", "Alerts.sendSuccessSubheader", fallback: "Money Sent!")
    internal enum TouchIdSucceeded {
      /// Fingerprint recognized
      internal static let android = L10n.tr("Localizable", "Alerts.touchIdSucceeded.android", fallback: "Fingerprint recognized")
    }
  }
  internal enum Amount {
    /// The minimum required ammount is 10 XRP.
    internal static let minXRPAmount = L10n.tr("Localizable", "Amount.MinXRPAmount", fallback: "The minimum required ammount is 10 XRP.")
    /// XRP Balance
    internal static let rippleBalance = L10n.tr("Localizable", "Amount.RippleBalance", fallback: "XRP Balance")
    /// Ripple requires each wallet to have a minimum balance of 10 XRP, so the balance displayed here is always 10 XRP less than your actual balance.
    internal static let rippleBalanceText = L10n.tr("Localizable", "Amount.RippleBalanceText", fallback: "Ripple requires each wallet to have a minimum balance of 10 XRP, so the balance displayed here is always 10 XRP less than your actual balance.")
  }
  internal enum Android {
    /// Please enable storage permissions in your device settings: "Settings" > "Apps" > "Fabriik" > "Permissions".
    internal static let allowFileSystemAccess = L10n.tr("Localizable", "Android.allowFileSystemAccess", fallback: "Please enable storage permissions in your device settings: \"Settings\" > \"Apps\" > \"Fabriik\" > \"Permissions\".")
    /// We've detected an app that is incompatible with Fabriik running on your device. For security reasons, please disable any screen altering or light filtering apps to proceed.
    internal static let screenAlteringMessage = L10n.tr("Localizable", "Android.screenAlteringMessage", fallback: "We've detected an app that is incompatible with Fabriik running on your device. For security reasons, please disable any screen altering or light filtering apps to proceed.")
    /// Screen Altering App Detected
    internal static let screenAlteringTitle = L10n.tr("Localizable", "Android.screenAlteringTitle", fallback: "Screen Altering App Detected")
    internal enum Bch {
      internal enum Welcome {
        /// Any BCH in your wallet can be accessed through the home screen.
        internal static let message = L10n.tr("Localizable", "Android.BCH.welcome.message", fallback: "Any BCH in your wallet can be accessed through the home screen.")
      }
    }
  }
  internal enum ApiClient {
    /// JSON Serialization Error
    internal static let jsonError = L10n.tr("Localizable", "ApiClient.jsonError", fallback: "JSON Serialization Error")
    /// Wallet not ready
    internal static let notReady = L10n.tr("Localizable", "ApiClient.notReady", fallback: "Wallet not ready")
    /// Unable to retrieve API token
    internal static let tokenError = L10n.tr("Localizable", "ApiClient.tokenError", fallback: "Unable to retrieve API token")
  }
  internal enum Bch {
    /// Enter a destination BCH address below. All BCH in your wallet at the time of the fork (%1$@) will be sent.
    internal static func body(_ p1: Any) -> String {
      return L10n.tr("Localizable", "BCH.body", String(describing: p1), fallback: "Enter a destination BCH address below. All BCH in your wallet at the time of the fork (%1$@) will be sent.")
    }
    /// Confirm sending %1$@ to %2$@
    internal static func confirmationMessage(_ p1: Any, _ p2: Any) -> String {
      return L10n.tr("Localizable", "BCH.confirmationMessage", String(describing: p1), String(describing: p2), fallback: "Confirm sending %1$@ to %2$@")
    }
    /// Confirmation
    internal static let confirmationTitle = L10n.tr("Localizable", "BCH.confirmationTitle", fallback: "Confirmation")
    /// Your account does not contain any BCH, or you received BCH after the fork.
    internal static let genericError = L10n.tr("Localizable", "BCH.genericError", fallback: "Your account does not contain any BCH, or you received BCH after the fork.")
    /// Transaction ID copied
    internal static let hashCopiedMessage = L10n.tr("Localizable", "BCH.hashCopiedMessage", fallback: "Transaction ID copied")
    /// Please enter an address
    internal static let noAddressError = L10n.tr("Localizable", "BCH.noAddressError", fallback: "Please enter an address")
    /// Payment Protocol Requests are not supported for BCH transactions
    internal static let paymentProtocolError = L10n.tr("Localizable", "BCH.paymentProtocolError", fallback: "Payment Protocol Requests are not supported for BCH transactions")
    /// BCH was successfully sent.
    internal static let successMessage = L10n.tr("Localizable", "BCH.successMessage", fallback: "BCH was successfully sent.")
    /// Withdraw BCH
    internal static let title = L10n.tr("Localizable", "BCH.title", fallback: "Withdraw BCH")
    /// BCH Transaction ID
    internal static let txHashHeader = L10n.tr("Localizable", "BCH.txHashHeader", fallback: "BCH Transaction ID")
  }
  internal enum BitID {
    /// Approve
    internal static let approve = L10n.tr("Localizable", "BitID.approve", fallback: "Approve")
    /// %1$@ is requesting authentication using your bitcoin wallet
    internal static func authenticationRequest(_ p1: Any) -> String {
      return L10n.tr("Localizable", "BitID.authenticationRequest", String(describing: p1), fallback: "%1$@ is requesting authentication using your bitcoin wallet")
    }
    /// Deny
    internal static let deny = L10n.tr("Localizable", "BitID.deny", fallback: "Deny")
    /// Authentication Error
    internal static let error = L10n.tr("Localizable", "BitID.error", fallback: "Authentication Error")
    /// Please check with the service. You may need to try again.
    internal static let errorMessage = L10n.tr("Localizable", "BitID.errorMessage", fallback: "Please check with the service. You may need to try again.")
    /// Successfully Authenticated
    internal static let success = L10n.tr("Localizable", "BitID.success", fallback: "Successfully Authenticated")
    /// BitID Authentication Request
    internal static let title = L10n.tr("Localizable", "BitID.title", fallback: "BitID Authentication Request")
  }
  internal enum Button {
    /// Buy
    internal static let buy = L10n.tr("Localizable", "Button.buy", fallback: "Buy")
    /// Cancel
    internal static let cancel = L10n.tr("Localizable", "Button.cancel", fallback: "Cancel")
    /// Close
    internal static let close = L10n.tr("Localizable", "Button.close", fallback: "Close")
    /// Confirm
    internal static let confirm = L10n.tr("Localizable", "Button.confirm", fallback: "Confirm")
    /// Continue
    internal static let continueAction = L10n.tr("Localizable", "Button.continueAction", fallback: "Continue")
    /// Dismiss
    internal static let dismiss = L10n.tr("Localizable", "Button.dismiss", fallback: "Dismiss")
    /// Done
    internal static let done = L10n.tr("Localizable", "Button.done", fallback: "Done")
    /// Finish
    internal static let finish = L10n.tr("Localizable", "Button.Finish", fallback: "Finish")
    /// Go to dashboard
    internal static let goToDashboard = L10n.tr("Localizable", "Button.GoToDashboard", fallback: "Go to dashboard")
    /// Home
    internal static let home = L10n.tr("Localizable", "Button.Home", fallback: "Home")
    /// Ignore
    internal static let ignore = L10n.tr("Localizable", "Button.ignore", fallback: "Ignore")
    /// Map
    internal static let map = L10n.tr("Localizable", "Button.map", fallback: "Map")
    /// Maybe Later
    internal static let maybeLater = L10n.tr("Localizable", "Button.maybeLater", fallback: "Maybe Later")
    /// Menu
    internal static let menu = L10n.tr("Localizable", "Button.menu", fallback: "Menu")
    /// More info
    internal static let moreInfo = L10n.tr("Localizable", "Button.moreInfo", fallback: "More info")
    /// No
    internal static let no = L10n.tr("Localizable", "Button.no", fallback: "No")
    /// OK
    internal static let ok = L10n.tr("Localizable", "Button.ok", fallback: "OK")
    /// Open Settings
    internal static let openSettings = L10n.tr("Localizable", "Button.openSettings", fallback: "Open Settings")
    /// Profile
    internal static let profile = L10n.tr("Localizable", "Button.Profile", fallback: "Profile")
    /// Receive
    internal static let receive = L10n.tr("Localizable", "Button.receive", fallback: "Receive")
    /// Remove
    internal static let remove = L10n.tr("Localizable", "Button.remove", fallback: "Remove")
<<<<<<< HEAD
    /// Search button
=======
    /// Search
>>>>>>> mit
    internal static let search = L10n.tr("Localizable", "Button.search", fallback: "Search")
    /// Sell
    internal static let sell = L10n.tr("Localizable", "Button.sell", fallback: "Sell")
    /// Send
    internal static let send = L10n.tr("Localizable", "Button.send", fallback: "Send")
    /// Settings
    internal static let settings = L10n.tr("Localizable", "Button.settings", fallback: "Settings")
    /// Set Up
    internal static let setup = L10n.tr("Localizable", "Button.setup", fallback: "Set Up")
    /// Skip
    internal static let skip = L10n.tr("Localizable", "Button.skip", fallback: "Skip")
    /// Submit
    internal static let submit = L10n.tr("Localizable", "Button.submit", fallback: "Submit")
    /// Yes
    internal static let yes = L10n.tr("Localizable", "Button.yes", fallback: "Yes")
    internal enum ContactSupport {
      /// Contact Support
      internal static let android = L10n.tr("Localizable", "Button.contactSupport.android", fallback: "Contact Support")
    }
    internal enum SecuritySettings {
      /// Security Settings
      internal static let android = L10n.tr("Localizable", "Button.securitySettings.android", fallback: "Security Settings")
    }
    internal enum Uninstall {
      /// Uninstall
      internal static let android = L10n.tr("Localizable", "Button.uninstall.android", fallback: "Uninstall")
    }
    internal enum Wipe {
      /// Wipe
      internal static let android = L10n.tr("Localizable", "Button.wipe.android", fallback: "Wipe")
    }
  }
  internal enum Buy {
    /// 3D Secure
    internal static let _3DSecure = L10n.tr("Localizable", "Buy.3DSecure", fallback: "3D Secure")
    /// Add card
    internal static let addCard = L10n.tr("Localizable", "Buy.AddCard", fallback: "Add card")
    /// Add a debit or credit card
    internal static let addDebitCreditCard = L10n.tr("Localizable", "Buy.AddDebitCreditCard", fallback: "Add a debit or credit card")
    /// Address
    internal static let address = L10n.tr("Localizable", "Buy.Address", fallback: "Address")
    /// Billing address
    internal static let billingAddress = L10n.tr("Localizable", "Buy.BillingAddress", fallback: "Billing address")
    /// Currently, minimum limit for buy is $%@ USD and maximum limit is $%@ USD/day.
    internal static func buyLimits(_ p1: Any, _ p2: Any) -> String {
      return L10n.tr("Localizable", "Buy.BuyLimits", String(describing: p1), String(describing: p2), fallback: "Currently, minimum limit for buy is $%@ USD and maximum limit is $%@ USD/day.")
    }
    /// Card
    internal static let card = L10n.tr("Localizable", "Buy.Card", fallback: "Card")
    /// CVV
    internal static let cardCVV = L10n.tr("Localizable", "Buy.CardCVV", fallback: "CVV")
    /// This fee is charged to cover costs associated with payment processing.
    internal static let cardFee = L10n.tr("Localizable", "Buy.CardFee", fallback: "This fee is charged to cover costs associated with payment processing.")
    /// Card number
    internal static let cardNumber = L10n.tr("Localizable", "Buy.CardNumber", fallback: "Card number")
    /// XXXX XXXX XXXX XXXX
    internal static let cardNumberHint = L10n.tr("Localizable", "Buy.CardNumberHint", fallback: "XXXX XXXX XXXX XXXX")
    /// Card removal failed. Please try again.
    internal static let cardRemovalFailed = L10n.tr("Localizable", "Buy.CardRemovalFailed", fallback: "Card removal failed. Please try again.")
    /// Card removed
    internal static let cardRemoved = L10n.tr("Localizable", "Buy.CardRemoved", fallback: "Card removed")
    /// City
    internal static let city = L10n.tr("Localizable", "Buy.City", fallback: "City")
    /// Please confirm your CVV
    internal static let confirmCVV = L10n.tr("Localizable", "Buy.ConfirmCVV", fallback: "Please confirm your CVV")
    /// Country
    internal static let country = L10n.tr("Localizable", "Buy.Country", fallback: "Country")
    /// XXX
    internal static let cvvHint = L10n.tr("Localizable", "Buy.CvvHint", fallback: "XXX")
    /// Purchase details
    internal static let details = L10n.tr("Localizable", "Buy.Details", fallback: "Purchase details")
    /// There was an error while processing your payment
    internal static let errorProcessingPayment = L10n.tr("Localizable", "Buy.ErrorProcessingPayment", fallback: "There was an error while processing your payment")
    /// Expiration date
    internal static let expirationDate = L10n.tr("Localizable", "Buy.ExpirationDate", fallback: "Expiration date")
    /// Please contact your card issuer/bank or try again with a different payment method.
    internal static let failureTransactionMessage = L10n.tr("Localizable", "Buy.FailureTransactionMessage", fallback: "Please contact your card issuer/bank or try again with a different payment method.")
    /// First Name
    internal static let firstName = L10n.tr("Localizable", "Buy.FirstName", fallback: "First Name")
    /// Entered expiration date is not valid!
    internal static let invalidExpirationDate = L10n.tr("Localizable", "Buy.InvalidExpirationDate", fallback: "Entered expiration date is not valid!")
<<<<<<< HEAD
    /// Last Name label in billing address view on buy flow
=======
    /// Last Name
>>>>>>> mit
    internal static let lastName = L10n.tr("Localizable", "Buy.LastName", fallback: "Last Name")
    /// MM/YY
    internal static let monthYear = L10n.tr("Localizable", "Buy.MonthYear", fallback: "MM/YY")
    /// Network fee prices vary depending on the blockchain in which you are receiving your assets. This is an external fee to cover mining and transaction costs.
    internal static let networkFeeMessage = L10n.tr("Localizable", "Buy.NetworkFeeMessage", fallback: "Network fee prices vary depending on the blockchain in which you are receiving your assets. This is an external fee to cover mining and transaction costs.")
    /// Network fees
    internal static let networkFees = L10n.tr("Localizable", "Buy.NetworkFees", fallback: "Network fees")
    /// Order preview
    internal static let orderPreview = L10n.tr("Localizable", "Buy.OrderPreview", fallback: "Order preview")
    /// Payment failed
    internal static let paymentFailed = L10n.tr("Localizable", "Buy.PaymentFailed", fallback: "Payment failed")
    /// Payment method
    internal static let paymentMethod = L10n.tr("Localizable", "Buy.PaymentMethod", fallback: "Payment method")
    /// Pay with
    internal static let payWith = L10n.tr("Localizable", "Buy.PayWith", fallback: "Pay with")
    /// Processing payment
    internal static let processingPayment = L10n.tr("Localizable", "Buy.ProcessingPayment", fallback: "Processing payment")
<<<<<<< HEAD
    /// Purchase success text in purchase details screen
=======
    /// This purchase will appear as ‘Fabriik Wallet’ on your bank statement.
>>>>>>> mit
    internal static let purchaseSuccessText = L10n.tr("Localizable", "Buy.PurchaseSuccessText", fallback: "This purchase will appear as ‘Fabriik Wallet’ on your bank statement.")
    /// Your assets are on the way!
    internal static let purchaseSuccessTitle = L10n.tr("Localizable", "Buy.PurchaseSuccessTitle", fallback: "Your assets are on the way!")
    /// Are you sure you want to remove card ending in
    internal static let removeCard = L10n.tr("Localizable", "Buy.RemoveCard", fallback: "Are you sure you want to remove card ending in")
    /// You will no longer be able to use it to buy assets.
    internal static let removeCardOption = L10n.tr("Localizable", "Buy.RemoveCardOption", fallback: "You will no longer be able to use it to buy assets.")
    /// Remove payment method
    internal static let removePaymentMethod = L10n.tr("Localizable", "Buy.RemovePaymentMethod", fallback: "Remove payment method")
    /// Security code (CVV)
    internal static let securityCode = L10n.tr("Localizable", "Buy.SecurityCode", fallback: "Security code (CVV)")
    /// Please enter the 3 digit CVV number as it appears on the back of your card
    internal static let securityCodePopup = L10n.tr("Localizable", "Buy.SecurityCodePopup", fallback: "Please enter the 3 digit CVV number as it appears on the back of your card")
    /// Select payment method
    internal static let selectPayment = L10n.tr("Localizable", "Buy.SelectPayment", fallback: "Select payment method")
<<<<<<< HEAD
    /// Select a payment method button title in buy flow
    internal static let selectPaymentMethod = L10n.tr("Localizable", "Buy.SelectPaymentMethod", fallback: "Select a payment method")
    /// State/Province label in billing address view on buy flow
=======
    /// Select a payment method
    internal static let selectPaymentMethod = L10n.tr("Localizable", "Buy.SelectPaymentMethod", fallback: "Select a payment method")
    /// State/Province
>>>>>>> mit
    internal static let stateProvince = L10n.tr("Localizable", "Buy.StateProvince", fallback: "State/Province")
    /// By placing this order you agree to our
    internal static let terms = L10n.tr("Localizable", "Buy.Terms", fallback: "By placing this order you agree to our")
    /// Try a different payment method
    internal static let tryAnotherPayment = L10n.tr("Localizable", "Buy.TryAnotherPayment", fallback: "Try a different payment method")
    /// %s Transaction ID
    internal static func txHashHeader(_ p1: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "Buy.txHashHeader", p1, fallback: "%s Transaction ID")
    }
<<<<<<< HEAD
    /// Your order label in buy flow
=======
    /// Your order:
>>>>>>> mit
    internal static let yourOrder = L10n.tr("Localizable", "Buy.YourOrder", fallback: "Your order:")
    /// ZIP/Postal Code
    internal static let zipPostalCode = L10n.tr("Localizable", "Buy.ZIPPostalCode", fallback: "ZIP/Postal Code")
    internal enum BuyLimits {
      /// Currently, minimum limit for buy is $30.00 USD and maximum limit is $500.00 USD per day.
      internal static let android = L10n.tr("Localizable", "Buy.BuyLimits.android", fallback: "Currently, minimum limit for buy is $30.00 USD and maximum limit is $500.00 USD per day.")
    }
    internal enum RemoveCard {
      /// Are you sure you want to remove card ending in %s?
      internal static func android(_ p1: UnsafePointer<CChar>) -> String {
        return L10n.tr("Localizable", "Buy.RemoveCard.android", p1, fallback: "Are you sure you want to remove card ending in %s?")
      }
    }
    internal enum Terms {
      /// By placing this order you agree to our %s
      internal static func android(_ p1: UnsafePointer<CChar>) -> String {
        return L10n.tr("Localizable", "Buy.Terms.android", p1, fallback: "By placing this order you agree to our %s")
      }
    }
  }
  internal enum CameraPlugin {
    /// Center your ID in the box
    internal static let centerInstruction = L10n.tr("Localizable", "CameraPlugin.centerInstruction", fallback: "Center your ID in the box")
  }
  internal enum CashToken {
    /// Please send bitcoin to this address to withdraw at the ATM. Scan QR code or copy and paste to send bitcoin. Note that it may take a few minutes for the transfer to be confirmed.
    internal static let actionInstructions = L10n.tr("Localizable", "CashToken.actionInstructions", fallback: "Please send bitcoin to this address to withdraw at the ATM. Scan QR code or copy and paste to send bitcoin. Note that it may take a few minutes for the transfer to be confirmed.")
    /// Amount (BTC)
    internal static let amountBTC = L10n.tr("Localizable", "CashToken.amountBTC", fallback: "Amount (BTC)")
    /// Amount (USD)
    internal static let amountUSD = L10n.tr("Localizable", "CashToken.amountUSD", fallback: "Amount (USD)")
    /// Awaiting Funds
    internal static let awaitingFunds = L10n.tr("Localizable", "CashToken.awaitingFunds", fallback: "Awaiting Funds")
    /// Withdrawl Status
    internal static let label = L10n.tr("Localizable", "CashToken.label", fallback: "Withdrawl Status")
    /// Location
    internal static let location = L10n.tr("Localizable", "CashToken.location", fallback: "Location")
    /// Please Verify
    internal static let pleaseVerify = L10n.tr("Localizable", "CashToken.pleaseVerify", fallback: "Please Verify")
  }
  internal enum CloudBackup {
    /// Backup Erased
    internal static let backupDeleted = L10n.tr("Localizable", "CloudBackup.backupDeleted", fallback: "Backup Erased")
    /// Your iCloud backup has been erased after too many failed PIN attempts. The app will now restart.
    internal static let backupDeletedMessage = L10n.tr("Localizable", "CloudBackup.backupDeletedMessage", fallback: "Your iCloud backup has been erased after too many failed PIN attempts. The app will now restart.")
    /// iCloud Backup
    internal static let backupMenuTitle = L10n.tr("Localizable", "CloudBackup.backupMenuTitle", fallback: "iCloud Backup")
    /// Create new wallet
    internal static let createButton = L10n.tr("Localizable", "CloudBackup.createButton", fallback: "Create new wallet")
    /// A previously backed up wallet has been detected. Using this backup is recomended. Are you sure you want to proceeed with creating a new wallet?
    internal static let createWarning = L10n.tr("Localizable", "CloudBackup.createWarning", fallback: "A previously backed up wallet has been detected. Using this backup is recomended. Are you sure you want to proceeed with creating a new wallet?")
    /// iCloud Keychain must be turned on for this feature to work.
    internal static let enableBody1 = L10n.tr("Localizable", "CloudBackup.enableBody1", fallback: "iCloud Keychain must be turned on for this feature to work.")
    /// It should look like the following:
    internal static let enableBody2 = L10n.tr("Localizable", "CloudBackup.enableBody2", fallback: "It should look like the following:")
    /// I have turned on iCloud Keychain
    internal static let enableButton = L10n.tr("Localizable", "CloudBackup.enableButton", fallback: "I have turned on iCloud Keychain")
    /// Enable Keychain
    internal static let enableTitle = L10n.tr("Localizable", "CloudBackup.enableTitle", fallback: "Enable Keychain")
    /// Enter pin to encrypt backup
    internal static let encryptBackupMessage = L10n.tr("Localizable", "CloudBackup.encryptBackupMessage", fallback: "Enter pin to encrypt backup")
    /// Please note, iCloud backup is only as secure as your iCloud account. We still recommend writing down your recovery phrase in the following step and keeping it secure. The recovery phrase is the only way to recover your wallet if you can no longer access iCloud.
    internal static let mainBody = L10n.tr("Localizable", "CloudBackup.mainBody", fallback: "Please note, iCloud backup is only as secure as your iCloud account. We still recommend writing down your recovery phrase in the following step and keeping it secure. The recovery phrase is the only way to recover your wallet if you can no longer access iCloud.")
    /// iCloud Recovery Backup
    internal static let mainTitle = L10n.tr("Localizable", "CloudBackup.mainTitle", fallback: "iCloud Recovery Backup")
    /// iCloud Keychain must be turned on in the iOS Settings app for this feature to work
    internal static let mainWarning = L10n.tr("Localizable", "CloudBackup.mainWarning", fallback: "iCloud Keychain must be turned on in the iOS Settings app for this feature to work")
    /// Are you sure you want to disable iCloud Backup? This will delete your backup from all devices.
    internal static let mainWarningConfirmation = L10n.tr("Localizable", "CloudBackup.mainWarningConfirmation", fallback: "Are you sure you want to disable iCloud Backup? This will delete your backup from all devices.")
    /// Attempts remaining before erasing backup: %1$@
    internal static func pinAttempts(_ p1: Any) -> String {
      return L10n.tr("Localizable", "CloudBackup.pinAttempts", String(describing: p1), fallback: "Attempts remaining before erasing backup: %1$@")
    }
    /// Restore from Recovery Phrase
    internal static let recoverButton = L10n.tr("Localizable", "CloudBackup.recoverButton", fallback: "Restore from Recovery Phrase")
    /// Enter PIN to unlock iCloud backup
    internal static let recoverHeader = L10n.tr("Localizable", "CloudBackup.recoverHeader", fallback: "Enter PIN to unlock iCloud backup")
    /// A previously backed up wallet has been detected. Using this backup is recommended. Are you sure you want to proceeed with restoring from a recovery phrase?
    internal static let recoverWarning = L10n.tr("Localizable", "CloudBackup.recoverWarning", fallback: "A previously backed up wallet has been detected. Using this backup is recommended. Are you sure you want to proceeed with restoring from a recovery phrase?")
    /// Restore from iCloud Backup
    internal static let restoreButton = L10n.tr("Localizable", "CloudBackup.restoreButton", fallback: "Restore from iCloud Backup")
    /// Choose Backup
    internal static let selectTitle = L10n.tr("Localizable", "CloudBackup.selectTitle", fallback: "Choose Backup")
    /// Launch the Settings app.
    internal static let step1 = L10n.tr("Localizable", "CloudBackup.step1", fallback: "Launch the Settings app.")
    /// Tap your Apple ID name.
    internal static let step2 = L10n.tr("Localizable", "CloudBackup.step2", fallback: "Tap your Apple ID name.")
    /// Tap iCloud.
    internal static let step3 = L10n.tr("Localizable", "CloudBackup.step3", fallback: "Tap iCloud.")
    /// Verify that iCloud Keychain is ON
    internal static let step4 = L10n.tr("Localizable", "CloudBackup.step4", fallback: "Verify that iCloud Keychain is ON")
    /// I understand that this feature will not work unless iCloud Keychain is enabled.
    internal static let understandText = L10n.tr("Localizable", "CloudBackup.understandText", fallback: "I understand that this feature will not work unless iCloud Keychain is enabled.")
    /// Your iCloud backup will be erased after %1$@ more incorrect PIN attempts.
    internal static func warningBody(_ p1: Any) -> String {
      return L10n.tr("Localizable", "CloudBackup.warningBody", String(describing: p1), fallback: "Your iCloud backup will be erased after %1$@ more incorrect PIN attempts.")
    }
  }
  internal enum ConfirmGift {
    /// Paper Wallet Amount
    internal static let paperWalletAmount = L10n.tr("Localizable", "ConfirmGift.paperWalletAmount", fallback: "Paper Wallet Amount")
    /// Validating this paper wallet on the network may take up to 60 minutes
    internal static let processingTime = L10n.tr("Localizable", "ConfirmGift.processingTime", fallback: "Validating this paper wallet on the network may take up to 60 minutes")
  }
  internal enum ConfirmPaperPhrase {
    /// The words entered do not match your recovery phrase. Please try again.
    internal static let error = L10n.tr("Localizable", "ConfirmPaperPhrase.error", fallback: "The words entered do not match your recovery phrase. Please try again.")
    /// To make sure everything was written down correctly, please enter the following words from your recovery phrase.
    internal static let label = L10n.tr("Localizable", "ConfirmPaperPhrase.label", fallback: "To make sure everything was written down correctly, please enter the following words from your recovery phrase.")
    /// Word #%1$@
    internal static func word(_ p1: Any) -> String {
      return L10n.tr("Localizable", "ConfirmPaperPhrase.word", String(describing: p1), fallback: "Word #%1$@")
    }
  }
  internal enum Confirmation {
    /// Amount to Send:
    internal static let amountLabel = L10n.tr("Localizable", "Confirmation.amountLabel", fallback: "Amount to Send:")
    /// Destination Tag
    internal static let destinationTag = L10n.tr("Localizable", "Confirmation.destinationTag", fallback: "Destination Tag")
    /// (empty)
    internal static let destinationTagEmptyHint = L10n.tr("Localizable", "Confirmation.destinationTag_EmptyHint", fallback: "(empty)")
    /// Network Fee:
    internal static let feeLabel = L10n.tr("Localizable", "Confirmation.feeLabel", fallback: "Network Fee:")
    /// Network Fee (ETH):
    internal static let feeLabelETH = L10n.tr("Localizable", "Confirmation.feeLabelETH", fallback: "Network Fee (ETH):")
    /// Hedera Memo
    internal static let hederaMemo = L10n.tr("Localizable", "Confirmation.hederaMemo", fallback: "Hedera Memo")
    /// Processing time: This transaction is predicted to complete in %1$@.
    internal static func processingTime(_ p1: Any) -> String {
      return L10n.tr("Localizable", "Confirmation.processingTime", String(describing: p1), fallback: "Processing time: This transaction is predicted to complete in %1$@.")
    }
    /// Send
    internal static let send = L10n.tr("Localizable", "Confirmation.send", fallback: "Send")
    /// Confirmation
    internal static let title = L10n.tr("Localizable", "Confirmation.title", fallback: "Confirmation")
    /// To
    internal static let to = L10n.tr("Localizable", "Confirmation.to", fallback: "To")
    /// Total Cost:
    internal static let totalLabel = L10n.tr("Localizable", "Confirmation.totalLabel", fallback: "Total Cost:")
    /// Validator Address
    internal static let validatorAddress = L10n.tr("Localizable", "Confirmation.ValidatorAddress", fallback: "Validator Address")
  }
  internal enum CreateGift {
    /// Choose amount ($USD)
    internal static let amountLabel = L10n.tr("Localizable", "CreateGift.amountLabel", fallback: "Choose amount ($USD)")
    /// Create
    internal static let create = L10n.tr("Localizable", "CreateGift.create", fallback: "Create")
    /// Custom amount ($500 max)
    internal static let customAmountHint = L10n.tr("Localizable", "CreateGift.customAmountHint", fallback: "Custom amount ($500 max)")
    /// We'll create what's called a
    internal static let description = L10n.tr("Localizable", "CreateGift.description", fallback: "We'll create what's called a")
    /// You must select a gift amount.
    internal static let inputAmountError = L10n.tr("Localizable", "CreateGift.inputAmountError", fallback: "You must select a gift amount.")
    /// You must enter the name of the recipient.
    internal static let inputRecipientNameError = L10n.tr("Localizable", "CreateGift.inputRecipientNameError", fallback: "You must enter the name of the recipient.")
    /// You have insufficient funds to send a gift.
    internal static let insufficientBalanceError = L10n.tr("Localizable", "CreateGift.insufficientBalanceError", fallback: "You have insufficient funds to send a gift.")
    /// You have insufficient funds to send a gift of this amount.
    internal static let insufficientBalanceForAmountError = L10n.tr("Localizable", "CreateGift.insufficientBalanceForAmountError", fallback: "You have insufficient funds to send a gift of this amount.")
    /// Recipient's name
    internal static let recipientName = L10n.tr("Localizable", "CreateGift.recipientName", fallback: "Recipient's name")
    /// A server error occurred. Please try again later.
    internal static let serverError = L10n.tr("Localizable", "CreateGift.serverError", fallback: "A server error occurred. Please try again later.")
    /// Send bitcoin to someone even if they don't have a wallet.
    internal static let subtitle = L10n.tr("Localizable", "CreateGift.subtitle", fallback: "Send bitcoin to someone even if they don't have a wallet.")
    /// Give the Gift of Bitcoin
    internal static let title = L10n.tr("Localizable", "CreateGift.title", fallback: "Give the Gift of Bitcoin")
    /// An unexpected error occurred. Please contact support.
    internal static let unexpectedError = L10n.tr("Localizable", "CreateGift.unexpectedError", fallback: "An unexpected error occurred. Please contact support.")
  }
  internal enum Crowdsale {
    /// Agree
    internal static let agree = L10n.tr("Localizable", "Crowdsale.agree", fallback: "Agree")
    /// Buy Tokens
    internal static let buyButton = L10n.tr("Localizable", "Crowdsale.buyButton", fallback: "Buy Tokens")
    /// Decline
    internal static let decline = L10n.tr("Localizable", "Crowdsale.decline", fallback: "Decline")
    /// Resume Verification
    internal static let resume = L10n.tr("Localizable", "Crowdsale.resume", fallback: "Resume Verification")
    /// Retry
    internal static let retry = L10n.tr("Localizable", "Crowdsale.retry", fallback: "Retry")
  }
  internal enum DefaultCurrency {
    /// Bitcoin Display Unit
    internal static let bitcoinLabel = L10n.tr("Localizable", "DefaultCurrency.bitcoinLabel", fallback: "Bitcoin Display Unit")
    /// Exchange Rate
    internal static let rateLabel = L10n.tr("Localizable", "DefaultCurrency.rateLabel", fallback: "Exchange Rate")
  }
  internal enum Disabled {
    /// Wallet disabled
    internal static let title = L10n.tr("Localizable", "Disabled.title", fallback: "Wallet disabled")
  }
  internal enum Eme {
    internal enum Permissions {
      /// Request %1$@ account information
      internal static func accountRequest(_ p1: Any) -> String {
        return L10n.tr("Localizable", "EME.permissions.accountRequest", String(describing: p1), fallback: "Request %1$@ account information")
      }
      /// Request %1$@ smart contract call
      internal static func callRequest(_ p1: Any) -> String {
        return L10n.tr("Localizable", "EME.permissions.callRequest", String(describing: p1), fallback: "Request %1$@ smart contract call")
      }
      /// Request %1$@ payment
      internal static func paymentRequest(_ p1: Any) -> String {
        return L10n.tr("Localizable", "EME.permissions.paymentRequest", String(describing: p1), fallback: "Request %1$@ payment")
      }
    }
  }
  internal enum Email {
    /// %1$s Address
    internal static func addressSubject(_ p1: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "Email.address_subject", p1, fallback: "%1$s Address")
    }
  }
  internal enum ErrorMessages {
    /// You cannot purchase assets without completing Level 2 account verification. Upgrade your limits on the Profile screen.
    internal static let accessDenied = L10n.tr("Localizable", "ErrorMessages.accessDenied", fallback: "You cannot purchase assets without completing Level 2 account verification. Upgrade your limits on the Profile screen.")
<<<<<<< HEAD
    /// The currency amount is to high for exchange. Accepts 2 parameters:, - maxiumum amount, - currency code
=======
    /// The amount is higher than your daily limit of %s %s. Please enter a lower amount.
>>>>>>> mit
    internal static func amountTooHigh(_ p1: UnsafePointer<CChar>, _ p2: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "ErrorMessages.AmountTooHigh", p1, p2, fallback: "The amount is higher than your daily limit of %s %s. Please enter a lower amount.")
    }
    /// The amount is lower than the minimum of %s %s. Please enter a higher amount.
    internal static func amountTooLow(_ p1: UnsafePointer<CChar>, _ p2: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "ErrorMessages.amountTooLow", p1, p2, fallback: "The amount is lower than the minimum of %s %s. Please enter a higher amount.")
    }
    /// Card authorization failed. Please contact your credit card issuer/bank or try another card.
    internal static let authorizationFailed = L10n.tr("Localizable", "ErrorMessages.authorizationFailed", fallback: "Card authorization failed. Please contact your credit card issuer/bank or try another card.")
    /// You need %s %s in your wallet to cover network fees. Please add more %s to your wallet. 
    internal static func balanceTooLow(_ p1: UnsafePointer<CChar>, _ p2: UnsafePointer<CChar>, _ p3: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "ErrorMessages.balanceTooLow", p1, p2, p3, fallback: "You need %s %s in your wallet to cover network fees. Please add more %s to your wallet. ")
    }
    /// Please, check your internet connection and try again later.
    internal static let checkInternet = L10n.tr("Localizable", "ErrorMessages.CheckInternet", fallback: "Please, check your internet connection and try again later.")
    /// This device isn't configured to send email with the iOS mail app.
    internal static let emailUnavailableMessage = L10n.tr("Localizable", "ErrorMessages.emailUnavailableMessage", fallback: "This device isn't configured to send email with the iOS mail app.")
    /// Email Unavailable
    internal static let emailUnavailableTitle = L10n.tr("Localizable", "ErrorMessages.emailUnavailableTitle", fallback: "Email Unavailable")
    /// Insufficient Ethereum balance in your wallet to transfer this type of token.
    internal static let ethBalanceLow = L10n.tr("Localizable", "ErrorMessages.ethBalanceLow", fallback: "Insufficient Ethereum balance in your wallet to transfer this type of token.")
    /// Swap failed. Reason: %s.
    internal static func exchangeFailed(_ p1: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "ErrorMessages.exchangeFailed", p1, fallback: "Swap failed. Reason: %s.")
    }
    /// We are currently having issues making a swap between this pair of coins. Please try again later.
    internal static let exchangeQuoteFailed = L10n.tr("Localizable", "ErrorMessages.ExchangeQuoteFailed", fallback: "We are currently having issues making a swap between this pair of coins. Please try again later.")
    /// This device isn't configured to send messages.
    internal static let messagingUnavailableMessage = L10n.tr("Localizable", "ErrorMessages.messagingUnavailableMessage", fallback: "This device isn't configured to send messages.")
    /// Messaging Unavailable
    internal static let messagingUnavailableTitle = L10n.tr("Localizable", "ErrorMessages.messagingUnavailableTitle", fallback: "Messaging Unavailable")
    /// This swap doesn't cover the included network fee. Please add more funds to your wallet or change the amount you're swapping.
    internal static let networkFee = L10n.tr("Localizable", "ErrorMessages.networkFee", fallback: "This swap doesn't cover the included network fee. Please add more funds to your wallet or change the amount you're swapping.")
    /// We are having temporary network issues. Please try again later.
    internal static let networkIssues = L10n.tr("Localizable", "ErrorMessages.NetworkIssues", fallback: "We are having temporary network issues. Please try again later.")
    /// No selected currencies.
    internal static let noCurrencies = L10n.tr("Localizable", "ErrorMessages.NoCurrencies", fallback: "No selected currencies.")
    /// Failed to fetch network fees. Please try again later.
    internal static let noFees = L10n.tr("Localizable", "ErrorMessages.noFees", fallback: "Failed to fetch network fees. Please try again later.")
    /// No quote for currency pair %s-%s.
    internal static func noQuoteForPair(_ p1: UnsafePointer<CChar>, _ p2: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "ErrorMessages.noQuoteForPair", p1, p2, fallback: "No quote for currency pair %s-%s.")
    }
    /// %s is an ERC-20 token on the Ethereum blockchain and requires ETH network fees. Please add ETH to your wallet.
    internal static func notEnoughEthForFee(_ p1: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "ErrorMessages.notEnoughEthForFee", p1, fallback: "%s is an ERC-20 token on the Ethereum blockchain and requires ETH network fees. Please add ETH to your wallet.")
    }
    /// The amount is higher than your daily limit of %s USD. Please upgrade your account or enter a lower amount.
    internal static func overDailyLimit(_ p1: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "ErrorMessages.overDailyLimit", p1, fallback: "The amount is higher than your daily limit of %s USD. Please upgrade your account or enter a lower amount.")
    }
    /// Over exchange limit.
    internal static let overExchangeLimit = L10n.tr("Localizable", "ErrorMessages.overExchangeLimit", fallback: "Over exchange limit.")
    /// The amount is higher than your lifetime limit of %s USD. Please upgrade your account or enter a lower amount.
    internal static func overLifetimeLimit(_ p1: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "ErrorMessages.overLifetimeLimit", p1, fallback: "The amount is higher than your lifetime limit of %s USD. Please upgrade your account or enter a lower amount.")
    }
    /// The amount is higher than your daily limit of %s USD. Please enter a lower amount.
    internal static func overLifetimeLimitLevel2(_ p1: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "ErrorMessages.overLifetimeLimitLevel2", p1, fallback: "The amount is higher than your daily limit of %s USD. Please enter a lower amount.")
    }
    /// A maximum of one swap can be active for a currency at a time.
    internal static let pendingExchange = L10n.tr("Localizable", "ErrorMessages.pendingExchange", fallback: "A maximum of one swap can be active for a currency at a time.")
    /// PIN Authentication failed.
    internal static let pinConfirmationFailed = L10n.tr("Localizable", "ErrorMessages.pinConfirmationFailed", fallback: "PIN Authentication failed.")
    /// In order to succesfully perform a swap, make sure you have two or more of our supported swap assets (BSV, BTC, ETH, BCH, SHIB, USDT) activated and funded within your wallet.
    internal static let selectAssets = L10n.tr("Localizable", "ErrorMessages.selectAssets", fallback: "In order to succesfully perform a swap, make sure you have two or more of our supported swap assets (BSV, BTC, ETH, BCH, SHIB, USDT) activated and funded within your wallet.")
    /// Oops! Something went wrong, please try again later.
    internal static let somethingWentWrong = L10n.tr("Localizable", "ErrorMessages.SomethingWentWrong", fallback: "Oops! Something went wrong, please try again later.")
    /// The amount is higher than the swap maximum of %s %s.
    internal static func swapAmountTooHigh(_ p1: UnsafePointer<CChar>, _ p2: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "ErrorMessages.swapAmountTooHigh", p1, p2, fallback: "The amount is higher than the swap maximum of %s %s.")
    }
    /// We are having temporary issues connecting to our network. Please try again later.
    internal static let temporaryNetworkIssues = L10n.tr("Localizable", "ErrorMessages.temporaryNetworkIssues", fallback: "We are having temporary issues connecting to our network. Please try again later.")
<<<<<<< HEAD
    /// Unknown error text message
=======
    /// Unknown error.
>>>>>>> mit
    internal static let unknownError = L10n.tr("Localizable", "ErrorMessages.UnknownError", fallback: "Unknown error.")
    internal enum Kyc {
      /// You must be at least 18 years old to complete Level 1 and 2 verification.
      internal static let underage = L10n.tr("Localizable", "ErrorMessages.Kyc.Underage", fallback: "You must be at least 18 years old to complete Level 1 and 2 verification.")
    }
    internal enum LoopingLockScreen {
      /// Fabriik can not be authenticated due to a bug in your version of Android. [Please tap here for more information.]
      internal static let android = L10n.tr("Localizable", "ErrorMessages.loopingLockScreen.android", fallback: "Fabriik can not be authenticated due to a bug in your version of Android. [Please tap here for more information.]")
    }
    internal enum TouchIdFailed {
      /// Fingerprint not recognized. Please try again.
      internal static let android = L10n.tr("Localizable", "ErrorMessages.touchIdFailed.android", fallback: "Fingerprint not recognized. Please try again.")
    }
  }
  internal enum ExportConfirmation {
    /// Cancel
    internal static let cancel = L10n.tr("Localizable", "ExportConfirmation.cancel", fallback: "Cancel")
    /// Continue
    internal static let continueAction = L10n.tr("Localizable", "ExportConfirmation.continueAction", fallback: "Continue")
    /// This will generate a CSV file including all completed transactions from all enabled wallets.
    internal static let message = L10n.tr("Localizable", "ExportConfirmation.message", fallback: "This will generate a CSV file including all completed transactions from all enabled wallets.")
    /// Export transactions?
    internal static let title = L10n.tr("Localizable", "ExportConfirmation.title", fallback: "Export transactions?")
  }
  internal enum ExportTransfers {
    /// This will generate a CSV file including all completed transactions from all enabled wallets.
    internal static let body = L10n.tr("Localizable", "ExportTransfers.body", fallback: "This will generate a CSV file including all completed transactions from all enabled wallets.")
    /// Export Transfers
    internal static let confirmExport = L10n.tr("Localizable", "ExportTransfers.confirmExport", fallback: "Export Transfers")
    /// Failed to export CSV file, please try again.
    internal static let exportFailedBody = L10n.tr("Localizable", "ExportTransfers.exportFailedBody", fallback: "Failed to export CSV file, please try again.")
    /// Export Failed
    internal static let exportFailedTitle = L10n.tr("Localizable", "ExportTransfers.exportFailedTitle", fallback: "Export Failed")
    /// Export transactions?
    internal static let header = L10n.tr("Localizable", "ExportTransfers.header", fallback: "Export transactions?")
  }
  internal enum FaceIDSettings {
    /// You can customize your Face ID spending limit from the %1$@.
    internal static func customizeText(_ p1: Any) -> String {
      return L10n.tr("Localizable", "FaceIDSettings.customizeText", String(describing: p1), fallback: "You can customize your Face ID spending limit from the %1$@.")
    }
    /// Use Face ID to unlock your Fabriik app and send money.
    internal static let explanatoryText = L10n.tr("Localizable", "FaceIDSettings.explanatoryText", fallback: "Use Face ID to unlock your Fabriik app and send money.")
    /// Use your face to unlock your Fabriik and send money up to a set limit.
    internal static let label = L10n.tr("Localizable", "FaceIDSettings.label", fallback: "Use your face to unlock your Fabriik and send money up to a set limit.")
    /// Face ID Spending Limit Screen
    internal static let linkText = L10n.tr("Localizable", "FaceIDSettings.linkText", fallback: "Face ID Spending Limit Screen")
    /// Enable Face ID for Fabriik
    internal static let switchLabel = L10n.tr("Localizable", "FaceIDSettings.switchLabel", fallback: "Enable Face ID for Fabriik")
    /// Face ID
    internal static let title = L10n.tr("Localizable", "FaceIDSettings.title", fallback: "Face ID")
    /// Enable Face ID to send money
    internal static let transactionsTitleText = L10n.tr("Localizable", "FaceIDSettings.transactionsTitleText", fallback: "Enable Face ID to send money")
    /// You have not set up Face ID on this device. Go to Settings->Face ID & Passcode to set it up now.
    internal static let unavailableAlertMessage = L10n.tr("Localizable", "FaceIDSettings.unavailableAlertMessage", fallback: "You have not set up Face ID on this device. Go to Settings->Face ID & Passcode to set it up now.")
    /// Face ID Not Set Up
    internal static let unavailableAlertTitle = L10n.tr("Localizable", "FaceIDSettings.unavailableAlertTitle", fallback: "Face ID Not Set Up")
    /// Enable Face ID to unlock Fabriik
    internal static let unlockTitleText = L10n.tr("Localizable", "FaceIDSettings.unlockTitleText", fallback: "Enable Face ID to unlock Fabriik")
  }
  internal enum FaceIDSpendingLimit {
    /// Face ID Spending Limit
    internal static let title = L10n.tr("Localizable", "FaceIDSpendingLimit.title", fallback: "Face ID Spending Limit")
  }
  internal enum FeeSelector {
    /// Economy
    internal static let economy = L10n.tr("Localizable", "FeeSelector.economy", fallback: "Economy")
    /// 1-24 hours
    internal static let economyTime = L10n.tr("Localizable", "FeeSelector.economyTime", fallback: "1-24 hours")
    /// This option is not recommended for time-sensitive transactions.
    internal static let economyWarning = L10n.tr("Localizable", "FeeSelector.economyWarning", fallback: "This option is not recommended for time-sensitive transactions.")
    /// Estimated Delivery: %1$@
    internal static func estimatedDeliver(_ p1: Any) -> String {
      return L10n.tr("Localizable", "FeeSelector.estimatedDeliver", String(describing: p1), fallback: "Estimated Delivery: %1$@")
    }
    /// 2-5 minutes
    internal static let ethTime = L10n.tr("Localizable", "FeeSelector.ethTime", fallback: "2-5 minutes")
    /// <%1$d minutes
    internal static func lessThanMinutes(_ p1: Int) -> String {
      return L10n.tr("Localizable", "FeeSelector.lessThanMinutes", p1, fallback: "<%1$d minutes")
    }
    /// Priority
    internal static let priority = L10n.tr("Localizable", "FeeSelector.priority", fallback: "Priority")
    /// 10-30 minutes
    internal static let priorityTime = L10n.tr("Localizable", "FeeSelector.priorityTime", fallback: "10-30 minutes")
    /// Regular
    internal static let regular = L10n.tr("Localizable", "FeeSelector.regular", fallback: "Regular")
    /// 10-60 minutes
    internal static let regularTime = L10n.tr("Localizable", "FeeSelector.regularTime", fallback: "10-60 minutes")
    /// Processing Speed
    internal static let title = L10n.tr("Localizable", "FeeSelector.title", fallback: "Processing Speed")
  }
  internal enum FileChooser {
    internal enum SelectImageSource {
      /// Select Image Source
      internal static let android = L10n.tr("Localizable", "FileChooser.selectImageSource.android", fallback: "Select Image Source")
    }
  }
  internal enum FingerprintSettings {
    /// Use your fingerprint to unlock your Fabriik app and send transactions.
    internal static let description = L10n.tr("Localizable", "FingerprintSettings.description", fallback: "Use your fingerprint to unlock your Fabriik app and send transactions.")
    /// Use fingerprint to send money
    internal static let sendMoney = L10n.tr("Localizable", "FingerprintSettings.sendMoney", fallback: "Use fingerprint to send money")
    /// Fingerprint
    internal static let title = L10n.tr("Localizable", "FingerprintSettings.title", fallback: "Fingerprint")
    /// Use fingerprint to unlock Fabriik
    internal static let unlockApp = L10n.tr("Localizable", "FingerprintSettings.unlockApp", fallback: "Use fingerprint to unlock Fabriik")
  }
  internal enum HomeScreen {
    /// Activity
    internal static let activity = L10n.tr("Localizable", "HomeScreen.activity", fallback: "Activity")
    /// Admin
    internal static let admin = L10n.tr("Localizable", "HomeScreen.admin", fallback: "Admin")
    /// Buy
    internal static let buy = L10n.tr("Localizable", "HomeScreen.buy", fallback: "Buy")
    /// Buy & Sell
    internal static let buyAndSell = L10n.tr("Localizable", "HomeScreen.buyAndSell", fallback: "Buy & Sell")
    /// Menu
    internal static let menu = L10n.tr("Localizable", "HomeScreen.menu", fallback: "Menu")
    /// Wallets
    internal static let portfolio = L10n.tr("Localizable", "HomeScreen.portfolio", fallback: "Wallets")
    /// Pull to refresh
    internal static let pullToRefresh = L10n.tr("Localizable", "HomeScreen.PullToRefresh", fallback: "Pull to refresh")
    /// Total Assets
    internal static let totalAssets = L10n.tr("Localizable", "HomeScreen.totalAssets", fallback: "Total Assets")
    /// Swap
    internal static let trade = L10n.tr("Localizable", "HomeScreen.trade", fallback: "Swap")
  }
  internal enum Import {
    /// Checking private key balance...
    internal static let checking = L10n.tr("Localizable", "Import.checking", fallback: "Checking private key balance...")
    /// Send %1$@ from this private key into your wallet? The bitcoin network will receive a fee of %2$@.
    internal static func confirm(_ p1: Any, _ p2: Any) -> String {
      return L10n.tr("Localizable", "Import.confirm", String(describing: p1), String(describing: p2), fallback: "Send %1$@ from this private key into your wallet? The bitcoin network will receive a fee of %2$@.")
    }
    /// Import
    internal static let importButton = L10n.tr("Localizable", "Import.importButton", fallback: "Import")
    /// Importing Wallet
    internal static let importing = L10n.tr("Localizable", "Import.importing", fallback: "Importing Wallet")
    /// Wallet to be imported
    internal static let leftCaption = L10n.tr("Localizable", "Import.leftCaption", fallback: "Wallet to be imported")
    /// Importing a wallet transfers all the money from your other wallet into your Fabriik wallet using a single transaction.
    internal static let message = L10n.tr("Localizable", "Import.message", fallback: "Importing a wallet transfers all the money from your other wallet into your Fabriik wallet using a single transaction.")
    /// This private key is password protected.
    internal static let password = L10n.tr("Localizable", "Import.password", fallback: "This private key is password protected.")
    /// password
    internal static let passwordPlaceholder = L10n.tr("Localizable", "Import.passwordPlaceholder", fallback: "password")
    /// Your Fabriik Wallet
    internal static let rightCaption = L10n.tr("Localizable", "Import.rightCaption", fallback: "Your Fabriik Wallet")
    /// Scan Private Key
    internal static let scan = L10n.tr("Localizable", "Import.scan", fallback: "Scan Private Key")
    /// Success
    internal static let success = L10n.tr("Localizable", "Import.success", fallback: "Success")
    /// Successfully imported wallet.
    internal static let successBody = L10n.tr("Localizable", "Import.SuccessBody", fallback: "Successfully imported wallet.")
    /// Import Wallet
    internal static let title = L10n.tr("Localizable", "Import.title", fallback: "Import Wallet")
    /// Unlocking Key
    internal static let unlockingActivity = L10n.tr("Localizable", "Import.unlockingActivity", fallback: "Unlocking Key")
    /// Importing a wallet does not include transaction history or other details.
    internal static let warning = L10n.tr("Localizable", "Import.warning", fallback: "Importing a wallet does not include transaction history or other details.")
    /// Wrong password, please try again.
    internal static let wrongPassword = L10n.tr("Localizable", "Import.wrongPassword", fallback: "Wrong password, please try again.")
    internal enum Error {
      /// This private key is already in your wallet.
      internal static let duplicate = L10n.tr("Localizable", "Import.Error.duplicate", fallback: "This private key is already in your wallet.")
      /// This private key is empty.
      internal static let empty = L10n.tr("Localizable", "Import.Error.empty", fallback: "This private key is empty.")
      /// Failed to submit transaction.
      internal static let failedSubmit = L10n.tr("Localizable", "Import.Error.failedSubmit", fallback: "Failed to submit transaction.")
      /// Transaction fees would cost more than the funds available on this private key.
      internal static let highFees = L10n.tr("Localizable", "Import.Error.highFees", fallback: "Transaction fees would cost more than the funds available on this private key.")
      /// Not a valid private key
      internal static let notValid = L10n.tr("Localizable", "Import.Error.notValid", fallback: "Not a valid private key")
      /// Service Error
      internal static let serviceError = L10n.tr("Localizable", "Import.Error.serviceError", fallback: "Service Error")
      /// Service Unavailable
      internal static let serviceUnavailable = L10n.tr("Localizable", "Import.Error.serviceUnavailable", fallback: "Service Unavailable")
      /// Error signing transaction
      internal static let signing = L10n.tr("Localizable", "Import.Error.signing", fallback: "Error signing transaction")
      /// Unable to sweep wallet
      internal static let sweepError = L10n.tr("Localizable", "Import.Error.sweepError", fallback: "Unable to sweep wallet")
      /// Unsupported Currency
      internal static let unsupportedCurrency = L10n.tr("Localizable", "Import.Error.unsupportedCurrency", fallback: "Unsupported Currency")
    }
  }
  internal enum InputView {
    /// Invalid code
    internal static let invalidCode = L10n.tr("Localizable", "InputView.InvalidCode", fallback: "Invalid code")
  }
  internal enum JailbreakWarnings {
    /// Close
    internal static let close = L10n.tr("Localizable", "JailbreakWarnings.close", fallback: "Close")
    /// Ignore
    internal static let ignore = L10n.tr("Localizable", "JailbreakWarnings.ignore", fallback: "Ignore")
    /// DEVICE SECURITY COMPROMISED
    ///  Any 'jailbreak' app can access Fabriik's keychain data and steal your bitcoin! Wipe this wallet immediately and restore on a secure device.
    internal static let messageWithBalance = L10n.tr("Localizable", "JailbreakWarnings.messageWithBalance", fallback: "DEVICE SECURITY COMPROMISED\n Any 'jailbreak' app can access Fabriik's keychain data and steal your bitcoin! Wipe this wallet immediately and restore on a secure device.")
    /// DEVICE SECURITY COMPROMISED
    ///  Any 'jailbreak' app can access Fabriik's keychain data and steal your bitcoin. Please only use Fabriik on a non-jailbroken device.
    internal static let messageWithoutBalance = L10n.tr("Localizable", "JailbreakWarnings.messageWithoutBalance", fallback: "DEVICE SECURITY COMPROMISED\n Any 'jailbreak' app can access Fabriik's keychain data and steal your bitcoin. Please only use Fabriik on a non-jailbroken device.")
    /// WARNING
    internal static let title = L10n.tr("Localizable", "JailbreakWarnings.title", fallback: "WARNING")
    /// Wipe
    internal static let wipe = L10n.tr("Localizable", "JailbreakWarnings.wipe", fallback: "Wipe")
  }
  internal enum LinkWallet {
    /// Approve
    internal static let approve = L10n.tr("Localizable", "LinkWallet.approve", fallback: "Approve")
    /// Decline
    internal static let decline = L10n.tr("Localizable", "LinkWallet.decline", fallback: "Decline")
    /// External apps cannot send money without approval from this device
    internal static let disclaimer = L10n.tr("Localizable", "LinkWallet.disclaimer", fallback: "External apps cannot send money without approval from this device")
    /// Note: ONLY interact with this app when on one of the following domains
    internal static let domainTitle = L10n.tr("Localizable", "LinkWallet.domainTitle", fallback: "Note: ONLY interact with this app when on one of the following domains")
    /// Secure Checkout
    internal static let logoFooter = L10n.tr("Localizable", "LinkWallet.logoFooter", fallback: "Secure Checkout")
    /// This app will be able to:
    internal static let permissionsTitle = L10n.tr("Localizable", "LinkWallet.permissionsTitle", fallback: "This app will be able to:")
    /// Link Wallet
    internal static let title = L10n.tr("Localizable", "LinkWallet.title", fallback: "Link Wallet")
  }
  internal enum LocationPlugin {
    /// Location services are disabled.
    internal static let disabled = L10n.tr("Localizable", "LocationPlugin.disabled", fallback: "Location services are disabled.")
    /// Fabriik does not have permission to access location services.
    internal static let notAuthorized = L10n.tr("Localizable", "LocationPlugin.notAuthorized", fallback: "Fabriik does not have permission to access location services.")
  }
  internal enum ManageWallet {
    /// You created your wallet on %1$@
    internal static func creationDatePrefix(_ p1: Any) -> String {
      return L10n.tr("Localizable", "ManageWallet.creationDatePrefix", String(describing: p1), fallback: "You created your wallet on %1$@")
    }
    /// Your wallet name only appears in your account transaction history and cannot be seen by anyone else.
    internal static let description = L10n.tr("Localizable", "ManageWallet.description", fallback: "Your wallet name only appears in your account transaction history and cannot be seen by anyone else.")
    /// Wallet Name
    internal static let textFeildLabel = L10n.tr("Localizable", "ManageWallet.textFeildLabel", fallback: "Wallet Name")
    /// Manage Wallet
    internal static let title = L10n.tr("Localizable", "ManageWallet.title", fallback: "Manage Wallet")
  }
  internal enum MarketData {
    /// 24h high
    internal static let high24h = L10n.tr("Localizable", "MarketData.high24h", fallback: "24h high")
    /// 24h low
    internal static let low24h = L10n.tr("Localizable", "MarketData.low24h", fallback: "24h low")
    /// Market Cap
    internal static let marketCap = L10n.tr("Localizable", "MarketData.marketCap", fallback: "Market Cap")
    /// Trading Volume
    internal static let volume = L10n.tr("Localizable", "MarketData.volume", fallback: "Trading Volume")
  }
  internal enum MenuButton {
    /// Add Wallet
    internal static let addWallet = L10n.tr("Localizable", "MenuButton.addWallet", fallback: "Add Wallet")
    /// ATM Cash Redemption
    internal static let atmCashRedemption = L10n.tr("Localizable", "MenuButton.atmCashRedemption", fallback: "ATM Cash Redemption")
    /// Feedback
    internal static let feedback = L10n.tr("Localizable", "MenuButton.feedback", fallback: "Feedback")
    /// Lock Wallet
    internal static let lock = L10n.tr("Localizable", "MenuButton.lock", fallback: "Lock Wallet")
    /// Manage Assets
    internal static let manageAssets = L10n.tr("Localizable", "MenuButton.manageAssets", fallback: "Manage Assets")
    /// Manage Wallets
    internal static let manageWallets = L10n.tr("Localizable", "MenuButton.manageWallets", fallback: "Manage Wallets")
    /// Scan QR Code
    internal static let scan = L10n.tr("Localizable", "MenuButton.scan", fallback: "Scan QR Code")
    /// Security Settings
    internal static let security = L10n.tr("Localizable", "MenuButton.security", fallback: "Security Settings")
    /// Settings
    internal static let settings = L10n.tr("Localizable", "MenuButton.settings", fallback: "Settings")
    /// Support
    internal static let support = L10n.tr("Localizable", "MenuButton.support", fallback: "Support")
  }
  internal enum MenuViewController {
    /// Create New Wallet
    internal static let createButton = L10n.tr("Localizable", "MenuViewController.createButton", fallback: "Create New Wallet")
    /// Menu
    internal static let modalTitle = L10n.tr("Localizable", "MenuViewController.modalTitle", fallback: "Menu")
    /// Recover Wallet
    internal static let recoverButton = L10n.tr("Localizable", "MenuViewController.recoverButton", fallback: "Recover Wallet")
  }
  internal enum Modal {
    internal enum PaperKeySkip {
      /// Attention
      internal static let title = L10n.tr("Localizable", "Modal.PaperKeySkip.Title", fallback: "Attention")
      internal enum Body {
        /// Your recovery phrase is required to open your wallet if you change the security settings on your phone.
        /// 
        /// Are you sure you want to set up your recovery phrase later?
        internal static let android = L10n.tr("Localizable", "Modal.PaperKeySkip.Body.Android", fallback: "Your recovery phrase is required to open your wallet if you change the security settings on your phone.\n\nAre you sure you want to set up your recovery phrase later?")
      }
      internal enum Button {
        /// Continue Set Up
        internal static let continueSetUp = L10n.tr("Localizable", "Modal.PaperKeySkip.Button.ContinueSetUp", fallback: "Continue Set Up")
        /// I'll do it later
        internal static let illDoItLater = L10n.tr("Localizable", "Modal.PaperKeySkip.Button.IllDoItLater", fallback: "I'll do it later")
      }
    }
  }
  internal enum NodeSelector {
    /// Automatic
    internal static let automatic = L10n.tr("Localizable", "NodeSelector.automatic", fallback: "Automatic")
    /// Switch to Automatic Mode
    internal static let automaticButton = L10n.tr("Localizable", "NodeSelector.automaticButton", fallback: "Switch to Automatic Mode")
    /// Connected
    internal static let connected = L10n.tr("Localizable", "NodeSelector.connected", fallback: "Connected")
    /// Connecting
    internal static let connecting = L10n.tr("Localizable", "NodeSelector.connecting", fallback: "Connecting")
    /// Enter Node IP address and port (optional)
    internal static let enterBody = L10n.tr("Localizable", "NodeSelector.enterBody", fallback: "Enter Node IP address and port (optional)")
    /// Enter Node
    internal static let enterTitle = L10n.tr("Localizable", "NodeSelector.enterTitle", fallback: "Enter Node")
    /// Invalid Node
    internal static let invalid = L10n.tr("Localizable", "NodeSelector.invalid", fallback: "Invalid Node")
    /// Switch to Manual Mode
    internal static let manualButton = L10n.tr("Localizable", "NodeSelector.manualButton", fallback: "Switch to Manual Mode")
    /// Current Primary Node
    internal static let nodeLabel = L10n.tr("Localizable", "NodeSelector.nodeLabel", fallback: "Current Primary Node")
    /// Not Connected
    internal static let notConnected = L10n.tr("Localizable", "NodeSelector.notConnected", fallback: "Not Connected")
    /// Node Connection Status
    internal static let statusLabel = L10n.tr("Localizable", "NodeSelector.statusLabel", fallback: "Node Connection Status")
    /// Bitcoin Nodes
    internal static let title = L10n.tr("Localizable", "NodeSelector.title", fallback: "Bitcoin Nodes")
  }
  internal enum Onboarding {
    /// I'll browse first
    internal static let browseFirst = L10n.tr("Localizable", "Onboarding.browseFirst", fallback: "I'll browse first")
    /// Buy some coin
    internal static let buyCoin = L10n.tr("Localizable", "Onboarding.buyCoin", fallback: "Buy some coin")
    /// Get started
    internal static let getStarted = L10n.tr("Localizable", "Onboarding.getStarted", fallback: "Get started")
    /// Next
    internal static let next = L10n.tr("Localizable", "Onboarding.next", fallback: "Next")
    /// Restore wallet
    internal static let restoreWallet = L10n.tr("Localizable", "Onboarding.restoreWallet", fallback: "Restore wallet")
    /// Skip
    internal static let skip = L10n.tr("Localizable", "Onboarding.skip", fallback: "Skip")
  }
  internal enum OnboardingPageFour {
    /// Start investing today with as little as $50!
    internal static let title = L10n.tr("Localizable", "OnboardingPageFour.title", fallback: "Start investing today with as little as $50!")
  }
  internal enum OnboardingPageOne {
    /// Welcome to your new digital asset wallet!
    internal static let title = L10n.tr("Localizable", "OnboardingPageOne.title", fallback: "Welcome to your new digital asset wallet!")
  }
  internal enum OnboardingPageThree {
    /// Invest and diversify with Fabriik, easily and securely.
    internal static let subtitle = L10n.tr("Localizable", "OnboardingPageThree.subtitle", fallback: "Invest and diversify with Fabriik, easily and securely.")
    /// Buy and swap bitcoin, tokens, and other digital currencies.
    internal static let title = L10n.tr("Localizable", "OnboardingPageThree.title", fallback: "Buy and swap bitcoin, tokens, and other digital currencies.")
  }
  internal enum OnboardingPageTwo {
    /// We have over $6 billion USD worth of assets under protection.
    internal static let subtitle = L10n.tr("Localizable", "OnboardingPageTwo.subtitle", fallback: "We have over $6 billion USD worth of assets under protection.")
    /// Join people around the world who trust Fabriik.
    internal static let title = L10n.tr("Localizable", "OnboardingPageTwo.title", fallback: "Join people around the world who trust Fabriik.")
  }
  internal enum PaymentConfirmation {
    /// Send %1$@ to purchase %2$@
    internal static func amountText(_ p1: Any, _ p2: Any) -> String {
      return L10n.tr("Localizable", "PaymentConfirmation.amountText", String(describing: p1), String(describing: p2), fallback: "Send %1$@ to purchase %2$@")
    }
    /// The payment has expired due to inactivity. Please try again with the same card, or use a different card.
    internal static let paymentExpired = L10n.tr("Localizable", "PaymentConfirmation.PaymentExpired", fallback: "The payment has expired due to inactivity. Please try again with the same card, or use a different card.")
    /// Payment verification timeout
    internal static let paymentTimeout = L10n.tr("Localizable", "PaymentConfirmation.PaymentTimeout", fallback: "Payment verification timeout")
    /// Confirmation
    internal static let title = L10n.tr("Localizable", "PaymentConfirmation.title", fallback: "Confirmation")
    /// Try again
    internal static let tryAgain = L10n.tr("Localizable", "PaymentConfirmation.TryAgain", fallback: "Try again")
  }
  internal enum PaymentProtocol {
    internal enum Errors {
      /// Bad Payment Request
      internal static let badPaymentRequest = L10n.tr("Localizable", "PaymentProtocol.Errors.badPaymentRequest", fallback: "Bad Payment Request")
      /// Unsupported or corrupted document
      internal static let corruptedDocument = L10n.tr("Localizable", "PaymentProtocol.Errors.corruptedDocument", fallback: "Unsupported or corrupted document")
      /// missing certificate
      internal static let missingCertificate = L10n.tr("Localizable", "PaymentProtocol.Errors.missingCertificate", fallback: "missing certificate")
      /// request expired
      internal static let requestExpired = L10n.tr("Localizable", "PaymentProtocol.Errors.requestExpired", fallback: "request expired")
      /// Couldn't make payment
      internal static let smallOutputError = L10n.tr("Localizable", "PaymentProtocol.Errors.smallOutputError", fallback: "Couldn't make payment")
      /// Payment can’t be less than %1$@. Bitcoin transaction fees are more than the amount of this transaction. Please increase the amount and try again.
      internal static func smallPayment(_ p1: Any) -> String {
        return L10n.tr("Localizable", "PaymentProtocol.Errors.smallPayment", String(describing: p1), fallback: "Payment can’t be less than %1$@. Bitcoin transaction fees are more than the amount of this transaction. Please increase the amount and try again.")
      }
      /// Bitcoin transaction outputs can't be less than %1$@.
      internal static func smallTransaction(_ p1: Any) -> String {
        return L10n.tr("Localizable", "PaymentProtocol.Errors.smallTransaction", String(describing: p1), fallback: "Bitcoin transaction outputs can't be less than %1$@.")
      }
      /// unsupported signature type
      internal static let unsupportedSignatureType = L10n.tr("Localizable", "PaymentProtocol.Errors.unsupportedSignatureType", fallback: "unsupported signature type")
      /// untrusted certificate
      internal static let untrustedCertificate = L10n.tr("Localizable", "PaymentProtocol.Errors.untrustedCertificate", fallback: "untrusted certificate")
    }
  }
  internal enum Platform {
    /// Transaction Cancelled
    internal static let transactionCancelled = L10n.tr("Localizable", "Platform.transaction_cancelled", fallback: "Transaction Cancelled")
  }
  internal enum Prompts {
    internal enum Email {
      /// Be the first to receive important support and product updates
      internal static let body = L10n.tr("Localizable", "Prompts.Email.body", fallback: "Be the first to receive important support and product updates")
      /// enter your email
      internal static let placeholder = L10n.tr("Localizable", "Prompts.Email.placeholder", fallback: "enter your email")
      /// You have successfully subscribed to receive updates
      internal static let successBody = L10n.tr("Localizable", "Prompts.Email.successBody", fallback: "You have successfully subscribed to receive updates")
      /// We appreciate your continued support
      internal static let successFootnote = L10n.tr("Localizable", "Prompts.Email.successFootnote", fallback: "We appreciate your continued support")
      /// Thank you!
      internal static let successTitle = L10n.tr("Localizable", "Prompts.Email.successTitle", fallback: "Thank you!")
      /// Get in the loop
      internal static let title = L10n.tr("Localizable", "Prompts.Email.title", fallback: "Get in the loop")
    }
    internal enum FaceId {
      /// Tap Continue to enable Face ID
      internal static let body = L10n.tr("Localizable", "Prompts.FaceId.body", fallback: "Tap Continue to enable Face ID")
      /// Enable Face ID
      internal static let title = L10n.tr("Localizable", "Prompts.FaceId.title", fallback: "Enable Face ID")
    }
    internal enum NoPasscode {
      /// A device passcode is needed to safeguard your wallet. Go to settings and turn passcode on.
      internal static let body = L10n.tr("Localizable", "Prompts.NoPasscode.body", fallback: "A device passcode is needed to safeguard your wallet. Go to settings and turn passcode on.")
      /// Turn device passcode on
      internal static let title = L10n.tr("Localizable", "Prompts.NoPasscode.title", fallback: "Turn device passcode on")
    }
    internal enum NoScreenLock {
      internal enum Body {
        /// A device screen lock is needed to safeguard your wallet. Enable screen lock in your settings to continue.
        internal static let android = L10n.tr("Localizable", "Prompts.NoScreenLock.body.android", fallback: "A device screen lock is needed to safeguard your wallet. Enable screen lock in your settings to continue.")
      }
      internal enum Title {
        /// Screen lock disabled
        internal static let android = L10n.tr("Localizable", "Prompts.NoScreenLock.title.android", fallback: "Screen lock disabled")
      }
    }
    internal enum PaperKey {
      /// Please write down your recovery phrase and store it somewhere that is safe and secure.
      internal static let body = L10n.tr("Localizable", "Prompts.PaperKey.body", fallback: "Please write down your recovery phrase and store it somewhere that is safe and secure.")
      /// Action Required
      internal static let title = L10n.tr("Localizable", "Prompts.PaperKey.title", fallback: "Action Required")
      internal enum Body {
        /// Set up your recovery phrase in case you ever lose or replace your phone. Your key is also required if you change your phone's security settings.
        internal static let android = L10n.tr("Localizable", "Prompts.PaperKey.Body.Android", fallback: "Set up your recovery phrase in case you ever lose or replace your phone. Your key is also required if you change your phone's security settings.")
      }
    }
    internal enum RateApp {
      /// Don't ask again
      internal static let dontShow = L10n.tr("Localizable", "Prompts.RateApp.dontShow", fallback: "Don't ask again")
      /// Enjoying Fabriik?
      internal static let enjoyingBrd = L10n.tr("Localizable", "Prompts.RateApp.enjoyingBrd", fallback: "Enjoying Fabriik?")
      /// Enjoying Fabriik?
      internal static let enjoyingFabriik = L10n.tr("Localizable", "Prompts.RateApp.enjoyingFabriik", fallback: "Enjoying Fabriik?")
      /// Your review helps grow the Fabriik community.
      internal static let googlePlayReview = L10n.tr("Localizable", "Prompts.RateApp.googlePlayReview", fallback: "Your review helps grow the Fabriik community.")
      /// No thanks
      internal static let noThanks = L10n.tr("Localizable", "Prompts.RateApp.noThanks", fallback: "No thanks")
      /// Review us
      internal static let rateUs = L10n.tr("Localizable", "Prompts.RateApp.rateUs", fallback: "Review us")
    }
    internal enum RecommendRescan {
      /// Your wallet may be out of sync. This can often be fixed by rescanning the blockchain.
      internal static let body = L10n.tr("Localizable", "Prompts.RecommendRescan.body", fallback: "Your wallet may be out of sync. This can often be fixed by rescanning the blockchain.")
      /// Transaction Rejected
      internal static let title = L10n.tr("Localizable", "Prompts.RecommendRescan.title", fallback: "Transaction Rejected")
    }
    internal enum ShareData {
      /// Help improve Fabriik by sharing your anonymous data with us
      internal static let body = L10n.tr("Localizable", "Prompts.ShareData.body", fallback: "Help improve Fabriik by sharing your anonymous data with us")
      /// Share Anonymous Data
      internal static let title = L10n.tr("Localizable", "Prompts.ShareData.title", fallback: "Share Anonymous Data")
    }
    internal enum TouchId {
      /// Tap Continue to enable Touch ID
      internal static let body = L10n.tr("Localizable", "Prompts.TouchId.body", fallback: "Tap Continue to enable Touch ID")
      /// Enable Touch ID
      internal static let title = L10n.tr("Localizable", "Prompts.TouchId.title", fallback: "Enable Touch ID")
      internal enum Body {
        /// Tap here to enable fingerprint authentication
        internal static let android = L10n.tr("Localizable", "Prompts.TouchId.body.android", fallback: "Tap here to enable fingerprint authentication")
      }
      internal enum Title {
        /// Enable Fingerprint Authentication
        internal static let android = L10n.tr("Localizable", "Prompts.TouchId.title.android", fallback: "Enable Fingerprint Authentication")
      }
      internal enum UsePin {
        /// PIN
        internal static let android = L10n.tr("Localizable", "Prompts.TouchId.usePin.android", fallback: "PIN")
      }
    }
    internal enum UpgradePin {
      /// Fabriik has upgraded to using a 6-digit PIN. Tap Continue to upgrade.
      internal static let body = L10n.tr("Localizable", "Prompts.UpgradePin.body", fallback: "Fabriik has upgraded to using a 6-digit PIN. Tap Continue to upgrade.")
      /// Upgrade PIN
      internal static let title = L10n.tr("Localizable", "Prompts.UpgradePin.title", fallback: "Upgrade PIN")
    }
  }
  internal enum PushNotifications {
    /// Turn on push notifications and be the first to hear about new features and special offers.
    internal static let body = L10n.tr("Localizable", "PushNotifications.body", fallback: "Turn on push notifications and be the first to hear about new features and special offers.")
    /// Notifications Disabled
    internal static let disabled = L10n.tr("Localizable", "PushNotifications.disabled", fallback: "Notifications Disabled")
    /// Turn on notifications to receive special offers and updates from Fabriik.
    internal static let disabledBody = L10n.tr("Localizable", "PushNotifications.disabledBody", fallback: "Turn on notifications to receive special offers and updates from Fabriik.")
    /// You’re receiving special offers and updates from Fabriik.
    internal static let enabledBody = L10n.tr("Localizable", "PushNotifications.enabledBody", fallback: "You’re receiving special offers and updates from Fabriik.")
    /// Looks like notifications are turned off. Please go to Settings to enable notifications from Fabriik.
    internal static let enableInstructions = L10n.tr("Localizable", "PushNotifications.enableInstructions", fallback: "Looks like notifications are turned off. Please go to Settings to enable notifications from Fabriik.")
    /// Receive Push Notifications
    internal static let label = L10n.tr("Localizable", "PushNotifications.label", fallback: "Receive Push Notifications")
    /// Off
    internal static let off = L10n.tr("Localizable", "PushNotifications.off", fallback: "Off")
    /// On
    internal static let on = L10n.tr("Localizable", "PushNotifications.on", fallback: "On")
    /// Stay in the Loop
    internal static let title = L10n.tr("Localizable", "PushNotifications.title", fallback: "Stay in the Loop")
    /// Failed to update push notifications settings
    internal static let updateFailed = L10n.tr("Localizable", "PushNotifications.updateFailed", fallback: "Failed to update push notifications settings")
  }
  internal enum RateAppPrompt {
    internal enum Body {
      /// If you love our app, please take a moment to rate it and give us a review.
      internal static let android = L10n.tr("Localizable", "RateAppPrompt.Body.Android", fallback: "If you love our app, please take a moment to rate it and give us a review.")
    }
    internal enum Button {
      internal enum Dismiss {
        /// No Thanks
        internal static let android = L10n.tr("Localizable", "RateAppPrompt.Button.Dismiss.Android", fallback: "No Thanks")
      }
      internal enum RateApp {
        /// Rate Fabriik
        internal static let android = L10n.tr("Localizable", "RateAppPrompt.Button.RateApp.Android", fallback: "Rate Fabriik")
      }
    }
    internal enum Title {
      /// Rate Fabriik
      internal static let android = L10n.tr("Localizable", "RateAppPrompt.Title.Android", fallback: "Rate Fabriik")
    }
  }
  internal enum ReScan {
    /// Sync
    internal static let alertAction = L10n.tr("Localizable", "ReScan.alertAction", fallback: "Sync")
    /// You will not be able to send money while syncing.
    internal static let alertMessage = L10n.tr("Localizable", "ReScan.alertMessage", fallback: "You will not be able to send money while syncing.")
    /// Sync with Blockchain?
    internal static let alertTitle = L10n.tr("Localizable", "ReScan.alertTitle", fallback: "Sync with Blockchain?")
    /// 20-45 minutes
    internal static let body1 = L10n.tr("Localizable", "ReScan.body1", fallback: "20-45 minutes")
    /// If a transaction shows as completed on the network but not in your Fabriik.
    internal static let body2 = L10n.tr("Localizable", "ReScan.body2", fallback: "If a transaction shows as completed on the network but not in your Fabriik.")
    /// You repeatedly get an error saying your transaction was rejected.
    internal static let body3 = L10n.tr("Localizable", "ReScan.body3", fallback: "You repeatedly get an error saying your transaction was rejected.")
    /// Start Sync
    internal static let buttonTitle = L10n.tr("Localizable", "ReScan.buttonTitle", fallback: "Start Sync")
    /// You will not be able to send money while syncing with the blockchain.
    internal static let footer = L10n.tr("Localizable", "ReScan.footer", fallback: "You will not be able to send money while syncing with the blockchain.")
    /// Sync Blockchain
    internal static let header = L10n.tr("Localizable", "ReScan.header", fallback: "Sync Blockchain")
    /// Estimated time
    internal static let subheader1 = L10n.tr("Localizable", "ReScan.subheader1", fallback: "Estimated time")
    /// When to Sync?
    internal static let subheader2 = L10n.tr("Localizable", "ReScan.subheader2", fallback: "When to Sync?")
  }
  internal enum Receive {
    /// Copied to clipboard.
    internal static let copied = L10n.tr("Localizable", "Receive.copied", fallback: "Copied to clipboard.")
    /// Email
    internal static let emailButton = L10n.tr("Localizable", "Receive.emailButton", fallback: "Email")
    /// Request an Amount
    internal static let request = L10n.tr("Localizable", "Receive.request", fallback: "Request an Amount")
    /// Share
    internal static let share = L10n.tr("Localizable", "Receive.share", fallback: "Share")
    /// Text Message
    internal static let textButton = L10n.tr("Localizable", "Receive.textButton", fallback: "Text Message")
    /// Receive
    internal static let title = L10n.tr("Localizable", "Receive.title", fallback: "Receive")
  }
  internal enum RecoverWallet {
    /// Done
    internal static let done = L10n.tr("Localizable", "RecoverWallet.done", fallback: "Done")
    /// Please enter your recovery phrase to delete this wallet from your device.
    internal static let enterRecoveryPhrase = L10n.tr("Localizable", "RecoverWallet.EnterRecoveryPhrase", fallback: "Please enter your recovery phrase to delete this wallet from your device.")
    /// Recover Wallet
    internal static let header = L10n.tr("Localizable", "RecoverWallet.header", fallback: "Recover Wallet")
    /// Reset PIN
    internal static let headerResetPin = L10n.tr("Localizable", "RecoverWallet.header_reset_pin", fallback: "Reset PIN")
    /// Enter Recovery Phrase
    internal static let instruction = L10n.tr("Localizable", "RecoverWallet.instruction", fallback: "Enter Recovery Phrase")
    /// Recover your Fabriik with your recovery phrase.
    internal static let intro = L10n.tr("Localizable", "RecoverWallet.intro", fallback: "Recover your Fabriik with your recovery phrase.")
    /// The recovery phrase you entered is invalid. Please double-check each word and try again.
    internal static let invalid = L10n.tr("Localizable", "RecoverWallet.invalid", fallback: "The recovery phrase you entered is invalid. Please double-check each word and try again.")
    /// Left Arrow
    internal static let leftArrow = L10n.tr("Localizable", "RecoverWallet.leftArrow", fallback: "Left Arrow")
    /// Next
    internal static let next = L10n.tr("Localizable", "RecoverWallet.next", fallback: "Next")
    /// A Recovery Phrase consists of 12 randomly generated words. The app creates the Recovery Phrase for you automatically when you start a new wallet. The Recovery Phrase is critically important and should be written down and stored in a safe location. In the event of phone theft, destruction, or loss, the Recovery Phrase can be used to load your wallet onto a new phone. The key is also required when upgrading your current phone to a new one.
    internal static let recoveryPhrasePopup = L10n.tr("Localizable", "RecoverWallet.RecoveryPhrasePopup", fallback: "A Recovery Phrase consists of 12 randomly generated words. The app creates the Recovery Phrase for you automatically when you start a new wallet. The Recovery Phrase is critically important and should be written down and stored in a safe location. In the event of phone theft, destruction, or loss, the Recovery Phrase can be used to load your wallet onto a new phone. The key is also required when upgrading your current phone to a new one.")
    /// Tap here for more information.
    internal static let resetPinMoreInfo = L10n.tr("Localizable", "RecoverWallet.reset_pin_more_info", fallback: "Tap here for more information.")
    /// Right Arrow
    internal static let rightArrow = L10n.tr("Localizable", "RecoverWallet.rightArrow", fallback: "Right Arrow")
    /// Enter the recovery phrase for the wallet you want to recover.
    internal static let subheader = L10n.tr("Localizable", "RecoverWallet.subheader", fallback: "Enter the recovery phrase for the wallet you want to recover.")
    /// To reset your PIN, enter the words from your recovery phrase into the boxes below.
    internal static let subheaderResetPin = L10n.tr("Localizable", "RecoverWallet.subheader_reset_pin", fallback: "To reset your PIN, enter the words from your recovery phrase into the boxes below.")
    /// What is “Recovery Phrase”?
    internal static let whatIsRecoveryPhrase = L10n.tr("Localizable", "RecoverWallet.WhatIsRecoveryPhrase", fallback: "What is “Recovery Phrase”?")
  }
  internal enum RecoveryKeyFlow {
    /// The word you entered is incorrect. Please try again.
    internal static let confirmRecoveryInputError = L10n.tr("Localizable", "RecoveryKeyFlow.confirmRecoveryInputError", fallback: "The word you entered is incorrect. Please try again.")
    /// Almost done! Enter the following words from your recovery phrase.
    internal static let confirmRecoveryKeySubtitle = L10n.tr("Localizable", "RecoveryKeyFlow.confirmRecoveryKeySubtitle", fallback: "Almost done! Enter the following words from your recovery phrase.")
    /// Confirm Recovery Phrase
    internal static let confirmRecoveryKeyTitle = L10n.tr("Localizable", "RecoveryKeyFlow.confirmRecoveryKeyTitle", fallback: "Confirm Recovery Phrase")
    /// Enter Recovery Phrase
    internal static let enterRecoveryKey = L10n.tr("Localizable", "RecoveryKeyFlow.enterRecoveryKey", fallback: "Enter Recovery Phrase")
    /// Please enter your recovery phrase to unlink this wallet from your device.
    internal static let enterRecoveryKeySubtitle = L10n.tr("Localizable", "RecoveryKeyFlow.enterRecoveryKeySubtitle", fallback: "Please enter your recovery phrase to unlink this wallet from your device.")
    /// Are you sure you want to set up your recovery phrase later?
    internal static let exitRecoveryKeyPromptBody = L10n.tr("Localizable", "RecoveryKeyFlow.exitRecoveryKeyPromptBody", fallback: "Are you sure you want to set up your recovery phrase later?")
    /// Set Up Later
    internal static let exitRecoveryKeyPromptTitle = L10n.tr("Localizable", "RecoveryKeyFlow.exitRecoveryKeyPromptTitle", fallback: "Set Up Later")
    /// Generate Recovery Phrase
    internal static let generateKeyButton = L10n.tr("Localizable", "RecoveryKeyFlow.generateKeyButton", fallback: "Generate Recovery Phrase")
    /// This key is required to recover your money if you upgrade or lose your phone.
    internal static let generateKeyExplanation = L10n.tr("Localizable", "RecoveryKeyFlow.generateKeyExplanation", fallback: "This key is required to recover your money if you upgrade or lose your phone.")
    /// Generate your private recovery phrase
    internal static let generateKeyTitle = L10n.tr("Localizable", "RecoveryKeyFlow.generateKeyTitle", fallback: "Generate your private recovery phrase")
    /// Go to Wallet
    internal static let goToWalletButtonTitle = L10n.tr("Localizable", "RecoveryKeyFlow.goToWalletButtonTitle", fallback: "Go to Wallet")
    /// How it works - Step %1$@
    internal static func howItWorksStep(_ p1: Any) -> String {
      return L10n.tr("Localizable", "RecoveryKeyFlow.howItWorksStep", String(describing: p1), fallback: "How it works - Step %1$@")
    }
    /// Some of the words you entered do not match your recovery phrase. Please try again.
    internal static let invalidPhrase = L10n.tr("Localizable", "RecoveryKeyFlow.invalidPhrase", fallback: "Some of the words you entered do not match your recovery phrase. Please try again.")
    /// Keep it secure
    internal static let keepSecure = L10n.tr("Localizable", "RecoveryKeyFlow.keepSecure", fallback: "Keep it secure")
    /// Your key is only needed for recovery, not for everyday wallet access.
    internal static let keyUseHint = L10n.tr("Localizable", "RecoveryKeyFlow.keyUseHint", fallback: "Your key is only needed for recovery, not for everyday wallet access.")
    /// For security purposes, do not screenshot or email these words
    internal static let noScreenshotsOrEmailWarning = L10n.tr("Localizable", "RecoveryKeyFlow.noScreenshotsOrEmailWarning", fallback: "For security purposes, do not screenshot or email these words")
    /// Write down your key on paper and confirm it. Screenshots are not recommended for security reasons.
    internal static let noScreenshotsRecommendation = L10n.tr("Localizable", "RecoveryKeyFlow.noScreenshotsRecommendation", fallback: "Write down your key on paper and confirm it. Screenshots are not recommended for security reasons.")
    /// Recover Your Wallet
    internal static let recoveryYourWallet = L10n.tr("Localizable", "RecoveryKeyFlow.recoveryYourWallet", fallback: "Recover Your Wallet")
    /// Please enter the recovery phrase of the wallet you want to recover.
    internal static let recoveryYourWalletSubtitle = L10n.tr("Localizable", "RecoveryKeyFlow.recoveryYourWalletSubtitle", fallback: "Please enter the recovery phrase of the wallet you want to recover.")
    /// Relax, buy, and swap
    internal static let relaxBuyTrade = L10n.tr("Localizable", "RecoveryKeyFlow.relaxBuyTrade", fallback: "Relax, buy, and swap")
    /// Remember to write these words down. Swipe back if you forgot.
    internal static let rememberToWriteDownReminder = L10n.tr("Localizable", "RecoveryKeyFlow.rememberToWriteDownReminder", fallback: "Remember to write these words down. Swipe back if you forgot.")
    /// Please enter your recovery phrase to reset your PIN.
    internal static let resetPINInstruction = L10n.tr("Localizable", "RecoveryKeyFlow.resetPINInstruction", fallback: "Please enter your recovery phrase to reset your PIN.")
    /// Buy and swap knowing that your funds are protected by the best security and privacy in the business.
    internal static let securityAssurance = L10n.tr("Localizable", "RecoveryKeyFlow.securityAssurance", fallback: "Buy and swap knowing that your funds are protected by the best security and privacy in the business.")
    /// Store your key in a secure location. This is the only way to recover your wallet. Fabriik does not keep a copy.
    internal static let storeSecurelyRecommendation = L10n.tr("Localizable", "RecoveryKeyFlow.storeSecurelyRecommendation", fallback: "Store your key in a secure location. This is the only way to recover your wallet. Fabriik does not keep a copy.")
    /// Congratulations! You completed your recovery phrase setup.
    internal static let successHeading = L10n.tr("Localizable", "RecoveryKeyFlow.successHeading", fallback: "Congratulations! You completed your recovery phrase setup.")
    /// You're all set to deposit, swap, and buy crypto from your Fabriik wallet.
    internal static let successSubheading = L10n.tr("Localizable", "RecoveryKeyFlow.successSubheading", fallback: "You're all set to deposit, swap, and buy crypto from your Fabriik wallet.")
    /// Unlink your wallet from this device.
    internal static let unlinkWallet = L10n.tr("Localizable", "RecoveryKeyFlow.unlinkWallet", fallback: "Unlink your wallet from this device.")
    /// Start a new wallet by unlinking your device from the currently installed wallet.
    internal static let unlinkWalletSubtext = L10n.tr("Localizable", "RecoveryKeyFlow.unlinkWalletSubtext", fallback: "Start a new wallet by unlinking your device from the currently installed wallet.")
    /// Wallet must be recovered to regain access.
    internal static let unlinkWalletWarning = L10n.tr("Localizable", "RecoveryKeyFlow.unlinkWalletWarning", fallback: "Wallet must be recovered to regain access.")
    /// Wipe your wallet from this device.
    internal static let wipeWallet = L10n.tr("Localizable", "RecoveryKeyFlow.wipeWallet", fallback: "Wipe your wallet from this device.")
    /// Start a new wallet by wiping the current wallet from your device.
    internal static let wipeWalletSubtext = L10n.tr("Localizable", "RecoveryKeyFlow.wipeWalletSubtext", fallback: "Start a new wallet by wiping the current wallet from your device.")
    /// Write down your key
    internal static let writeItDown = L10n.tr("Localizable", "RecoveryKeyFlow.writeItDown", fallback: "Write down your key")
    /// Write down your recovery phrase again
    internal static let writeKeyAgain = L10n.tr("Localizable", "RecoveryKeyFlow.writeKeyAgain", fallback: "Write down your recovery phrase again")
    /// Write down the following words in order.
    internal static let writeKeyScreenSubtitle = L10n.tr("Localizable", "RecoveryKeyFlow.writeKeyScreenSubtitle", fallback: "Write down the following words in order.")
    /// Your Recovery Phrase
    internal static let writeKeyScreenTitle = L10n.tr("Localizable", "RecoveryKeyFlow.writeKeyScreenTitle", fallback: "Your Recovery Phrase")
    /// %1$@ of %2$@
    internal static func writeKeyStepTitle(_ p1: Any, _ p2: Any) -> String {
      return L10n.tr("Localizable", "RecoveryKeyFlow.writeKeyStepTitle", String(describing: p1), String(describing: p2), fallback: "%1$@ of %2$@")
    }
  }
  internal enum RequestAnAmount {
    /// Please enter an amount first.
    internal static let noAmount = L10n.tr("Localizable", "RequestAnAmount.noAmount", fallback: "Please enter an amount first.")
    /// Request an Amount
    internal static let title = L10n.tr("Localizable", "RequestAnAmount.title", fallback: "Request an Amount")
  }
  internal enum RewardsView {
    /// Learn how you can save on trading fees and unlock future rewards
    internal static let expandedBody = L10n.tr("Localizable", "RewardsView.expandedBody", fallback: "Learn how you can save on trading fees and unlock future rewards")
    /// Introducing Fabriik Rewards.
    internal static let expandedTitle = L10n.tr("Localizable", "RewardsView.expandedTitle", fallback: "Introducing Fabriik Rewards.")
    /// Rewards
    internal static let normalTitle = L10n.tr("Localizable", "RewardsView.normalTitle", fallback: "Rewards")
  }
  internal enum Scanner {
    /// Camera Flash
    internal static let flashButtonLabel = L10n.tr("Localizable", "Scanner.flashButtonLabel", fallback: "Camera Flash")
    /// Would you like to send a %1$@ payment to this address?
    internal static func paymentPromptMessage(_ p1: Any) -> String {
      return L10n.tr("Localizable", "Scanner.paymentPromptMessage", String(describing: p1), fallback: "Would you like to send a %1$@ payment to this address?")
    }
    /// Send Payment
    internal static let paymentPromptTitle = L10n.tr("Localizable", "Scanner.paymentPromptTitle", fallback: "Send Payment")
  }
  internal enum Search {
    /// complete
    internal static let complete = L10n.tr("Localizable", "Search.complete", fallback: "complete")
    /// pending
    internal static let pending = L10n.tr("Localizable", "Search.pending", fallback: "pending")
    /// received
    internal static let received = L10n.tr("Localizable", "Search.received", fallback: "received")
    /// Search
    internal static let search = L10n.tr("Localizable", "Search.search", fallback: "Search")
    /// sent
    internal static let sent = L10n.tr("Localizable", "Search.sent", fallback: "sent")
  }
  internal enum SecurityCenter {
    /// Face ID
    internal static let faceIdTitle = L10n.tr("Localizable", "SecurityCenter.faceIdTitle", fallback: "Face ID")
    /// The only way to access your assets if you lose or upgrade your phone.
    internal static let paperKeyDescription = L10n.tr("Localizable", "SecurityCenter.paperKeyDescription", fallback: "The only way to access your assets if you lose or upgrade your phone.")
    /// Recovery Phrase
    internal static let paperKeyTitle = L10n.tr("Localizable", "SecurityCenter.paperKeyTitle", fallback: "Recovery Phrase")
    /// Protects your Fabriik from unauthorized users.
    internal static let pinDescription = L10n.tr("Localizable", "SecurityCenter.pinDescription", fallback: "Protects your Fabriik from unauthorized users.")
    /// 6-Digit PIN
    internal static let pinTitle = L10n.tr("Localizable", "SecurityCenter.pinTitle", fallback: "6-Digit PIN")
    /// Conveniently unlock your Fabriik and send money up to a set limit.
    internal static let touchIdDescription = L10n.tr("Localizable", "SecurityCenter.touchIdDescription", fallback: "Conveniently unlock your Fabriik and send money up to a set limit.")
    /// Touch ID
    internal static let touchIdTitle = L10n.tr("Localizable", "SecurityCenter.touchIdTitle", fallback: "Touch ID")
    internal enum PaperKeyTitle {
      /// Recovery Phrase
      internal static let android = L10n.tr("Localizable", "SecurityCenter.paperKeyTitle.android", fallback: "Recovery Phrase")
    }
    internal enum TouchIdTitle {
      /// Fingerprint Authentication
      internal static let android = L10n.tr("Localizable", "SecurityCenter.touchIdTitle.android", fallback: "Fingerprint Authentication")
    }
  }
  internal enum Segwit {
    /// You have enabled SegWit!
    internal static let confirmationConfirmationTitle = L10n.tr("Localizable", "Segwit.ConfirmationConfirmationTitle", fallback: "You have enabled SegWit!")
    /// SegWit support is still a beta feature.
    /// 
    /// Once SegWit is enabled, it will not be possible
    /// to disable it. You will be able to find the legacy address under Settings. 
    /// 
    /// Some third-party services, including crypto trading, may be unavailable to users who have enabled SegWit. In case of emergency, you will be able to generate a legacy address from Preferences > BTC Settings. 
    /// 
    /// SegWit will automatically be enabled for all
    /// users in a future update.
    internal static let confirmationInstructionsInstructions = L10n.tr("Localizable", "Segwit.ConfirmationInstructionsInstructions", fallback: "SegWit support is still a beta feature.\n\nOnce SegWit is enabled, it will not be possible\nto disable it. You will be able to find the legacy address under Settings. \n\nSome third-party services, including crypto trading, may be unavailable to users who have enabled SegWit. In case of emergency, you will be able to generate a legacy address from Preferences > BTC Settings. \n\nSegWit will automatically be enabled for all\nusers in a future update.")
    /// Enabling SegWit is an irreversible feature. Are you sure you want to continue?
    internal static let confirmChoiceLayout = L10n.tr("Localizable", "Segwit.ConfirmChoiceLayout", fallback: "Enabling SegWit is an irreversible feature. Are you sure you want to continue?")
    /// Enable
    internal static let enable = L10n.tr("Localizable", "Segwit.Enable", fallback: "Enable")
    /// Proceed
    internal static let homeButton = L10n.tr("Localizable", "Segwit.HomeButton", fallback: "Proceed")
  }
  internal enum Send {
    /// Amount
    internal static let amountLabel = L10n.tr("Localizable", "Send.amountLabel", fallback: "Amount")
    /// Balance: %1$@
    internal static func balance(_ p1: Any) -> String {
      return L10n.tr("Localizable", "Send.balance", String(describing: p1), fallback: "Balance: %1$@")
    }
    /// Balance:
    internal static let balanceString = L10n.tr("Localizable", "Send.balanceString", fallback: "Balance:")
    /// Go to Settings to allow camera access.
    internal static let cameraunavailableMessage = L10n.tr("Localizable", "Send.cameraunavailableMessage", fallback: "Go to Settings to allow camera access.")
    /// Fabriik is not allowed to access the camera
    internal static let cameraUnavailableTitle = L10n.tr("Localizable", "Send.cameraUnavailableTitle", fallback: "Fabriik is not allowed to access the camera")
    /// The destination is your own address. You cannot send to yourself.
    internal static let containsAddress = L10n.tr("Localizable", "Send.containsAddress", fallback: "The destination is your own address. You cannot send to yourself.")
    /// Could not create transaction.
    internal static let creatTransactionError = L10n.tr("Localizable", "Send.creatTransactionError", fallback: "Could not create transaction.")
    /// Memo
    internal static let descriptionLabel = L10n.tr("Localizable", "Send.descriptionLabel", fallback: "Memo")
    /// Destination tag is too long.
    internal static let destinationTag = L10n.tr("Localizable", "Send.DestinationTag", fallback: "Destination tag is too long.")
    /// Destination Tag
    internal static let destinationTagOptional = L10n.tr("Localizable", "Send.destinationTag_optional", fallback: "Destination Tag")
    /// Destination Tag (Required)
    internal static let destinationTagRequired = L10n.tr("Localizable", "Send.destinationTag_required", fallback: "Destination Tag (Required)")
    /// A valid Destination Tag is required for the target address.
    internal static let destinationTagRequiredError = L10n.tr("Localizable", "Send.destinationTag_required_error", fallback: "A valid Destination Tag is required for the target address.")
    /// Some receiving addresses (exchanges usually) require additional identifying information provided with a Destination Tag.
    /// 
    /// If the recipient's address is accompanied by a destination tag, make sure to include it.
    /// Also, we strongly suggest you send a small amount of cryptocurrency as a test before attempting to send a significant amount.
    internal static let destinationTagText = L10n.tr("Localizable", "Send.DestinationTagText", fallback: "Some receiving addresses (exchanges usually) require additional identifying information provided with a Destination Tag.\n\nIf the recipient's address is accompanied by a destination tag, make sure to include it.\nAlso, we strongly suggest you send a small amount of cryptocurrency as a test before attempting to send a significant amount.")
    /// Pasteboard is empty
    internal static let emptyPasteboard = L10n.tr("Localizable", "Send.emptyPasteboard", fallback: "Pasteboard is empty")
    /// Can't send to self.
    internal static let ethSendSelf = L10n.tr("Localizable", "Send.ethSendSelf", fallback: "Can't send to self.")
    /// Network Fee: %1$@
    internal static func fee(_ p1: Any) -> String {
      return L10n.tr("Localizable", "Send.fee", String(describing: p1), fallback: "Network Fee: %1$@")
    }
    /// Invalid FIO address.
    internal static let fioInvalid = L10n.tr("Localizable", "Send.fio_invalid", fallback: "Invalid FIO address.")
    /// There is no %1$s address associated with this FIO address.
    internal static func fioNoAddress(_ p1: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "Send.fio_noAddress", p1, fallback: "There is no %1$s address associated with this FIO address.")
    }
    /// There was an error retrieving the address for this FIO address. Please try again later.
    internal static let fioRetrievalError = L10n.tr("Localizable", "Send.fio_retrievalError", fallback: "There was an error retrieving the address for this FIO address. Please try again later.")
    /// Payee identity isn't certified.
    internal static let identityNotCertified = L10n.tr("Localizable", "Send.identityNotCertified", fallback: "Payee identity isn't certified.")
    /// Insufficient Funds
    internal static let insufficientFunds = L10n.tr("Localizable", "Send.insufficientFunds", fallback: "Insufficient Funds")
    /// You must have at least %1$@ in your wallet in order to transfer this type of token. Would you like to go to your Ethereum wallet now?
    internal static func insufficientGasMessage(_ p1: Any) -> String {
      return L10n.tr("Localizable", "Send.insufficientGasMessage", String(describing: p1), fallback: "You must have at least %1$@ in your wallet in order to transfer this type of token. Would you like to go to your Ethereum wallet now?")
    }
    /// Insufficient Ethereum Balance
    internal static let insufficientGasTitle = L10n.tr("Localizable", "Send.insufficientGasTitle", fallback: "Insufficient Ethereum Balance")
    /// The destination address is not a valid %1$@ address.
    internal static func invalidAddressMessage(_ p1: Any) -> String {
      return L10n.tr("Localizable", "Send.invalidAddressMessage", String(describing: p1), fallback: "The destination address is not a valid %1$@ address.")
    }
    /// Pasteboard does not contain a valid %1$@ address.
    internal static func invalidAddressOnPasteboard(_ p1: Any) -> String {
      return L10n.tr("Localizable", "Send.invalidAddressOnPasteboard", String(describing: p1), fallback: "Pasteboard does not contain a valid %1$@ address.")
    }
    /// Invalid Address
    internal static let invalidAddressTitle = L10n.tr("Localizable", "Send.invalidAddressTitle", fallback: "Invalid Address")
    /// Sending is disabled during a full rescan.
    internal static let isRescanning = L10n.tr("Localizable", "Send.isRescanning", fallback: "Sending is disabled during a full rescan.")
    /// Warning: this is a legacy bitcoin address. Are you sure you want to send Bitcoin Cash to it?
    internal static let legacyAddressWarning = L10n.tr("Localizable", "Send.legacyAddressWarning", fallback: "Warning: this is a legacy bitcoin address. Are you sure you want to send Bitcoin Cash to it?")
    /// Loading Request
    internal static let loadingRequest = L10n.tr("Localizable", "Send.loadingRequest", fallback: "Loading Request")
    /// Hedera Memo (Optional)
    internal static let memoTagOptional = L10n.tr("Localizable", "Send.memoTag_optional", fallback: "Hedera Memo (Optional)")
    /// Insufficient funds to cover the transaction fee.
    internal static let nilFeeError = L10n.tr("Localizable", "Send.nilFeeError", fallback: "Insufficient funds to cover the transaction fee.")
    /// Please enter the recipient's address.
    internal static let noAddress = L10n.tr("Localizable", "Send.noAddress", fallback: "Please enter the recipient's address.")
    /// Please enter an amount to send.
    internal static let noAmount = L10n.tr("Localizable", "Send.noAmount", fallback: "Please enter an amount to send.")
    /// No fee estimate
    internal static let noFeeEstimate = L10n.tr("Localizable", "Send.NoFeeEstimate", fallback: "No fee estimate")
    /// Network Fee conditions are being downloaded. Please try again.
    internal static let noFeesError = L10n.tr("Localizable", "Send.noFeesError", fallback: "Network Fee conditions are being downloaded. Please try again.")
    /// Paste
    internal static let pasteLabel = L10n.tr("Localizable", "Send.pasteLabel", fallback: "Paste")
    /// Invalid PayString.
    internal static let payIdInvalid = L10n.tr("Localizable", "Send.payId_invalid", fallback: "Invalid PayString.")
    /// There is no %1$s address associated with this PayString.
    internal static func payIdNoAddress(_ p1: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "Send.payId_noAddress", p1, fallback: "There is no %1$s address associated with this PayString.")
    }
    /// There was an error retrieving the address for this PayString. Please try again later.
    internal static let payIdRetrievalError = L10n.tr("Localizable", "Send.payId_retrievalError", fallback: "There was an error retrieving the address for this PayString. Please try again later.")
    /// PayString
    internal static let payIdToLabel = L10n.tr("Localizable", "Send.payId_toLabel", fallback: "PayString")
    /// Could not publish transaction.
    internal static let publishTransactionError = L10n.tr("Localizable", "Send.publishTransactionError", fallback: "Could not publish transaction.")
    /// Could not load payment request
    internal static let remoteRequestError = L10n.tr("Localizable", "Send.remoteRequestError", fallback: "Could not load payment request")
    /// Scan
    internal static let scanLabel = L10n.tr("Localizable", "Send.scanLabel", fallback: "Scan")
    /// Send Error
    internal static let sendError = L10n.tr("Localizable", "Send.sendError", fallback: "Send Error")
    /// Sending Max:
    internal static let sendingMax = L10n.tr("Localizable", "Send.sendingMax", fallback: "Sending Max:")
    /// Send
    internal static let sendLabel = L10n.tr("Localizable", "Send.sendLabel", fallback: "Send")
    /// Send maximum amount?
    internal static let sendMaximum = L10n.tr("Localizable", "Send.sendMaximum", fallback: "Send maximum amount?")
    /// Timed out waiting for network response. Please wait 30 minutes for confirmation before retrying.
    internal static let timeOutBody = L10n.tr("Localizable", "Send.timeOutBody", fallback: "Timed out waiting for network response. Please wait 30 minutes for confirmation before retrying.")
    /// Send
    internal static let title = L10n.tr("Localizable", "Send.title", fallback: "Send")
    /// To
    internal static let toLabel = L10n.tr("Localizable", "Send.toLabel", fallback: "To")
    /// What is a destination tag?
    internal static let whatIsDestinationTag = L10n.tr("Localizable", "Send.WhatIsDestinationTag", fallback: "What is a destination tag?")
    internal enum Error {
      /// Authentication Error
      internal static let authenticationError = L10n.tr("Localizable", "Send.Error.authenticationError", fallback: "Authentication Error")
      /// Could not calculate maximum
      internal static let maxError = L10n.tr("Localizable", "Send.Error.maxError", fallback: "Could not calculate maximum")
    }
    internal enum UsedAddress {
      /// Bitcoin addresses are intended for single use only.
      internal static let firstLine = L10n.tr("Localizable", "Send.UsedAddress.firstLine", fallback: "Bitcoin addresses are intended for single use only.")
      /// Re-use reduces privacy for both you and the recipient and can result in loss if the recipient doesn't directly control the address.
      internal static let secondLIne = L10n.tr("Localizable", "Send.UsedAddress.secondLIne", fallback: "Re-use reduces privacy for both you and the recipient and can result in loss if the recipient doesn't directly control the address.")
      /// Address Already Used
      internal static let title = L10n.tr("Localizable", "Send.UsedAddress.title", fallback: "Address Already Used")
    }
    internal enum CameraUnavailabeMessage {
      /// Allow camera access in "Settings" > "Apps" > "Fabriik" > "Permissions"
      internal static let android = L10n.tr("Localizable", "Send.cameraUnavailabeMessage.android", fallback: "Allow camera access in \"Settings\" > \"Apps\" > \"Fabriik\" > \"Permissions\"")
    }
    internal enum CameraUnavailabeTitle {
      /// Fabriik is not allowed to access the camera
      internal static let android = L10n.tr("Localizable", "Send.cameraUnavailabeTitle.android", fallback: "Fabriik is not allowed to access the camera")
    }
  }
  internal enum Settings {
    /// About
    internal static let about = L10n.tr("Localizable", "Settings.about", fallback: "About")
    /// Advanced
    internal static let advanced = L10n.tr("Localizable", "Settings.advanced", fallback: "Advanced")
    /// Advanced Settings
    internal static let advancedTitle = L10n.tr("Localizable", "Settings.advancedTitle", fallback: "Advanced Settings")
    /// Available in the USA only
    internal static let atmMapMenuItemSubtitle = L10n.tr("Localizable", "Settings.atmMapMenuItemSubtitle", fallback: "Available in the USA only")
    /// Crypto ATM Map
    internal static let atmMapMenuItemTitle = L10n.tr("Localizable", "Settings.atmMapMenuItemTitle", fallback: "Crypto ATM Map")
    /// Display Currency
    internal static let currency = L10n.tr("Localizable", "Settings.currency", fallback: "Display Currency")
    /// %1$@ Settings
    internal static func currencyPageTitle(_ p1: Any) -> String {
      return L10n.tr("Localizable", "Settings.currencyPageTitle", String(describing: p1), fallback: "%1$@ Settings")
    }
    /// Currency Settings
    internal static let currencySettings = L10n.tr("Localizable", "Settings.currencySettings", fallback: "Currency Settings")
    /// Join Early Access
    internal static let earlyAccess = L10n.tr("Localizable", "Settings.earlyAccess", fallback: "Join Early Access")
    /// Enable Segwit
    internal static let enableSegwit = L10n.tr("Localizable", "Settings.EnableSegwit", fallback: "Enable Segwit")
    /// Are you enjoying Fabriik?
    internal static let enjoying = L10n.tr("Localizable", "Settings.enjoying", fallback: "Are you enjoying Fabriik?")
    /// Export transaction history to CSV
    internal static let exportTransfers = L10n.tr("Localizable", "Settings.exportTransfers", fallback: "Export transaction history to CSV")
    /// Face ID Spending Limit
    internal static let faceIdLimit = L10n.tr("Localizable", "Settings.faceIdLimit", fallback: "Face ID Spending Limit")
    /// Redeem Private Key
    internal static let importTitle = L10n.tr("Localizable", "Settings.importTitle", fallback: "Redeem Private Key")
    /// Manage
    internal static let manage = L10n.tr("Localizable", "Settings.manage", fallback: "Manage")
    /// No Log files found. Please try again later.
    internal static let noLogsFound = L10n.tr("Localizable", "Settings.noLogsFound", fallback: "No Log files found. Please try again later.")
    /// Notifications
    internal static let notifications = L10n.tr("Localizable", "Settings.notifications", fallback: "Notifications")
    /// Other
    internal static let other = L10n.tr("Localizable", "Settings.other", fallback: "Other")
    /// Preferences
    internal static let preferences = L10n.tr("Localizable", "Settings.preferences", fallback: "Preferences")
    /// Reset to Default Currencies
    internal static let resetCurrencies = L10n.tr("Localizable", "Settings.resetCurrencies", fallback: "Reset to Default Currencies")
    /// Leave us a Review
    internal static let review = L10n.tr("Localizable", "Settings.review", fallback: "Leave us a Review")
    /// Rewards
    internal static let rewards = L10n.tr("Localizable", "Settings.rewards", fallback: "Rewards")
    /// Share Anonymous Data
    internal static let shareData = L10n.tr("Localizable", "Settings.shareData", fallback: "Share Anonymous Data")
    /// Share portfolio data with widgets
    internal static let shareWithWidget = L10n.tr("Localizable", "Settings.shareWithWidget", fallback: "Share portfolio data with widgets")
    /// Sync Blockchain
    internal static let sync = L10n.tr("Localizable", "Settings.sync", fallback: "Sync Blockchain")
    /// Menu
    internal static let title = L10n.tr("Localizable", "Settings.title", fallback: "Menu")
    /// Touch ID Spending Limit
    internal static let touchIdLimit = L10n.tr("Localizable", "Settings.touchIdLimit", fallback: "Touch ID Spending Limit")
    /// View Legacy Receive Address
    internal static let viewLegacyAddress = L10n.tr("Localizable", "Settings.ViewLegacyAddress", fallback: "View Legacy Receive Address")
    /// Only send Bitcoin (BTC) to this address. Any other asset sent to this address will be lost permanently.
    internal static let viewLegacyAddressReceiveDescription = L10n.tr("Localizable", "Settings.ViewLegacyAddressReceiveDescription", fallback: "Only send Bitcoin (BTC) to this address. Any other asset sent to this address will be lost permanently.")
    /// Receive Bitcoin
    internal static let viewLegacyAddressReceiveTitle = L10n.tr("Localizable", "Settings.ViewLegacyAddressReceiveTitle", fallback: "Receive Bitcoin")
    /// Wallets
    internal static let wallet = L10n.tr("Localizable", "Settings.wallet", fallback: "Wallets")
    /// Unlink from this device
    internal static let wipe = L10n.tr("Localizable", "Settings.wipe", fallback: "Unlink from this device")
    internal enum TouchIdLimit {
      /// Fingerprint Authentication Spending Limit
      internal static let android = L10n.tr("Localizable", "Settings.touchIdLimit.android", fallback: "Fingerprint Authentication Spending Limit")
    }
    internal enum Wipe {
      /// Wipe wallet from this device
      internal static let android = L10n.tr("Localizable", "Settings.wipe.android", fallback: "Wipe wallet from this device")
    }
  }
  internal enum ShareData {
    /// Help improve Fabriik by sharing your anonymous data with us. This does not include any financial information. We respect your financial privacy.
    internal static let body = L10n.tr("Localizable", "ShareData.body", fallback: "Help improve Fabriik by sharing your anonymous data with us. This does not include any financial information. We respect your financial privacy.")
    /// Share Data?
    internal static let header = L10n.tr("Localizable", "ShareData.header", fallback: "Share Data?")
    /// Share Anonymous Data?
    internal static let toggleLabel = L10n.tr("Localizable", "ShareData.toggleLabel", fallback: "Share Anonymous Data?")
  }
  internal enum ShareGift {
    /// Approximate Total
    internal static let approximateTotal = L10n.tr("Localizable", "ShareGift.approximateTotal", fallback: "Approximate Total")
    /// A network fee will be deducted from the total when claimed.
    /// Actual value depends on current price of bitcoin.
    internal static let footerMessage1 = L10n.tr("Localizable", "ShareGift.footerMessage1", fallback: "A network fee will be deducted from the total when claimed.\nActual value depends on current price of bitcoin.")
    /// Download the Fabriik app for iPhone or Android.
    /// For more information visit Fabriik.com/gift
    internal static let footerMessage2 = L10n.tr("Localizable", "ShareGift.footerMessage2", fallback: "Download the Fabriik app for iPhone or Android.\nFor more information visit Fabriik.com/gift")
    /// Someone gifted you bitcoin!
    internal static let tagLine = L10n.tr("Localizable", "ShareGift.tagLine", fallback: "Someone gifted you bitcoin!")
    /// Bitcoin
    internal static let walletName = L10n.tr("Localizable", "ShareGift.walletName", fallback: "Bitcoin")
  }
  internal enum Staking {
    /// + Select Baker
    internal static let add = L10n.tr("Localizable", "Staking.add", fallback: "+ Select Baker")
    /// Free Space
    internal static let cellFreeSpaceHeader = L10n.tr("Localizable", "Staking.cellFreeSpaceHeader", fallback: "Free Space")
    /// Change
    internal static let changeValidator = L10n.tr("Localizable", "Staking.changeValidator", fallback: "Change")
    /// Delegate your Tezos account to a validator to earn a reward while keeping full security and control of your coins.
    internal static let descriptionTezos = L10n.tr("Localizable", "Staking.descriptionTezos", fallback: "Delegate your Tezos account to a validator to earn a reward while keeping full security and control of your coins.")
    /// Fee:
    internal static let feeHeader = L10n.tr("Localizable", "Staking.feeHeader", fallback: "Fee:")
    /// Transaction pending...
    internal static let pendingTransaction = L10n.tr("Localizable", "Staking.pendingTransaction", fallback: "Transaction pending...")
    /// Remove
    internal static let remove = L10n.tr("Localizable", "Staking.remove", fallback: "Remove")
    /// Est. ROI
    internal static let roiHeader = L10n.tr("Localizable", "Staking.roiHeader", fallback: "Est. ROI")
    /// Select XTZ Delegate
    internal static let selectBakerTitle = L10n.tr("Localizable", "Staking.selectBakerTitle", fallback: "Select XTZ Delegate")
    /// Stake
    internal static let stake = L10n.tr("Localizable", "Staking.stake", fallback: "Stake")
    /// ACTIVE
    internal static let stakingActiveFlag = L10n.tr("Localizable", "Staking.stakingActiveFlag", fallback: "ACTIVE")
    /// INACTIVE
    internal static let stakingInactiveFlag = L10n.tr("Localizable", "Staking.stakingInactiveFlag", fallback: "INACTIVE")
    /// PENDING
    internal static let stakingPendingFlag = L10n.tr("Localizable", "Staking.stakingPendingFlag", fallback: "PENDING")
    /// Staking
    internal static let stakingTitle = L10n.tr("Localizable", "Staking.stakingTitle", fallback: "Staking")
    /// staking to %1$s
    internal static func stakingTo(_ p1: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "Staking.stakingTo", p1, fallback: "staking to %1$s")
    }
    /// Pending
    internal static let statusPending = L10n.tr("Localizable", "Staking.statusPending", fallback: "Pending")
    /// Staked!
    internal static let statusStaked = L10n.tr("Localizable", "Staking.statusStaked", fallback: "Staked!")
    /// Earn money while holding
    internal static let subTitle = L10n.tr("Localizable", "Staking.subTitle", fallback: "Earn money while holding")
    /// Tezos & Dune
    internal static let tezosDune = L10n.tr("Localizable", "Staking.tezosDune", fallback: "Tezos & Dune")
    /// Multiasset Pool
    internal static let tezosMultiasset = L10n.tr("Localizable", "Staking.tezosMultiasset", fallback: "Multiasset Pool")
    /// Tezos-only
    internal static let tezosOnly = L10n.tr("Localizable", "Staking.tezosOnly", fallback: "Tezos-only")
    /// Stake %1$s
    internal static func title(_ p1: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "Staking.title", p1, fallback: "Stake %1$s")
    }
    /// Unstake
    internal static let unstake = L10n.tr("Localizable", "Staking.unstake", fallback: "Unstake")
    /// Enter Validator Address
    internal static let validatorHint = L10n.tr("Localizable", "Staking.validatorHint", fallback: "Enter Validator Address")
  }
  internal enum StartPaperPhrase {
    /// Write Down Recovery Phrase Again
    internal static let againButtonTitle = L10n.tr("Localizable", "StartPaperPhrase.againButtonTitle", fallback: "Write Down Recovery Phrase Again")
    /// Your recovery phrase is the only way to restore your Fabriik if your phone is lost, stolen, broken, or upgraded.
    /// 
    /// We will show you a list of words to write down on a piece of paper and keep safe.
    internal static let body = L10n.tr("Localizable", "StartPaperPhrase.body", fallback: "Your recovery phrase is the only way to restore your Fabriik if your phone is lost, stolen, broken, or upgraded.\n\nWe will show you a list of words to write down on a piece of paper and keep safe.")
    /// Write Down Recovery Phrase
    internal static let buttonTitle = L10n.tr("Localizable", "StartPaperPhrase.buttonTitle", fallback: "Write Down Recovery Phrase")
    /// Last written down on
    ///  %1$@
    internal static func date(_ p1: Any) -> String {
      return L10n.tr("Localizable", "StartPaperPhrase.date", String(describing: p1), fallback: "Last written down on\n %1$@")
    }
    internal enum Body {
      /// Your recovery phrase is the only way to restore your Fabriik if your phone is lost, stolen, broken, or upgraded.
      /// 
      /// Your recovery phrase is also required if you change the security settings on your device.
      /// 
      /// We will show you a list of words to write down on a piece of paper and keep safe.
      internal static let android = L10n.tr("Localizable", "StartPaperPhrase.Body.Android", fallback: "Your recovery phrase is the only way to restore your Fabriik if your phone is lost, stolen, broken, or upgraded.\n\nYour recovery phrase is also required if you change the security settings on your device.\n\nWe will show you a list of words to write down on a piece of paper and keep safe.")
    }
  }
  internal enum StartViewController {
    /// Create New Wallet
    internal static let createButton = L10n.tr("Localizable", "StartViewController.createButton", fallback: "Create New Wallet")
    /// Moving money forward.
    internal static let message = L10n.tr("Localizable", "StartViewController.message", fallback: "Moving money forward.")
    /// Recover Wallet
    internal static let recoverButton = L10n.tr("Localizable", "StartViewController.recoverButton", fallback: "Recover Wallet")
  }
  internal enum SupportForm {
    /// We would love your feedback
    internal static let feedbackAppreciated = L10n.tr("Localizable", "SupportForm.feedbackAppreciated", fallback: "We would love your feedback")
    /// Help us improve
    internal static let helpUsImprove = L10n.tr("Localizable", "SupportForm.helpUsImprove", fallback: "Help us improve")
    /// Not now
    internal static let notNow = L10n.tr("Localizable", "SupportForm.notNow", fallback: "Not now")
    /// Please describe your experience
    internal static let pleaseDescribe = L10n.tr("Localizable", "SupportForm.pleaseDescribe", fallback: "Please describe your experience")
  }
  internal enum Swap {
    /// Add item!
    internal static let addItem = L10n.tr("Localizable", "Swap.AddItem", fallback: "Add item!")
    /// Amount purchased
    internal static let amountPurchased = L10n.tr("Localizable", "Swap.AmountPurchased", fallback: "Amount purchased")
    /// Back to Home
    internal static let backToHome = L10n.tr("Localizable", "Swap.BackToHome", fallback: "Back to Home")
    /// I have %@ %@
    internal static func balance(_ p1: Any, _ p2: Any) -> String {
      return L10n.tr("Localizable", "Swap.Balance", String(describing: p1), String(describing: p2), fallback: "I have %@ %@")
    }
    /// Card fee
    internal static let cardFee = L10n.tr("Localizable", "Swap.CardFee", fallback: "Card fee")
    /// Check your assets!
    internal static let checkAssets = L10n.tr("Localizable", "Swap.CheckAssets", fallback: "Check your assets!")
<<<<<<< HEAD
    /// Text body in check your assets popup
    internal static let checkAssetsBody = L10n.tr("Localizable", "Swap.CheckAssetsBody", fallback: "In order to successfully perform a swap, make sure you have two or more of our supported swap assets (BSV, BTC, ETH, BCH, SHIB, USDT) activated and funded within your wallet.")
    /// Swap details title
=======
    /// In order to successfully perform a swap, make sure you have two or more of our supported swap assets (BSV, BTC, ETH, BCH, SHIB, USDT) activated and funded within your wallet.
    internal static let checkAssetsBody = L10n.tr("Localizable", "Swap.CheckAssetsBody", fallback: "In order to successfully perform a swap, make sure you have two or more of our supported swap assets (BSV, BTC, ETH, BCH, SHIB, USDT) activated and funded within your wallet.")
    /// Swap details
>>>>>>> mit
    internal static let details = L10n.tr("Localizable", "Swap.Details", fallback: "Swap details")
    /// There was an error while processing your transaction
    internal static let errorProcessingTransaction = L10n.tr("Localizable", "Swap.ErrorProcessingTransaction", fallback: "There was an error while processing your transaction")
    /// Please try swapping again or come back later.
    internal static let failureSwapMessage = L10n.tr("Localizable", "Swap.FailureSwapMessage", fallback: "Please try swapping again or come back later.")
    /// Got it!
    internal static let gotItButton = L10n.tr("Localizable", "Swap.GotItButton", fallback: "Got it!")
    /// I want
    internal static let iWant = L10n.tr("Localizable", "Swap.iWant", fallback: "I want")
    /// Mining network fee
    internal static let miningNetworkFee = L10n.tr("Localizable", "Swap.MiningNetworkFee", fallback: "Mining network fee")
    /// Not a valid pair
    internal static let notValidPair = L10n.tr("Localizable", "Swap.NotValidPair", fallback: "Not a valid pair")
    /// Paid with
    internal static let paidWith = L10n.tr("Localizable", "Swap.PaidWith", fallback: "Paid with")
    /// Rate:
    internal static let rate = L10n.tr("Localizable", "Swap.Rate", fallback: "Rate:")
    /// Rate
    internal static let rateValue = L10n.tr("Localizable", "Swap.RateValue", fallback: "Rate")
    /// Receiving network fee
    /// (included)
    internal static let receiveNetworkFee = L10n.tr("Localizable", "Swap.ReceiveNetworkFee", fallback: "Receiving network fee\n(included)")
    /// Receiving fee
    /// 
    internal static let receivingFee = L10n.tr("Localizable", "Swap.ReceivingFee", fallback: "Receiving fee\n")
    /// Your swap request timed out. Please try again.
    internal static let requestTimedOut = L10n.tr("Localizable", "Swap.RequestTimedOut", fallback: "Your swap request timed out. Please try again.")
<<<<<<< HEAD
    /// Select assets title in swap flow
=======
    /// Select assets
>>>>>>> mit
    internal static let selectAssets = L10n.tr("Localizable", "Swap.SelectAssets", fallback: "Select assets")
    /// Sending fee
    /// 
    internal static let sendingFee = L10n.tr("Localizable", "Swap.SendingFee", fallback: "Sending fee\n")
    /// Sending network fee
    /// (included)
    internal static let sendNetworkFee = L10n.tr("Localizable", "Swap.SendNetworkFee", fallback: "Sending network fee\n(included)")
    /// Sending network fee
    /// (not included)
    internal static let sendNetworkFeeNotIncluded = L10n.tr("Localizable", "Swap.sendNetworkFeeNotIncluded", fallback: "Sending network fee\n(not included)")
    /// Swap again
    internal static let swapAgain = L10n.tr("Localizable", "Swap.SwapAgain", fallback: "Swap again")
<<<<<<< HEAD
    /// Swap min and max limit text
    internal static func swapLimits(_ p1: UnsafePointer<CChar>, _ p2: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "Swap.SwapLimits", p1, p2, fallback: "Currently, minimum limit for swap is $%s USD and maximum limit is $%s USD/day.")
    }
    /// Swapping %1$s/%2$s
    internal static func swapping(_ p1: UnsafePointer<CChar>, _ p2: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "Swap.Swapping", p1, p2, fallback: "Swapping %1$s/%2$s")
    }
    /// Swap status message on swap flow
    internal static func swapStatus(_ p1: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "Swap.SwapStatus", p1, fallback: "Your %s is estimated to arrive in 30 minutes. You can continue to use your wallet. We'll let you know when your swap has finished.")
    }
    /// Swap is temporarily unavailable
    internal static let temporarilyUnavailable = L10n.tr("Localizable", "Swap.temporarilyUnavailable", fallback: "Swap is temporarily unavailable")
    /// Timestamp label in swap details screen
=======
    /// Currently, minimum limit for swap is $%s USD and maximum limit is $%s USD/day.
    internal static func swapLimits(_ p1: UnsafePointer<CChar>, _ p2: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "Swap.SwapLimits", p1, p2, fallback: "Currently, minimum limit for swap is $%s USD and maximum limit is $%s USD/day.")
    }
    /// Swapping %1$s/%2$s
    internal static func swapping(_ p1: UnsafePointer<CChar>, _ p2: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "Swap.Swapping", p1, p2, fallback: "Swapping %1$s/%2$s")
    }
    /// Your %s is estimated to arrive in 30 minutes. You can continue to use your wallet. We'll let you know when your swap has finished.
    internal static func swapStatus(_ p1: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "Swap.SwapStatus", p1, fallback: "Your %s is estimated to arrive in 30 minutes. You can continue to use your wallet. We'll let you know when your swap has finished.")
    }
    /// Swap is temporarily unavailable
    internal static let temporarilyUnavailable = L10n.tr("Localizable", "Swap.temporarilyUnavailable", fallback: "Swap is temporarily unavailable")
    /// Timestamp
>>>>>>> mit
    internal static let timestamp = L10n.tr("Localizable", "Swap.Timestamp", fallback: "Timestamp")
    /// Total:
    internal static let total = L10n.tr("Localizable", "Swap.Total", fallback: "Total:")
    /// From %1$s
    internal static func transactionFrom(_ p1: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "Swap.transactionFrom", p1, fallback: "From %1$s")
    }
<<<<<<< HEAD
    /// Transaction ID label in swap details screen
=======
    /// Fabriik Transaction ID
>>>>>>> mit
    internal static let transactionID = L10n.tr("Localizable", "Swap.TransactionID", fallback: "Fabriik Transaction ID")
    /// It seems that your transaction takes place in the Ethereum network, please keep in mind that network fees will be charged in ETH
    internal static let transactionInEthereumNetwork = L10n.tr("Localizable", "Swap.transactionInEthereumNetwork", fallback: "It seems that your transaction takes place in the Ethereum network, please keep in mind that network fees will be charged in ETH")
    /// To %1$s
    internal static func transactionTo(_ p1: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "Swap.transactionTo", p1, fallback: "To %1$s")
    }
    internal enum AmountPurchased {
      /// Amount purchased:
      internal static let android = L10n.tr("Localizable", "Swap.AmountPurchased.android", fallback: "Amount purchased:")
    }
    internal enum CardFee {
      /// Card fee:
      internal static let android = L10n.tr("Localizable", "Swap.CardFee.android", fallback: "Card fee:")
    }
    internal enum MiningNetworkFee {
      /// Mining network fee:
      internal static let android = L10n.tr("Localizable", "Swap.MiningNetworkFee.android", fallback: "Mining network fee:")
    }
  }
  internal enum Symbols {
    /// u{1F512}
    internal static let lock = L10n.tr("Localizable", "Symbols.lock", fallback: "u{1F512}")
    /// u{2009}
    internal static let narrowSpace = L10n.tr("Localizable", "Symbols.narrowSpace", fallback: "u{2009}")
  }
  internal enum SyncingView {
    /// Activity
    internal static let activity = L10n.tr("Localizable", "SyncingView.activity", fallback: "Activity")
    /// Connecting
    internal static let connecting = L10n.tr("Localizable", "SyncingView.connecting", fallback: "Connecting")
    /// Sync Failed
    internal static let failed = L10n.tr("Localizable", "SyncingView.failed", fallback: "Sync Failed")
    /// Syncing
    internal static let header = L10n.tr("Localizable", "SyncingView.header", fallback: "Syncing")
    /// Retry
    internal static let retry = L10n.tr("Localizable", "SyncingView.retry", fallback: "Retry")
    /// Synced through %1$@
    internal static func syncedThrough(_ p1: Any) -> String {
      return L10n.tr("Localizable", "SyncingView.syncedThrough", String(describing: p1), fallback: "Synced through %1$@")
    }
    /// Syncing
    internal static let syncing = L10n.tr("Localizable", "SyncingView.syncing", fallback: "Syncing")
  }
  internal enum TimeSince {
    /// %1$@ d
    internal static func days(_ p1: Any) -> String {
      return L10n.tr("Localizable", "TimeSince.days", String(describing: p1), fallback: "%1$@ d")
    }
    /// %1$@ h
    internal static func hours(_ p1: Any) -> String {
      return L10n.tr("Localizable", "TimeSince.hours", String(describing: p1), fallback: "%1$@ h")
    }
    /// %1$@ m
    internal static func minutes(_ p1: Any) -> String {
      return L10n.tr("Localizable", "TimeSince.minutes", String(describing: p1), fallback: "%1$@ m")
    }
    /// %1$@ s
    internal static func seconds(_ p1: Any) -> String {
      return L10n.tr("Localizable", "TimeSince.seconds", String(describing: p1), fallback: "%1$@ s")
    }
  }
  internal enum TokenList {
    /// Add
    internal static let add = L10n.tr("Localizable", "TokenList.add", fallback: "Add")
    /// Add Assets
    internal static let addTitle = L10n.tr("Localizable", "TokenList.addTitle", fallback: "Add Assets")
    /// Hide
    internal static let hide = L10n.tr("Localizable", "TokenList.hide", fallback: "Hide")
    /// Manage Assets
    internal static let manageTitle = L10n.tr("Localizable", "TokenList.manageTitle", fallback: "Manage Assets")
    /// Remove
    internal static let remove = L10n.tr("Localizable", "TokenList.remove", fallback: "Remove")
    /// Show
    internal static let show = L10n.tr("Localizable", "TokenList.show", fallback: "Show")
  }
  internal enum TouchIdSettings {
    /// You can customize your Touch ID spending limit from the %1$@.
    internal static func customizeText(_ p1: Any) -> String {
      return L10n.tr("Localizable", "TouchIdSettings.customizeText", String(describing: p1), fallback: "You can customize your Touch ID spending limit from the %1$@.")
    }
    /// Use Touch ID to unlock your Fabriik app and send money.
    internal static let explanatoryText = L10n.tr("Localizable", "TouchIdSettings.explanatoryText", fallback: "Use Touch ID to unlock your Fabriik app and send money.")
    /// Use your fingerprint to unlock your Fabriik and send money up to a set limit.
    internal static let label = L10n.tr("Localizable", "TouchIdSettings.label", fallback: "Use your fingerprint to unlock your Fabriik and send money up to a set limit.")
    /// Touch ID Spending Limit Screen
    internal static let linkText = L10n.tr("Localizable", "TouchIdSettings.linkText", fallback: "Touch ID Spending Limit Screen")
    /// Spending limit: %1$@ (%2$@)
    internal static func spendingLimit(_ p1: Any, _ p2: Any) -> String {
      return L10n.tr("Localizable", "TouchIdSettings.spendingLimit", String(describing: p1), String(describing: p2), fallback: "Spending limit: %1$@ (%2$@)")
    }
    /// Enable Touch ID for Fabriik
    internal static let switchLabel = L10n.tr("Localizable", "TouchIdSettings.switchLabel", fallback: "Enable Touch ID for Fabriik")
    /// Touch ID
    internal static let title = L10n.tr("Localizable", "TouchIdSettings.title", fallback: "Touch ID")
    /// Enable Touch ID to send money
    internal static let transactionsTitleText = L10n.tr("Localizable", "TouchIdSettings.transactionsTitleText", fallback: "Enable Touch ID to send money")
    /// You have not set up Touch ID on this device. Go to Settings->Touch ID & Passcode to set it up now.
    internal static let unavailableAlertMessage = L10n.tr("Localizable", "TouchIdSettings.unavailableAlertMessage", fallback: "You have not set up Touch ID on this device. Go to Settings->Touch ID & Passcode to set it up now.")
    /// Touch ID Not Set Up
    internal static let unavailableAlertTitle = L10n.tr("Localizable", "TouchIdSettings.unavailableAlertTitle", fallback: "Touch ID Not Set Up")
    /// Enable Touch ID to unlock Fabriik
    internal static let unlockTitleText = L10n.tr("Localizable", "TouchIdSettings.unlockTitleText", fallback: "Enable Touch ID to unlock Fabriik")
    internal enum CustomizeText {
      /// You can customize your Fingerprint Authentication Spending Limit from the Fingerprint Authorization Spending Limit screen
      internal static let android = L10n.tr("Localizable", "TouchIdSettings.customizeText.android", fallback: "You can customize your Fingerprint Authentication Spending Limit from the Fingerprint Authorization Spending Limit screen")
    }
    internal enum DisabledWarning {
      internal enum Body {
        /// You have not enabled fingerprint authentication on this device. Go to Settings -> Security to set up fingerprint authentication.
        internal static let android = L10n.tr("Localizable", "TouchIdSettings.disabledWarning.body.android", fallback: "You have not enabled fingerprint authentication on this device. Go to Settings -> Security to set up fingerprint authentication.")
      }
      internal enum Title {
        /// Fingerprint Authentication Not Enabled
        internal static let android = L10n.tr("Localizable", "TouchIdSettings.disabledWarning.title.android", fallback: "Fingerprint Authentication Not Enabled")
      }
    }
    internal enum SwitchLabel {
      /// Enable Fingerprint Authentication
      internal static let android = L10n.tr("Localizable", "TouchIdSettings.switchLabel.android", fallback: "Enable Fingerprint Authentication")
    }
    internal enum Title {
      /// Fingerprint Authentication
      internal static let android = L10n.tr("Localizable", "TouchIdSettings.title.android", fallback: "Fingerprint Authentication")
    }
  }
  internal enum TouchIdSpendingLimit {
    /// You will be asked to enter your 6-digit PIN to send any transaction over your spending limit, and every 48 hours since the last time you entered your 6-digit PIN.
    internal static let body = L10n.tr("Localizable", "TouchIdSpendingLimit.body", fallback: "You will be asked to enter your 6-digit PIN to send any transaction over your spending limit, and every 48 hours since the last time you entered your 6-digit PIN.")
    /// Touch ID Spending Limit
    internal static let title = L10n.tr("Localizable", "TouchIdSpendingLimit.title", fallback: "Touch ID Spending Limit")
    internal enum Title {
      /// Fingerprint Authorization Spending Limit
      internal static let android = L10n.tr("Localizable", "TouchIdSpendingLimit.title.android", fallback: "Fingerprint Authorization Spending Limit")
    }
  }
  internal enum Transaction {
    /// Available to Spend
    internal static let available = L10n.tr("Localizable", "Transaction.available", fallback: "Available to Spend")
    /// Complete
    internal static let complete = L10n.tr("Localizable", "Transaction.complete", fallback: "Complete")
    /// In Progress
    internal static let confirming = L10n.tr("Localizable", "Transaction.confirming", fallback: "In Progress")
    /// Ending balance: %1$@
    internal static func ending(_ p1: Any) -> String {
      return L10n.tr("Localizable", "Transaction.ending", String(describing: p1), fallback: "Ending balance: %1$@")
    }
    /// Exchange rate when received:
    internal static let exchangeOnDayReceived = L10n.tr("Localizable", "Transaction.exchangeOnDayReceived", fallback: "Exchange rate when received:")
    /// Exchange rate when sent:
    internal static let exchangeOnDaySent = L10n.tr("Localizable", "Transaction.exchangeOnDaySent", fallback: "Exchange rate when sent:")
    /// Failed
    internal static let failed = L10n.tr("Localizable", "Transaction.failed", fallback: "Failed")
    /// Failed swap
    internal static let failedSwap = L10n.tr("Localizable", "Transaction.FailedSwap", fallback: "Failed swap")
    /// (%1$@ fee)
    internal static func fee(_ p1: Any) -> String {
      return L10n.tr("Localizable", "Transaction.fee", String(describing: p1), fallback: "(%1$@ fee)")
    }
    /// INVALID
    internal static let invalid = L10n.tr("Localizable", "Transaction.invalid", fallback: "INVALID")
    /// just now
    internal static let justNow = L10n.tr("Localizable", "Transaction.justNow", fallback: "just now")
    /// Manually settled
    internal static let manuallySettled = L10n.tr("Localizable", "Transaction.ManuallySettled", fallback: "Manually settled")
    /// Pending
    internal static let pending = L10n.tr("Localizable", "Transaction.pending", fallback: "Pending")
    /// Pending purchase
    internal static let pendingPurchase = L10n.tr("Localizable", "Transaction.PendingPurchase", fallback: "Pending purchase")
    /// Pending swap
    internal static let pendingSwap = L10n.tr("Localizable", "Transaction.PendingSwap", fallback: "Pending swap")
    /// Purchased
    internal static let purchased = L10n.tr("Localizable", "Transaction.Purchased", fallback: "Purchased")
    /// Purchase failed
    internal static let purchaseFailed = L10n.tr("Localizable", "Transaction.PurchaseFailed", fallback: "Purchase failed")
    /// In progress: %1$@
    internal static func receivedStatus(_ p1: Any) -> String {
      return L10n.tr("Localizable", "Transaction.receivedStatus", String(describing: p1), fallback: "In progress: %1$@")
    }
    /// Refunded
    internal static let refunded = L10n.tr("Localizable", "Transaction.refunded", fallback: "Refunded")
    /// In progress: %1$@
    internal static func sendingStatus(_ p1: Any) -> String {
      return L10n.tr("Localizable", "Transaction.sendingStatus", String(describing: p1), fallback: "In progress: %1$@")
    }
    /// sending to %1$@
    internal static func sendingTo(_ p1: Any) -> String {
      return L10n.tr("Localizable", "Transaction.sendingTo", String(describing: p1), fallback: "sending to %1$@")
    }
    /// sent to %1$@
    internal static func sentTo(_ p1: Any) -> String {
      return L10n.tr("Localizable", "Transaction.sentTo", String(describing: p1), fallback: "sent to %1$@")
    }
    /// staking to %1$s
    internal static func stakingTo(_ p1: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "Transaction.stakingTo", p1, fallback: "staking to %1$s")
    }
    /// Starting balance: %1$@
    internal static func starting(_ p1: Any) -> String {
      return L10n.tr("Localizable", "Transaction.starting", String(describing: p1), fallback: "Starting balance: %1$@")
    }
    /// Swap from %s failed
    internal static func swapFromFailed(_ p1: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "Transaction.swapFromFailed", p1, fallback: "Swap from %s failed")
    }
<<<<<<< HEAD
    /// Swapped transaction label
=======
    /// Swapped
>>>>>>> mit
    internal static let swapped = L10n.tr("Localizable", "Transaction.Swapped", fallback: "Swapped")
    /// Swapped from %s
    internal static func swappedFrom(_ p1: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "Transaction.swappedFrom", p1, fallback: "Swapped from %s")
    }
    /// Swapped to %s
    internal static func swappedTo(_ p1: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "Transaction.swappedTo", p1, fallback: "Swapped to %s")
    }
    /// Swapping from %s
    internal static func swappingFrom(_ p1: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "Transaction.swappingFrom", p1, fallback: "Swapping from %s")
    }
    /// Swapping to %s
    internal static func swappingTo(_ p1: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "Transaction.swappingTo", p1, fallback: "Swapping to %s")
    }
    /// Swap to %s failed
    internal static func swapToFailed(_ p1: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "Transaction.swapToFailed", p1, fallback: "Swap to %s failed")
    }
<<<<<<< HEAD
    /// e.g. "[The money you paid was a] Fee for token transfer: BRD" (BRD is the token that was transfered)
=======
    /// Fee for token transfer: %1$@
>>>>>>> mit
    internal static func tokenTransfer(_ p1: Any) -> String {
      return L10n.tr("Localizable", "Transaction.tokenTransfer", String(describing: p1), fallback: "Fee for token transfer: %1$@")
    }
    /// to %1$s
    internal static func toRecipient(_ p1: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "Transaction.toRecipient", p1, fallback: "to %1$s")
    }
    /// Waiting to be confirmed. Some merchants require confirmation to complete a transaction. Estimated time: 1-2 hours.
    internal static let waiting = L10n.tr("Localizable", "Transaction.waiting", fallback: "Waiting to be confirmed. Some merchants require confirmation to complete a transaction. Estimated time: 1-2 hours.")
  }
  internal enum TransactionDetails {
    /// account
    internal static let account = L10n.tr("Localizable", "TransactionDetails.account", fallback: "account")
    /// From
    internal static let addressFromHeader = L10n.tr("Localizable", "TransactionDetails.addressFromHeader", fallback: "From")
    /// To
    internal static let addressToHeader = L10n.tr("Localizable", "TransactionDetails.addressToHeader", fallback: "To")
    /// Via
    internal static let addressViaHeader = L10n.tr("Localizable", "TransactionDetails.addressViaHeader", fallback: "Via")
    /// Amount
    internal static let amountHeader = L10n.tr("Localizable", "TransactionDetails.amountHeader", fallback: "Amount")
    /// %1$@ when received, %2$@ now
    internal static func amountWhenReceived(_ p1: Any, _ p2: Any) -> String {
      return L10n.tr("Localizable", "TransactionDetails.amountWhenReceived", String(describing: p1), String(describing: p2), fallback: "%1$@ when received, %2$@ now")
    }
    /// %1$@ when sent, %2$@ now
    internal static func amountWhenSent(_ p1: Any, _ p2: Any) -> String {
      return L10n.tr("Localizable", "TransactionDetails.amountWhenSent", String(describing: p1), String(describing: p2), fallback: "%1$@ when sent, %2$@ now")
    }
    /// Confirmed in Block
    internal static let blockHeightLabel = L10n.tr("Localizable", "TransactionDetails.blockHeightLabel", fallback: "Confirmed in Block")
    /// Memo
    internal static let commentsHeader = L10n.tr("Localizable", "TransactionDetails.commentsHeader", fallback: "Memo")
    /// Add memo...
    internal static let commentsPlaceholder = L10n.tr("Localizable", "TransactionDetails.commentsPlaceholder", fallback: "Add memo...")
    /// Complete
    internal static let completeTimestampHeader = L10n.tr("Localizable", "TransactionDetails.completeTimestampHeader", fallback: "Complete")
    /// Confirmations
    internal static let confirmationsLabel = L10n.tr("Localizable", "TransactionDetails.confirmationsLabel", fallback: "Confirmations")
    /// Destination Tag
    internal static let destinationTag = L10n.tr("Localizable", "TransactionDetails.destinationTag", fallback: "Destination Tag")
    /// (empty)
    internal static let destinationTagEmptyHint = L10n.tr("Localizable", "TransactionDetails.destinationTag_EmptyHint", fallback: "(empty)")
    /// Your transactions will appear here.
    internal static let emptyMessage = L10n.tr("Localizable", "TransactionDetails.emptyMessage", fallback: "Your transactions will appear here.")
    /// Ending Balance
    internal static let endingBalanceHeader = L10n.tr("Localizable", "TransactionDetails.endingBalanceHeader", fallback: "Ending Balance")
    /// Exchange Rate
    internal static let exchangeRateHeader = L10n.tr("Localizable", "TransactionDetails.exchangeRateHeader", fallback: "Exchange Rate")
    /// Total Fee
    internal static let feeHeader = L10n.tr("Localizable", "TransactionDetails.feeHeader", fallback: "Total Fee")
    /// at %1$@
    internal static func from(_ p1: Any) -> String {
      return L10n.tr("Localizable", "TransactionDetails.from", String(describing: p1), fallback: "at %1$@")
    }
    /// Gas Limit
    internal static let gasLimitHeader = L10n.tr("Localizable", "TransactionDetails.gasLimitHeader", fallback: "Gas Limit")
    /// Gas Price
    internal static let gasPriceHeader = L10n.tr("Localizable", "TransactionDetails.gasPriceHeader", fallback: "Gas Price")
    /// Gift
    internal static let gift = L10n.tr("Localizable", "TransactionDetails.gift", fallback: "Gift")
    /// Gifted to %1$s
    internal static func giftedTo(_ p1: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "TransactionDetails.giftedTo", p1, fallback: "Gifted to %1$s")
    }
    /// Hedera Memo
    internal static let hederaMemo = L10n.tr("Localizable", "TransactionDetails.hederaMemo", fallback: "Hedera Memo")
    /// Hide Details
    internal static let hideDetails = L10n.tr("Localizable", "TransactionDetails.hideDetails", fallback: "Hide Details")
    /// Initialized
    internal static let initializedTimestampHeader = L10n.tr("Localizable", "TransactionDetails.initializedTimestampHeader", fallback: "Initialized")
    /// More...
    internal static let more = L10n.tr("Localizable", "TransactionDetails.more", fallback: "More...")
    /// Moved %1$@
    internal static func moved(_ p1: Any) -> String {
      return L10n.tr("Localizable", "TransactionDetails.moved", String(describing: p1), fallback: "Moved %1$@")
    }
    /// Moved <b>%1$@</b>
    internal static func movedAmountDescription(_ p1: Any) -> String {
      return L10n.tr("Localizable", "TransactionDetails.movedAmountDescription", String(describing: p1), fallback: "Moved <b>%1$@</b>")
    }
    /// Not Confirmed
    internal static let notConfirmedBlockHeightLabel = L10n.tr("Localizable", "TransactionDetails.notConfirmedBlockHeightLabel", fallback: "Not Confirmed")
    /// Received %1$@
    internal static func received(_ p1: Any) -> String {
      return L10n.tr("Localizable", "TransactionDetails.received", String(describing: p1), fallback: "Received %1$@")
    }
    /// Received <b>%1$@</b>
    internal static func receivedAmountDescription(_ p1: Any) -> String {
      return L10n.tr("Localizable", "TransactionDetails.receivedAmountDescription", String(describing: p1), fallback: "Received <b>%1$@</b>")
    }
    /// received from %1$@
    internal static func receivedFrom(_ p1: Any) -> String {
      return L10n.tr("Localizable", "TransactionDetails.receivedFrom", String(describing: p1), fallback: "received from %1$@")
    }
    /// received via %1$@
    internal static func receivedVia(_ p1: Any) -> String {
      return L10n.tr("Localizable", "TransactionDetails.receivedVia", String(describing: p1), fallback: "received via %1$@")
    }
    /// receiving from %1$@
    internal static func receivingFrom(_ p1: Any) -> String {
      return L10n.tr("Localizable", "TransactionDetails.receivingFrom", String(describing: p1), fallback: "receiving from %1$@")
    }
    /// receiving via %1$@
    internal static func receivingVia(_ p1: Any) -> String {
      return L10n.tr("Localizable", "TransactionDetails.receivingVia", String(describing: p1), fallback: "receiving via %1$@")
    }
    /// Reclaim
    internal static let reclaim = L10n.tr("Localizable", "TransactionDetails.reclaim", fallback: "Reclaim")
    /// Resend
    internal static let resend = L10n.tr("Localizable", "TransactionDetails.resend", fallback: "Resend")
    /// Sent %1$@
    internal static func sent(_ p1: Any) -> String {
      return L10n.tr("Localizable", "TransactionDetails.sent", String(describing: p1), fallback: "Sent %1$@")
    }
    /// Sent <b>%1$@</b>
    internal static func sentAmountDescription(_ p1: Any) -> String {
      return L10n.tr("Localizable", "TransactionDetails.sentAmountDescription", String(describing: p1), fallback: "Sent <b>%1$@</b>")
    }
    /// Show Details
    internal static let showDetails = L10n.tr("Localizable", "TransactionDetails.showDetails", fallback: "Show Details")
    /// Starting Balance
    internal static let startingBalanceHeader = L10n.tr("Localizable", "TransactionDetails.startingBalanceHeader", fallback: "Starting Balance")
    /// Status
    internal static let statusHeader = L10n.tr("Localizable", "TransactionDetails.statusHeader", fallback: "Status")
    /// Transaction Details
    internal static let title = L10n.tr("Localizable", "TransactionDetails.title", fallback: "Transaction Details")
    /// Failed
    internal static let titleFailed = L10n.tr("Localizable", "TransactionDetails.titleFailed", fallback: "Failed")
    /// Internal
    internal static let titleInternal = L10n.tr("Localizable", "TransactionDetails.titleInternal", fallback: "Internal")
    /// Received
    internal static let titleReceived = L10n.tr("Localizable", "TransactionDetails.titleReceived", fallback: "Received")
    /// Receiving
    internal static let titleReceiving = L10n.tr("Localizable", "TransactionDetails.titleReceiving", fallback: "Receiving")
    /// Sending
    internal static let titleSending = L10n.tr("Localizable", "TransactionDetails.titleSending", fallback: "Sending")
    /// Sent
    internal static let titleSent = L10n.tr("Localizable", "TransactionDetails.titleSent", fallback: "Sent")
    /// to %1$@
    internal static func to(_ p1: Any) -> String {
      return L10n.tr("Localizable", "TransactionDetails.to", String(describing: p1), fallback: "to %1$@")
    }
    /// Total
    internal static let totalHeader = L10n.tr("Localizable", "TransactionDetails.totalHeader", fallback: "Total")
    /// Transaction ID
    internal static let txHashHeader = L10n.tr("Localizable", "TransactionDetails.txHashHeader", fallback: "Transaction ID")
  }
  internal enum TransactionDirection {
    /// Received at this Address
    internal static let address = L10n.tr("Localizable", "TransactionDirection.address", fallback: "Received at this Address")
    /// Sent to this Address
    internal static let to = L10n.tr("Localizable", "TransactionDirection.to", fallback: "Sent to this Address")
  }
  internal enum UDomains {
    /// Invalid address.
    internal static let invalid = L10n.tr("Localizable", "UDomains.invalid", fallback: "Invalid address.")
  }
  internal enum URLHandling {
    /// Copy wallet addresses to clipboard?
    internal static let addressaddressListAlertMessage = L10n.tr("Localizable", "URLHandling.addressaddressListAlertMessage", fallback: "Copy wallet addresses to clipboard?")
    /// Authorize to copy wallet address to clipboard
    internal static let addressList = L10n.tr("Localizable", "URLHandling.addressList", fallback: "Authorize to copy wallet address to clipboard")
    /// Copy Wallet Addresses
    internal static let addressListAlertTitle = L10n.tr("Localizable", "URLHandling.addressListAlertTitle", fallback: "Copy Wallet Addresses")
    /// Copy
    internal static let copy = L10n.tr("Localizable", "URLHandling.copy", fallback: "Copy")
  }
  internal enum UnlockScreen {
    /// Disabled until: %1$@
    internal static func disabled(_ p1: Any) -> String {
      return L10n.tr("Localizable", "UnlockScreen.disabled", String(describing: p1), fallback: "Disabled until: %1$@")
    }
    /// Unlock with FaceID
    internal static let faceIdText = L10n.tr("Localizable", "UnlockScreen.faceIdText", fallback: "Unlock with FaceID")
    /// My Address
    internal static let myAddress = L10n.tr("Localizable", "UnlockScreen.myAddress", fallback: "My Address")
    /// Reset PIN
    internal static let resetPin = L10n.tr("Localizable", "UnlockScreen.resetPin", fallback: "Reset PIN")
    /// Scan
    internal static let scan = L10n.tr("Localizable", "UnlockScreen.scan", fallback: "Scan")
    /// Unlock your Fabriik.
    internal static let touchIdPrompt = L10n.tr("Localizable", "UnlockScreen.touchIdPrompt", fallback: "Unlock your Fabriik.")
    /// Unlock with TouchID
    internal static let touchIdText = L10n.tr("Localizable", "UnlockScreen.touchIdText", fallback: "Unlock with TouchID")
    /// Wallet disabled
    internal static let walletDisabled = L10n.tr("Localizable", "UnlockScreen.walletDisabled", fallback: "Wallet disabled")
    /// You will need your recovery phrases to reset PIN.
    internal static let walletDisabledDescription = L10n.tr("Localizable", "UnlockScreen.walletDisabledDescription", fallback: "You will need your recovery phrases to reset PIN.")
    /// Are you sure you would like to wipe this wallet?
    internal static let wipePrompt = L10n.tr("Localizable", "UnlockScreen.wipePrompt", fallback: "Are you sure you would like to wipe this wallet?")
    internal enum TouchIdInstructions {
      /// Touch Sensor
      internal static let android = L10n.tr("Localizable", "UnlockScreen.touchIdInstructions.android", fallback: "Touch Sensor")
    }
    internal enum TouchIdPrompt {
      /// Please unlock your Android device to continue.
      internal static let android = L10n.tr("Localizable", "UnlockScreen.touchIdPrompt.android", fallback: "Please unlock your Android device to continue.")
    }
    internal enum TouchIdTitle {
      /// Authentication required
      internal static let android = L10n.tr("Localizable", "UnlockScreen.touchIdTitle.android", fallback: "Authentication required")
    }
  }
  internal enum UpdatePin {
    /// Remember this PIN. If you forget it, you won't be able to access your assets.
    internal static let caption = L10n.tr("Localizable", "UpdatePin.caption", fallback: "Remember this PIN. If you forget it, you won't be able to access your assets.")
    /// Contact Support
    internal static let contactSupport = L10n.tr("Localizable", "UpdatePin.ContactSupport", fallback: "Contact Support")
    /// Your PIN will be used to unlock your Fabriik Wallet and send money
    internal static let createInstruction = L10n.tr("Localizable", "UpdatePin.createInstruction", fallback: "Your PIN will be used to unlock your Fabriik Wallet and send money")
    /// Set PIN
    internal static let createTitle = L10n.tr("Localizable", "UpdatePin.createTitle", fallback: "Set PIN")
    /// Confirm your new PIN
    internal static let createTitleConfirm = L10n.tr("Localizable", "UpdatePin.createTitleConfirm", fallback: "Confirm your new PIN")
    /// Disabled until:
    internal static let disabledUntil = L10n.tr("Localizable", "UpdatePin.DisabledUntil", fallback: "Disabled until:")
    /// Enter your current PIN.
    internal static let enterCurrent = L10n.tr("Localizable", "UpdatePin.enterCurrent", fallback: "Enter your current PIN.")
    /// Enter your new PIN.
    internal static let enterNew = L10n.tr("Localizable", "UpdatePin.enterNew", fallback: "Enter your new PIN.")
    /// Please enter your PIN to confirm the transaction
    internal static let enterPin = L10n.tr("Localizable", "UpdatePin.EnterPin", fallback: "Please enter your PIN to confirm the transaction")
    /// Enter your PIN
    internal static let enterYourPin = L10n.tr("Localizable", "UpdatePin.enterYourPin", fallback: "Enter your PIN")
    /// Incorrect PIN. The wallet will get disabled for 6 minutes after
    internal static let incorrectPin = L10n.tr("Localizable", "UpdatePin.IncorrectPin", fallback: "Incorrect PIN. The wallet will get disabled for 6 minutes after")
    /// 1 more failed attempt.
    internal static let oneAttempt = L10n.tr("Localizable", "UpdatePin.OneAttempt", fallback: "1 more failed attempt.")
    /// Re-Enter your new PIN.
    internal static let reEnterNew = L10n.tr("Localizable", "UpdatePin.reEnterNew", fallback: "Re-Enter your new PIN.")
    /// Attempts remaining:
    internal static let remainingAttempts = L10n.tr("Localizable", "UpdatePin.RemainingAttempts", fallback: "Attempts remaining:")
    /// Your PIN was reset successfully!
    internal static let resetPinSuccess = L10n.tr("Localizable", "UpdatePin.ResetPinSuccess", fallback: "Your PIN was reset successfully!")
    /// Secured wallet
    internal static let securedWallet = L10n.tr("Localizable", "UpdatePin.securedWallet", fallback: "Secured wallet")
    /// Set your new PIN
    internal static let setNewPinTitle = L10n.tr("Localizable", "UpdatePin.setNewPinTitle", fallback: "Set your new PIN")
    /// Sorry, could not update PIN.
    internal static let setPinError = L10n.tr("Localizable", "UpdatePin.setPinError", fallback: "Sorry, could not update PIN.")
    /// Update PIN Error
    internal static let setPinErrorTitle = L10n.tr("Localizable", "UpdatePin.setPinErrorTitle", fallback: "Update PIN Error")
    /// 2 more failed attempts.
    internal static let twoAttempts = L10n.tr("Localizable", "UpdatePin.TwoAttempts", fallback: "2 more failed attempts.")
    /// The Fabriik Wallet app requires you to set a PIN to secure your wallet, separate from your device passcode.  
    /// 
    /// You will be required to enter the PIN to view your balance or send money, which keeps your wallet private even if you let someone use your phone or if your phone is stolen by someone who knows your device passcode.
    ///             
    /// Do not forget your wallet PIN! It can only be reset by using your Recovery Phrase. If you forget your PIN and lose your Recovery Phrase, your wallet will be lost.
    internal static let updatePinPopup = L10n.tr("Localizable", "UpdatePin.UpdatePinPopup", fallback: "The Fabriik Wallet app requires you to set a PIN to secure your wallet, separate from your device passcode.  \n\nYou will be required to enter the PIN to view your balance or send money, which keeps your wallet private even if you let someone use your phone or if your phone is stolen by someone who knows your device passcode.\n            \nDo not forget your wallet PIN! It can only be reset by using your Recovery Phrase. If you forget your PIN and lose your Recovery Phrase, your wallet will be lost.")
    /// Update PIN
    internal static let updateTitle = L10n.tr("Localizable", "UpdatePin.updateTitle", fallback: "Update PIN")
    /// Why do I need a PIN?
    internal static let whyPIN = L10n.tr("Localizable", "UpdatePin.WhyPIN", fallback: "Why do I need a PIN?")
  }
  internal enum VerificationCode {
    /// Check your phone for the confirmation token we sent you. It may take a couple of minutes.
    internal static let actionInstructions = L10n.tr("Localizable", "VerificationCode.actionInstructions", fallback: "Check your phone for the confirmation token we sent you. It may take a couple of minutes.")
    /// Enter token
    internal static let actionLabel = L10n.tr("Localizable", "VerificationCode.actionLabel", fallback: "Enter token")
    /// Confirm
    internal static let buttonConfirm = L10n.tr("Localizable", "VerificationCode.buttonConfirm", fallback: "Confirm")
    /// We Texted You a Confirmation Code
    internal static let label = L10n.tr("Localizable", "VerificationCode.label", fallback: "We Texted You a Confirmation Code")
    /// Confirmation Code
    internal static let title = L10n.tr("Localizable", "VerificationCode.title", fallback: "Confirmation Code")
  }
  internal enum VerifyPin {
    /// Please enter your PIN to authorize this transaction.
    internal static let authorize = L10n.tr("Localizable", "VerifyPin.authorize", fallback: "Please enter your PIN to authorize this transaction.")
    /// Please enter your PIN to continue.
    internal static let continueBody = L10n.tr("Localizable", "VerifyPin.continueBody", fallback: "Please enter your PIN to continue.")
    /// PIN Required
    internal static let title = L10n.tr("Localizable", "VerifyPin.title", fallback: "PIN Required")
    /// Authorize this transaction
    internal static let touchIdMessage = L10n.tr("Localizable", "VerifyPin.touchIdMessage", fallback: "Authorize this transaction")
  }
  internal enum Wallet {
    /// Trouble finding assets?
    internal static let findAssets = L10n.tr("Localizable", "Wallet.FindAssets", fallback: "Trouble finding assets?")
    /// Limited assets
    internal static let limitedAssets = L10n.tr("Localizable", "Wallet.LimitedAssets", fallback: "Limited assets")
    /// We currently only support the assets that are listed here. You cannot access other assets through this wallet at the moment.
    internal static let limitedAssetsMessage = L10n.tr("Localizable", "Wallet.LimitedAssetsMessage", fallback: "We currently only support the assets that are listed here. You cannot access other assets through this wallet at the moment.")
    /// 1d
    internal static let oneDay = L10n.tr("Localizable", "Wallet.one_day", fallback: "1d")
    /// 1m
    internal static let oneMonth = L10n.tr("Localizable", "Wallet.one_month", fallback: "1m")
    /// 1w
    internal static let oneWeek = L10n.tr("Localizable", "Wallet.one_week", fallback: "1w")
    /// 1y
    internal static let oneYear = L10n.tr("Localizable", "Wallet.one_year", fallback: "1y")
    /// Staking
    internal static let stakingTitle = L10n.tr("Localizable", "Wallet.stakingTitle", fallback: "Staking")
    /// 3m
    internal static let threeMonths = L10n.tr("Localizable", "Wallet.three_months", fallback: "3m")
    /// 3y
    internal static let threeYears = L10n.tr("Localizable", "Wallet.three_years", fallback: "3y")
  }
  internal enum WalletConnectionSettings {
    /// Are you sure you want to turn off Fastsync?
    internal static let confirmation = L10n.tr("Localizable", "WalletConnectionSettings.confirmation", fallback: "Are you sure you want to turn off Fastsync?")
    /// Make syncing your bitcoin wallet practically instant. Learn more about how it works here.
    internal static let explanatoryText = L10n.tr("Localizable", "WalletConnectionSettings.explanatoryText", fallback: "Make syncing your bitcoin wallet practically instant. Learn more about how it works here.")
    /// Powered by
    internal static let footerTitle = L10n.tr("Localizable", "WalletConnectionSettings.footerTitle", fallback: "Powered by")
    /// Fastsync (pilot)
    internal static let header = L10n.tr("Localizable", "WalletConnectionSettings.header", fallback: "Fastsync (pilot)")
    /// here
    internal static let link = L10n.tr("Localizable", "WalletConnectionSettings.link", fallback: "here")
    /// Connection Mode
    internal static let menuTitle = L10n.tr("Localizable", "WalletConnectionSettings.menuTitle", fallback: "Connection Mode")
    /// Turn Off
    internal static let turnOff = L10n.tr("Localizable", "WalletConnectionSettings.turnOff", fallback: "Turn Off")
    /// Fastsync
    internal static let viewTitle = L10n.tr("Localizable", "WalletConnectionSettings.viewTitle", fallback: "Fastsync")
  }
  internal enum Watch {
    /// Open the Fabriik iPhone app to set up your wallet.
    internal static let noWalletWarning = L10n.tr("Localizable", "Watch.noWalletWarning", fallback: "Open the Fabriik iPhone app to set up your wallet.")
  }
  internal enum Webview {
    /// Dismiss
    internal static let dismiss = L10n.tr("Localizable", "Webview.dismiss", fallback: "Dismiss")
    /// There was an error loading the content. Please try again.
    internal static let errorMessage = L10n.tr("Localizable", "Webview.errorMessage", fallback: "There was an error loading the content. Please try again.")
    /// Updating...
    internal static let updating = L10n.tr("Localizable", "Webview.updating", fallback: "Updating...")
  }
  internal enum Welcome {
    /// Breadwallet has changed its name to Fabriik, with a brand new look and some new features.
    /// 
    /// If you need help, look for the (?) in the top right of most screens.
    internal static let body = L10n.tr("Localizable", "Welcome.body", fallback: "Breadwallet has changed its name to Fabriik, with a brand new look and some new features.\n\nIf you need help, look for the (?) in the top right of most screens.")
    /// Welcome to Fabriik!
    internal static let title = L10n.tr("Localizable", "Welcome.title", fallback: "Welcome to Fabriik!")
  }
  internal enum Widget {
    /// Stay up to date with your favorite crypto asset
    internal static let assetDescription = L10n.tr("Localizable", "Widget.assetDescription", fallback: "Stay up to date with your favorite crypto asset")
    /// Stay up to date with your favorite crypto assets
    internal static let assetListDescription = L10n.tr("Localizable", "Widget.assetListDescription", fallback: "Stay up to date with your favorite crypto assets")
    /// Asset list
    internal static let assetListTitle = L10n.tr("Localizable", "Widget.assetListTitle", fallback: "Asset list")
    /// Asset
    internal static let assetTitle = L10n.tr("Localizable", "Widget.assetTitle", fallback: "Asset")
    /// Theme Background Colors
    internal static let colorSectionBackground = L10n.tr("Localizable", "Widget.colorSectionBackground", fallback: "Theme Background Colors")
    /// Basic Colors
    internal static let colorSectionBasic = L10n.tr("Localizable", "Widget.colorSectionBasic", fallback: "Basic Colors")
    /// Currency Colors
    internal static let colorSectionCurrency = L10n.tr("Localizable", "Widget.colorSectionCurrency", fallback: "Currency Colors")
    /// System Colors
    internal static let colorSectionSystem = L10n.tr("Localizable", "Widget.colorSectionSystem", fallback: "System Colors")
    /// Theme Text Colors
    internal static let colorSectionText = L10n.tr("Localizable", "Widget.colorSectionText", fallback: "Theme Text Colors")
    /// Enable in app
    /// preferences
    internal static let enablePortfolio = L10n.tr("Localizable", "Widget.enablePortfolio", fallback: "Enable in app\npreferences")
    /// Stay up to date with your portfolio
    internal static let portfolioDescription = L10n.tr("Localizable", "Widget.portfolioDescription", fallback: "Stay up to date with your portfolio")
    /// Portfolio
    /// Summary
    internal static let portfolioSummary = L10n.tr("Localizable", "Widget.portfolioSummary", fallback: "Portfolio\nSummary")
    /// Portfolio
    internal static let portfolioTitle = L10n.tr("Localizable", "Widget.portfolioTitle", fallback: "Portfolio")
    internal enum Color {
      /// System Auto Light / Dark
      internal static let autoLightDark = L10n.tr("Localizable", "Widget.Color.autoLightDark", fallback: "System Auto Light / Dark")
      /// Black
      internal static let black = L10n.tr("Localizable", "Widget.Color.black", fallback: "Black")
      /// Blue
      internal static let blue = L10n.tr("Localizable", "Widget.Color.blue", fallback: "Blue")
      /// Gray
      internal static let gray = L10n.tr("Localizable", "Widget.Color.gray", fallback: "Gray")
      /// Green
      internal static let green = L10n.tr("Localizable", "Widget.Color.green", fallback: "Green")
      /// Orange
      internal static let orange = L10n.tr("Localizable", "Widget.Color.orange", fallback: "Orange")
      /// Pink
      internal static let pink = L10n.tr("Localizable", "Widget.Color.pink", fallback: "Pink")
      /// Primary
      internal static let primaryBackground = L10n.tr("Localizable", "Widget.Color.primaryBackground", fallback: "Primary")
      /// Primary
      internal static let primaryText = L10n.tr("Localizable", "Widget.Color.primaryText", fallback: "Primary")
      /// Purple
      internal static let purple = L10n.tr("Localizable", "Widget.Color.purple", fallback: "Purple")
      /// Red
      internal static let red = L10n.tr("Localizable", "Widget.Color.red", fallback: "Red")
      /// Secondary
      internal static let secondaryBackground = L10n.tr("Localizable", "Widget.Color.secondaryBackground", fallback: "Secondary")
      /// Secondary
      internal static let secondaryText = L10n.tr("Localizable", "Widget.Color.secondaryText", fallback: "Secondary")
      /// Tertiary
      internal static let tertiaryBackground = L10n.tr("Localizable", "Widget.Color.tertiaryBackground", fallback: "Tertiary")
      /// Tertiary
      internal static let tertiaryText = L10n.tr("Localizable", "Widget.Color.tertiaryText", fallback: "Tertiary")
      /// White
      internal static let white = L10n.tr("Localizable", "Widget.Color.white", fallback: "White")
      /// Yellow
      internal static let yellow = L10n.tr("Localizable", "Widget.Color.yellow", fallback: "Yellow")
    }
  }
  internal enum WipeWallet {
    /// Are you sure you want to delete this wallet?
    internal static let alertMessage = L10n.tr("Localizable", "WipeWallet.alertMessage", fallback: "Are you sure you want to delete this wallet?")
    /// Wipe Wallet?
    internal static let alertTitle = L10n.tr("Localizable", "WipeWallet.alertTitle", fallback: "Wipe Wallet?")
    /// Failed to wipe wallet.
    internal static let failedMessage = L10n.tr("Localizable", "WipeWallet.failedMessage", fallback: "Failed to wipe wallet.")
    /// Failed
    internal static let failedTitle = L10n.tr("Localizable", "WipeWallet.failedTitle", fallback: "Failed")
    /// Please enter your recovery phrase to wipe this wallet from your device.
    internal static let instruction = L10n.tr("Localizable", "WipeWallet.instruction", fallback: "Please enter your recovery phrase to wipe this wallet from your device.")
    /// Starting or recovering another wallet allows you to access and manage a different Fabriik wallet on this device.
    internal static let startMessage = L10n.tr("Localizable", "WipeWallet.startMessage", fallback: "Starting or recovering another wallet allows you to access and manage a different Fabriik wallet on this device.")
    /// Your current wallet will be removed from this device. If you wish to restore it in the future, you will need to enter your Recovery Phrase.
    internal static let startWarning = L10n.tr("Localizable", "WipeWallet.startWarning", fallback: "Your current wallet will be removed from this device. If you wish to restore it in the future, you will need to enter your Recovery Phrase.")
    /// Start or Recover Another Wallet
    internal static let title = L10n.tr("Localizable", "WipeWallet.title", fallback: "Start or Recover Another Wallet")
    /// Wipe
    internal static let wipe = L10n.tr("Localizable", "WipeWallet.wipe", fallback: "Wipe")
    /// Wiping...
    internal static let wiping = L10n.tr("Localizable", "WipeWallet.wiping", fallback: "Wiping...")
  }
  internal enum WritePaperPhrase {
    /// Write down each word in order and store it in a safe place.
    internal static let instruction = L10n.tr("Localizable", "WritePaperPhrase.instruction", fallback: "Write down each word in order and store it in a safe place.")
    /// Next
    internal static let next = L10n.tr("Localizable", "WritePaperPhrase.next", fallback: "Next")
    /// Previous
    internal static let previous = L10n.tr("Localizable", "WritePaperPhrase.previous", fallback: "Previous")
    /// %1$d of %2$d
    internal static func step(_ p1: Int, _ p2: Int) -> String {
      return L10n.tr("Localizable", "WritePaperPhrase.step", p1, p2, fallback: "%1$d of %2$d")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
