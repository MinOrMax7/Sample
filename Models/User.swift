import Foundation

struct User: Identifiable{
    var id: String
    var displayedID: String
    var role: String
    var createdTime: NSDate
    //var phoneNumber: String
    var firstName: String
    var lastName: String
    var displayedName: String
    var bio: String
    
    var petName: String
    var petGender: Bool
    var breed: String
    var petBirthDate: Date //year and month
    var togetherDate: Date
    
    var questions: [Int]
    
    var followersCount : Int
    var followingCount: Int
//    var followers: [UserFollower]
//    var following: [UserFollowing]
//
//    var explores: [UserExplore]
//    var likedExplores: [UserLikedExplores]
//    var favoriteExplores: [UserFavoriteExplores]
//
//    var discovers: [UserDiscover]
        
    var chats: [UserChat]
    
    var payed: Int
}

struct UserFollower: Identifiable {
    var id: String
    var followerSince: Date
}

struct UserFollowing: Identifiable {
    var id: String
    var followingSince: Date
}

struct UserBlock: Identifiable {
    var id: String
}

struct UserExplore: Equatable {
    var id: String
    var archive: Bool
}

struct UserDiscover: Equatable {
    var id: String
    var archive: Bool
}

struct UserLikedExplore: Equatable {
    var id: String
}

struct UserFavoriteExplore: Equatable {
    var id: String
}

struct UserFavoriteDiscover: Equatable {
    var id: String
}

struct UserUpvotesDiscover: Equatable {
    var id: String
}

struct UserCourseHistory: Equatable {
    var id: String
    var courseID: String
    var timeVisited: Date
}

struct UserChat: Equatable {
    var id: String
    var lastRead: Date
}
