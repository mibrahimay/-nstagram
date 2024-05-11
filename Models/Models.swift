import Foundation
enum Gender {
     case male , famale , other
}

struct User{
    let username : String
    let bio : String
    let name:(first : String, last : String)
    let birthDate : Date
    let gender : Gender
    let counts: UserCount
    let joindate : Date
    let profilePhoto : URL
}
    struct UserCount {
        let followers: Int
        let following : Int
        let posts : Int
    }
    public enum UserPostType: String {
        case photo = "Photo"
        case video = "Video"
        
    }

    public struct Userpost {
        let identifier : String
        let postType : UserPostType
        let thumbnailImage : URL
        let postURL : URL
        let caption : String?
        let likeCount : [PostLikes]
        let comments: [PostComment]
        let createdDate : Date
        let taggedUsers: [User]
        let owner : User
        // Define properties for Post if needed
    }
    struct PostLikes{
        let username : String
        let postIdentifier : String
    }
    struct CommentLike {
        let username : String
        let commentIdentifier : String
    }
    struct PostComment{
        let identifier : String
        let username : String
        let text : String
        let createdDate : Date
        let likes : [CommentLike]
    }

