import Foundation
import Firebase

struct User : Codable {
    var loggedInUserID = ""
    var isLoggedIn = false
    var hasFinishedWelcome = false
    var firstName = ""
    var lastName = ""
    var email = ""
    var startCode = ""
    var weddingDay = Date()
    var startBudget = 0.0
    var budgetItems: [BudgetItem] = []
    var checkboxStatesBeforeWedding: [Bool] = Array(repeating: false, count: 11)
    var checkboxStatesOnWeddingDay: [Bool] =  Array(repeating: false, count: 16)
    var checkboxStatesPreparationBride: [Bool] = Array(repeating: false, count: 6)
    var checkboxStatesPreparationGroom: [Bool] = Array(repeating: false, count: 4)
    var timeLineItems: [TimeLineItem] = []
    var guestListItems: [GuestListItem] = []
    var weddingMotto = ""
    var dressCode = ""
    var importantDetails = ""
    var addressWedding  = ""
    var addressParty = ""
    var namePrideAndGrum = ""
    var nameWitnesses  = ""
    var nameChilds = ""
    var nameFamiliy = ""
    var groupPicturesList = ""
    var plannedActions = ""
    var additionalInfo = ""
    var isVIP = false
}
