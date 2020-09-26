//
//  PullRequestLoader.swift
//  Github Tracker
//
//  Created by Kyler Freas on 9/26/20.
//

import Foundation

/// Loads the most recent Pull Request and parses it
struct PullRequestLoader {
    /// Hits the Github API to retrieve the latest open Pull Request for a repo
    static func fetch(account: String, repo: String, completion: @escaping (Result<PullRequest?, Error>) -> Void) {
        let pullsURL = URL(string: "https://api.github.com/repos/\(account)/\(repo)/pulls")!
        
        let task = URLSession.shared.dataTask(with: pullsURL) {
            (data, response, error) in
            guard error == nil else {
                // API error
                completion(.failure(error!))
                return
            }
            
            guard let pr = getLatestPR(fromData: data!) else {
                // No open Pull Requests
                completion(.success(nil))
                return
            }
            
            // Got an open Pull Request. Fetch mergeable status.
            getMergeableStatus(pr: pr) { result in
                completion(.success(result))
            }
        }
        
        task.resume()
    }

    /// Parses Pull Requests and returns the most recent one
    static func getLatestPR(fromData data: Foundation.Data) -> PullRequest? {
        let jsonArray = try! JSONSerialization.jsonObject(with: data, options: []) as! [Any]
        
        guard let firstPrJson = jsonArray.first as? [String: Any] else {
            return nil
        }
        
        let number = firstPrJson["number"] as! Int
        
        let user = firstPrJson["user"] as! [String: Any]
        let author = user["login"] as! String
        
        let title = firstPrJson["title"] as! String
        
        let head = firstPrJson["head"] as! [String: Any]
        let headBranch = head["ref"] as! String
        
        let base = firstPrJson["base"] as! [String: Any]
        let baseBranch = base["ref"] as! String
        
        let createdString = firstPrJson["created_at"] as! String
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let created = dateFormatter.date(from:createdString)!
        
        let url = firstPrJson["url"] as! String
        
        return PullRequest(
            number: number,
            title: title,
            created: created,
            author: author,
            branch: headBranch,
            base: baseBranch,
            url: url,
            mergeable: nil // needs an additional request to check mergeable status
        )
    }
    
    private static func getMergeableStatus(pr: PullRequest, completion: @escaping(PullRequest) -> Void) {
        let pullUrl = URL(string: pr.url)!
        
        let task = URLSession.shared.dataTask(with: pullUrl) {
            (data, response, error) in
            guard error == nil else {
                // API error. Return the unchanged PR object.
                completion(pr)
                return
            }
            
            // Parse mergeable status
            let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
            let mergeable = json["mergeable"] as! Bool
            
            // Add mergeable status to PR and return
            var modifiedPR = pr;
            modifiedPR.mergeable = mergeable
            completion(modifiedPR)
            return
        }
        
        task.resume()
    }
}
