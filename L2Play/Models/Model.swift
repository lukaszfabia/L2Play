import PythonKit

class Model {
    let userId: String

    init(userid: String) {
        self.userId = userid
    }

    func predict() -> [String]? {
        do {
            let sys = Python.import("sys")
            sys.path.append("Python/recommending_games.py")
            
            let recommendingGames = Python.import("recommending_games")
            let recommendedGames = recommendingGames.main(self.userId) // Pass userId here
            
            return Array(recommendedGames).compactMap { "\($0)" }
        } catch {
            print("Error in calling Python script: \(error)")
            return nil
        }
    }
}