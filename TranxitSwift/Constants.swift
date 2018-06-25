//
//  Constants.swift
//  Centros_Camprios
//
//  Created by imac on 12/18/17.
//  Copyright © 2017 Appoets. All rights reserved.
//

import UIKit
import Foundation

typealias ViewController = (UIViewController & PostViewProtocol)
var presenterObject :PostPresenterInputProtocol?

// MARK: - Constant Strings

struct Constants {
    static let string = Constants()
    
    let Done = "Done"
    let Back = "Back"
    let delete = "Delete"
    let noDevice = "no device"
    let manual = "manual"
    let OK = "OK"
    let Cancel = "Cancel"
    let NA = "NA"
    let MobileNumber = "Mobile Number"
    let next = "Next"
    let selectSource = "Select Source"
    let ConfirmPassword = "ConfirmPassword"
    let camera = "Camera"
    let photoLibrary = "Photo Library"
    let walkthrough = "Walkthrough"
    let signIn = "SIGN IN"
    let signUp = "SIGNUP"
    let orConnectWithSocial = "Or connect with social"
    let changePassword = "Change Password"
    let resetPassword = "Reset Password"
    let enterOtp = "Enter OTP"
    let otpIncorrect = "OTP incorrect"
    let enterCurrentPassword = "Current Password"
    let walkthroughDummy = """
      Lorem Ipsum is simply dummy text of the printing and typesetting industry.
    Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,
     when an unknown printer took a galley of type and scrambled it to make a
    type specimen book. It has survived not only five centuries, but also the leap
    into electronic typesetting, remaining essentially unchanged.It
    was popularised in the 1960s with the release of Letraset sheets
    containing Lorem Ipsum passages, and more recently with desktop publishing
    software like Aldus PageMaker including versions of Lorem Ipsum
    """
    
    let walkthroughWelcome = "Introducing Tranxit Driver to take rides from the Tranxit app users."
    let walkthroughDrive = "Be your own boss, set your own schedule. Get the latest driving features all in one spot."
    let walkthroughEarn = "Get well paid to help out strangers get to where they need to go,withdraw your earnigs every week/monthly."
    let welcome = "Welcome"
    let drive = "Drive"
    let earn = "Earn"
    let country = "Country"
    let timeZone = "Time Zone"
    let referalCode = "Referral Code"
    let business = "Business"
    let emailPlaceHolder = "name@example.com"
    let email = "Email"
    let iNeedTocreateAnAccount = "I need to create an account"
    let whatsYourEmailAddress = "What's your Email Address?"
    let welcomeBackPassword = "Welcome back, sign in to continue"
    let enterPassword = "Enter Password"
    let enterNewpassword = "Enter New Password"
    let enterConfirmPassword = "Enter Confirm Password"
    let password = "Password"
    let newPassword = "New Password"
    let iForgotPassword = "I forgot my password"
    let enterYourMailIdForrecovery = "Enter your mail ID for recovery"
    let registerDetails = "Enter the details to register"
    let chooseAnAccount = "Choose an account"
    let facebook = "Facebook"
    let google = "Google"
    let payment = "Payment"
    let yourTrips = "Your Trips"
    let coupon = "Coupon"
    let wallet = "Wallet"
    let passbook = "Passbook"
    let settings = "Settings"
    let help = "Help"
    let share = "Share"
    let inviteReferral = "Invite Referral"
    let faqSupport = "FAQ Support"
    let termsAndConditions = "Terms and Conditions"
    let privacyPolicy = "Privacy Policy"
    let logout = "Logout"
    let profile = "Profile"
    let first = "First Name"
    let last = "Last Name"
    let phoneNumber = "Phone Number"
    let tripType = "Trip Trip"
    let personal = "Personal"
    let save = "save"
    let lookingToChangePassword = "Looking to change password?"
    let areYouSure = "Are you sure?"
    let areYouSureWantToLogout = "Are you want to logout?"
    let sure = "Sure"
    let source = "Source"
    let destination = "Destination"
    let home = "Home"
    let work = "Work"
    let addLocation = "Add Location"
    let selectService = "Select Service"
    let service = "Service"
    let more = "More"
    let change = "change"
    let getPricing = "GET PRICING"
    let cancelRequest = "Cancel Request"
    let cancelRequestDescription = "Are you sure want to cancel the request?"
    let findingDriver = "Finding Driver..."
    let dueToHighDemandPriceMayVary = "Due to high demand price may vary"
    let estimatedFare = "Estimated Fare"
    let ETA = "ETA"
    let model = "Model"
    let useWalletAmount = "Use Wallet Amount"
    let scheduleRide = "schedule ride"
    let rideNow = "ride now"
    let scheduleARide = "Schedule your Ride"
    let select = "Select"
    let driverAccepted = "Driver accepted your request."
    let youAreOnRide = "You are on ride."
    let bookingId = "Booking ID"
    let distanceTravelled = "Distance Travelled"
    let timeTaken = "Time Taken"
    let baseFare = "Base Fare"
    let cash = "Cash"
    let paynow = "Pay Now"
    let rateyourtrip = "Rate your trip with"
    let writeYourComments = "Write your comments"
    let distanceFare = "Distance Fare"
    let tax = "Tax"
    let total = "Total"
    let submit = "Submit"
    let driverArrived = "Driver has arrived at your location."
    let peakInfo = "Due to peak hours, charges will be varied based on availability of provider."
    let call = "Call"
    let past = "Past"
    let upcoming = "Upcoming"
    let addCardPayments = "Add card for payments"
    let paymentMethods = "Payment Methods"
    let yourCards = "Your Cards"
    let walletHistory = "Wallet History"
    let couponHistory = "Coupon History"
    let enterCouponCode = "Enter Coupon Code"
    let addCouponCode = "Add Coupon Code"
    let resetPasswordDescription = "Note : Please enter the OTP send to your registered email address"
    let latitude = "latitude"
    let longitude = "longitude"
    let totalDistance = "Total Distance"
    let shareRide = "Share Ride"
    let wouldLikeToShare = "would like to share a ride with you at"
    let profileUpdated = "Profile updated successfully"
    let otp = "OTP"
    let at = "at"
    let favourites = "Favourites"
    let changeLanguage = "Change Language"
    let noFavouritesFound = "No favourite address available"
    let cannotMakeCallAtThisMoment = "Cannot make call at this moment"
    let offer = "Offer"
    let amount = "Amount"
    let creditedBy = "Credited By"
    let CouponCode = "Coupon Code"
    let OFF = "OFF"
    let couldnotOpenEmailAttheMoment = "Could not open Email at the moment."
    let couldNotReachTheHost = "Could not reach th web"
    let wouldyouLiketoMakeaSOSCall = "Would you like to make a SOS Call?"
    let mins = "mins"
    let invoice = "Invoice"
    let viewRecipt = "View Recipt"
    let payVia = "Pay via"
    let comments = "Comments"
    let pastTripDetails = "Past Trip Details"
    let upcomingTripDetails = "Upcoming Trip Details"
    let paymentMethod = "Payment Method"
    let cancelRide = "Cancel Ride"
    let noComments = "no Comments"
    let noPastTrips = "No Past Trips"
    let noUpcomingTrips = "No Upcoming Trips"
    let noWalletHistory = "No Wallet Details"
    let noCouponDetail = "No Coupon Details"
    let fare = "Fare"
    let fareType = "Fare Type"
    let capacity = "Capacity"
    let rateCard = "Rate Card"
    let distance = "Distance"
    let sendMyLocation = "Send my Location"
    let noInternet = "No Internet?"
    let bookNowOffline = "Book Now using SMS"
    let tapForCurrentLocation = "Tap the button below to send your current location by SMS."
    let standardChargesApply = "Standard charges may apply"
    let noThanks = "No thanks, I'll try later"
    let iNeedCab = "I need a cab @"
    let donotEditMessage = "(Please donot edit this SMS. Standard SMS charges of Rs.3 per SMS may apply)"
    
}

//Defaults Keys

struct Keys {
    
    static let list = Keys()
    let userData = "userData"
    let idKey = "id"
    let accessToken = "accesstoken"
    let firstName = "firstName"
    let lastName = "lastName"
    let picture = "picture"
    let email = "email"
    let mobile = "mobile"
    let currency = "currency"
    let language = "language"
    let refreshToken = "refreshToken"
}

//ENUM TRIP TYPE

enum TripType : String, Codable {
    
    case Business
    case Personal
    
}

//Payment Type

enum  PaymentType : String, Codable {
    
    case CASH = "CASH"
    case CARD = "CARD"
    
}


// Date Formats

struct DateFormat {
    
    static let list = DateFormat()
    let yyyy_mm_dd_HH_MM_ss = "yyyy-MM-dd HH:mm:ss"
    let MMM_dd_yyyy_hh_mm_ss_a = "MMM dd, yyyy hh:mm:ss a"
    let hhmmddMMMyyyy = "hh:mm a - dd:MMM:yyyy"
    let ddMMyyyyhhmma = "dd-MM-yyyy hh:mma"
    let ddMMMyyyy = "dd MMM yyyy"
    let hh_mm_a = "hh : mm a"
}



// Devices

enum DeviceType : String, Codable {
    
    case ios = "ios"
    case android = "android"
    
}

//Lanugage

enum Language : String {
    case english = "English"
    case spanish = "Spanish"
    static var count: Int{ return 2 }
}



// MARK:- Login Type

enum LoginType : String, Codable {
    
    case facebook
    case google
    case manual
    
}


// MARK:- Ride Status

enum RideStatus : String, Codable {
    
    case searching = "SEARCHING"
    case accepted = "ACCEPTED"
    case started = "STARTED"
    case arrived = "ARRIVED"
    case pickedup = "PICKEDUP"
    case dropped = "DROPPED"
    case completed = "COMPLETED"
    case cancelled = "CANCELLED"
    case none
    
}

