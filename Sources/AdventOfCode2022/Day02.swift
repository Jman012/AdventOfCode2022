import Foundation

public struct Day02: Challenge {
	
	public init() {}
	
	enum Play {
		case rock
		case paper
		case scissors
		
		init(from: String.SubSequence) {
			switch from {
			case "A", "X": self = .rock
			case "B", "Y": self = .paper
			case "C", "Z": self = .scissors
			default: exit(1)
			}
		}
		
		func baseScore() -> Int {
			switch self {
			case .rock: return 1
			case .paper: return 2
			case .scissors: return 3
			}
		}
		
		func beats(_ play: Play) -> Int {
			if self == .rock && play == .scissors {
				return baseScore() + 6
			} else if self == .paper && play == .rock {
				return baseScore() + 6
			} else if self == .scissors && play == .paper {
				return baseScore() + 6
			} else if self == play {
				return baseScore() + 3
			}
			
			return baseScore()
		}
		
		func beats2(_ play: Play) -> Int {
			if self == .rock && play == .rock {
				return 3 + 0
			} else if self == .rock && play == .paper {
				return 1 + 3
			} else if self == .rock && play == .scissors {
				return 2 + 6
			}
			
			if self == .paper && play == .rock {
				return 1 + 0
			} else if self == .paper && play == .paper {
				return 2 + 3
			} else if self == .paper && play == .scissors {
				return 3 + 6
			}
			
			if self == .scissors && play == .rock {
				return 2 + 0
			} else if self == .scissors && play == .paper {
				return 3 + 3
			} else if self == .scissors && play == .scissors {
				return 1 + 6
			}
			
			exit(1)
		}
	}
	
	public func solvePart1(input: String) -> String {
		let games = input.split(separator: "\n")
		let scores = games.map({ game in
			let plays = game.split(separator: " ")
			let theirPlay = Play(from: plays[0])
			let ourPlay = Play(from: plays[1])
			let score = ourPlay.beats(theirPlay)
			return score
		})
		return "\(scores.reduce(0, +))"
	}
	
	public func solvePart2(input: String) -> String {
		let games = input.split(separator: "\n")
		let scores = games.map({ game in
			let plays = game.split(separator: " ")
			let theirPlay = Play(from: plays[0])
			let ourPlay = Play(from: plays[1])
			let score = theirPlay.beats2(ourPlay)
			return score
		})
		return "\(scores.reduce(0, +))"
	}
	
}
