import Foundation

public struct Day23: Challenge {
	
	public init() {}
	
	enum Direction {
		case north
		case south
		case east
		case west
		case northWest
		case northEast
		case southWest
		case southEast
	}
	
	struct Coord: Hashable {
		let row: Int
		let col: Int
		
		var north: Coord {
			return Coord(row: self.row - 1, col: self.col)
		}
		var south: Coord {
			return Coord(row: self.row + 1, col: self.col)
		}
		var east: Coord {
			return Coord(row: self.row, col: self.col + 1)
		}
		var west: Coord {
			return Coord(row: self.row, col: self.col - 1)
		}
		var northWest: Coord {
			return Coord(row: self.row - 1, col: self.col - 1)
		}
		var northEast: Coord {
			return Coord(row: self.row - 1, col: self.col + 1)
		}
		var southWest: Coord {
			return Coord(row: self.row + 1, col: self.col - 1)
		}
		var southEast: Coord {
			return Coord(row: self.row + 1, col: self.col + 1)
		}
		
		var surrounding: [Coord] {
			return [north, south, east, west,
					northWest, northEast, southWest, southEast]
		}
		
		func next(due dir: Direction) -> Coord {
			switch dir {
			case .north: return Coord(row: self.row - 1, col: self.col)
			case .south: return Coord(row: self.row + 1, col: self.col)
			case .east: return Coord(row: self.row, col: self.col + 1)
			case .west: return Coord(row: self.row, col: self.col - 1)
			case .northWest: return Coord(row: self.row - 1, col: self.col - 1)
			case .northEast: return Coord(row: self.row - 1, col: self.col + 1)
			case .southWest: return Coord(row: self.row + 1, col: self.col - 1)
			case .southEast: return Coord(row: self.row + 1, col: self.col + 1)
			}
		}
	}
	
	public func solvePart1(input: String) -> String {
		let beginningElves = input
			.split(separator: "\n")
			.enumerated()
			.map({ (row, line) in
				return line.enumerated().map({ (col, character) -> Coord? in
					if character == "#" {
						return Coord(row: row, col: col)
					} else {
						return nil
					}
				})
			})
			.flatMap({ $0 })
			.compactMap({ $0 })
		
		var board = Set<Coord>(beginningElves)
		var checks: [([Direction], Direction)] = [
			([.north, .northEast, .northWest], .north),
			([.south, .southEast, .southWest], .south),
			([.west, .northWest, .southWest], .west),
			([.east, .northEast, .southEast], .east),
		]
		
		for _ in 0..<10 {
			let elvesToProcess = board.filter({ board.intersection($0.surrounding).count > 0 })
			let elfMovementProposals = elvesToProcess.map({ elf -> (Coord, Coord)? in
				for check in checks {
					if board.intersection(check.0.map({ elf.next(due: $0) })).isEmpty {
						return (elf, elf.next(due: check.1))
					}
				}
				return nil
			}).compacted()
			
			let proposedCoords = elfMovementProposals.map({ ($0.1, 1) })
			let proposedCoordCounts = Dictionary(proposedCoords, uniquingKeysWith: { $0 + $1 })
			let validMoves = elfMovementProposals.filter({ proposedCoordCounts[$0.1]! == 1 })
			board.subtract(validMoves.map({ $0.0 }))
			board.formUnion(validMoves.map({ $0.1 }))
			
			checks.append(checks.removeFirst())
		}
		
		let minRow = board.map({ $0.row }).min()!
		let maxRow = board.map({ $0.row }).max()!
		let minCol = board.map({ $0.col }).min()!
		let maxCol = board.map({ $0.col }).max()!
		
		let result = ((maxRow - minRow + 1) * (maxCol - minCol + 1)) - board.count
		
		return "\(result)"
	}
	
	public func solvePart2(input: String) -> String {
		let beginningElves = input
			.split(separator: "\n")
			.enumerated()
			.map({ (row, line) in
				return line.enumerated().map({ (col, character) -> Coord? in
					if character == "#" {
						return Coord(row: row, col: col)
					} else {
						return nil
					}
				})
			})
			.flatMap({ $0 })
			.compactMap({ $0 })
		
		var board = Set<Coord>(beginningElves)
		var checks: [([Direction], Direction)] = [
			([.north, .northEast, .northWest], .north),
			([.south, .southEast, .southWest], .south),
			([.west, .northWest, .southWest], .west),
			([.east, .northEast, .southEast], .east),
		]
		
		for round in 0..<Int.max {
			let elvesToProcess = board.filter({ board.intersection($0.surrounding).count > 0 })
			let elfMovementProposals = elvesToProcess.map({ elf -> (Coord, Coord)? in
				for check in checks {
					if board.intersection(check.0.map({ elf.next(due: $0) })).isEmpty {
						return (elf, elf.next(due: check.1))
					}
				}
				return nil
			}).compacted()
			
			let proposedCoords = elfMovementProposals.map({ ($0.1, 1) })
			let proposedCoordCounts = Dictionary(proposedCoords, uniquingKeysWith: { $0 + $1 })
			let validMoves = elfMovementProposals.filter({ proposedCoordCounts[$0.1]! == 1 })
			if validMoves.isEmpty {
				return "\(round + 1)"
			}
			board.subtract(validMoves.map({ $0.0 }))
			board.formUnion(validMoves.map({ $0.1 }))
			
			checks.append(checks.removeFirst())
		}
		
		return "error"
	}
	
}
