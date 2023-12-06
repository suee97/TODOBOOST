import Foundation
import Combine

final class SearchViewModel {
    @Published var loadingState: LoadingState = .done
    @Published var followers = [Follower]()
    
    func getFollowers(nickname: String) {
        loadingState = .loading
        NetworkService.shared.getFollowers(nickname: nickname, completion: { result, data in
            self.followers = data?.followers ?? [Follower]()
            self.loadingState = .done
        })
    }
}
