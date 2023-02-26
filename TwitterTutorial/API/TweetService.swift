//
//  TweetService.swift
//  TwitterTutorial
//
//  Created by 김지수 on 2023/02/25.
//

import Firebase

struct TweetService {
    static let shared = TweetService()
    
    func uploadTweet(caption: String, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = ["uid" : uid,
                      "timestamp" : Int(NSDate().timeIntervalSince1970),
                      "likes" : 0,
                      "retweets" : 0,
                      "caption" : caption] as [String : Any]
        
        // 1. Tweet Ref를 만듬 - AutoID로
        let ref = REF_TWEETS.childByAutoId()
        
        // 2. Tweet 구조 업데이트 함
        ref.updateChildValues(values) { (error, ref) in
            
            // 3. Update한 Tweet의 key(refID)를 가져옴
            guard let tweetID = ref.key else { return }
            
            // 4. UserTweet 구조에 따로, 해당 유저의 tweet id만 저장
            REF_USER_TWEETS.child(uid).updateChildValues([tweetID : 1], withCompletionBlock: completion)
        }
    }
    
    func fetchTweets(completion: @escaping([Tweet]) -> Void) {
        var tweets = [Tweet]()
        
        REF_TWEETS.observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String : Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            let tweetID = snapshot.key
            
            UserService.shared.fetchUser(uid: uid) { user in
                let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    func fetchTweets(forUser user: User, completion: @escaping([Tweet]) -> Void) {
        var tweets = [Tweet]()
        REF_USER_TWEETS.child(user.uid).observe(.childAdded) { snapshot in
            let tweetID = snapshot.key
            
            REF_TWEETS.child(tweetID).observeSingleEvent(of: .value) { snapshot in
                guard let dictionary = snapshot.value as? [String : Any] else { return }
                let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
}
