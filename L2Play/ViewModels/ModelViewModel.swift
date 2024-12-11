import Foundation

class ModelViewModel: ObservableObject {
    @Published var recommendedGames: [String] = []
    private let model: Model

    init(userId: String) {
        self.model = Model(userid: userId)
    }

    func fetchRecommendations() {
        DispatchQueue.global(qos: .background).async {
            if let recommendations = self.model.predict() {
                DispatchQueue.main.async {
                    self.recommendedGames = recommendations
                }
            } else {
                DispatchQueue.main.async {
                    self.recommendedGames = ["No recommendations found"]
                }
            }
        }
    }
}