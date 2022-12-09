import Foundation

public struct Day09: Challenge {
	
	public init() {}
	
	struct Move {
		let direction: Character
		let distance: Int
	}
	
	struct Coord: Equatable, Hashable {
		let row: Int
		let col: Int
		
		func moveBy(direction: Character) -> Coord {
			switch direction {
			case "U":
				return Coord(row: row, col: col - 1)
			case "D":
				return Coord(row: row, col: col + 1)
			case "L":
				return Coord(row: row - 1, col: col)
			case "R":
				return Coord(row: row + 1, col: col)
			default:
				exit(1)
			}
		}
		
		func isAdjacent(to: Coord) -> Bool {
			let diffX = Int(abs(self.col - to.col))
			let diffY = Int(abs(self.row - to.row))
			return (diffX == 0 || diffX == 1) && (diffY == 0 || diffY == 1)
		}
		
		func moveCloser(to: Coord) -> Coord {
			return Coord(row: to.row - self.row > 0 ? self.row + 1 : to.row - self.row < 0 ? self.row - 1 : row,
						 col: to.col - self.col > 0 ? self.col + 1 : to.col - self.col < 0 ? self.col - 1: col)
		}
	}
	
	public func solvePart1(input: String) -> String {
		let moves = input.split(separator: "\n").map({ line in
			let split = line.split(separator: " ")
			return Move(direction: split[0].first!, distance: Int(split[1])!)
		})
		
		var head = Coord(row: 0, col: 0)
		var tail = Coord(row: 0, col: 0)
		var tailPositions = Set<Coord>()
		tailPositions.formUnion([tail])
		
		for move in moves {
			for _ in 0..<move.distance {
				head = head.moveBy(direction: move.direction)
				
				if !tail.isAdjacent(to: head) {
					tail = tail.moveCloser(to: head)
					tailPositions.formUnion([tail])
				}
			}
		}
		
		return "\(tailPositions.count)"
	}
	
	public func solvePart2(input: String) -> String {
		let moves = input.split(separator: "\n").map({ line in
			let split = line.split(separator: " ")
			return Move(direction: split[0].first!, distance: Int(split[1])!)
		})
		
		let knots = 10
		var knotCoords: [Coord] = .init(repeating: Coord(row: 0, col: 0), count: knots)
		var tailPositions = Set<Coord>()
		tailPositions.formUnion([knotCoords.last!])
		
		for move in moves {
			for _ in 0..<move.distance {
				// Move the head
				knotCoords[0] = knotCoords[0].moveBy(direction: move.direction)
				
				// Have the others follow one at a time
				for i in 1..<knots {
					let previousKnot = knotCoords[i-1]
					var knot = knotCoords[i]
					if !knot.isAdjacent(to: previousKnot) {
						knot = knot.moveCloser(to: previousKnot)
						knotCoords[i] = knot
					}
				}
				
				tailPositions.formUnion([knotCoords.last!])
			}
		}
		
		return "\(tailPositions.count)"
	}
	
}
