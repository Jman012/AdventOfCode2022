import Foundation

public struct Day17: Challenge {
	
	public init() {}
	
	struct Coord: Hashable {
		let row: Int
		let col: Int
	}
	
	enum CellValue: String {
		case empty = "."
		case falling = "@"
		case resting = "#"
	}
	
	class Cell {
		var value: CellValue = .empty
	}
	
	enum Shape {
		case horizontal
		case plus
		case ell
		case vertical
		case box
		
		static func shape(at index: Int) -> Shape {
			switch index % 5 {
			case 0: return .horizontal
			case 1: return .plus
			case 2: return.ell
			case 3: return.vertical
			case 4: return .box
			default: exit(1)
			}
		}
		
		var width: Int {
			switch self {
			case .horizontal: return 4
			case .plus, .ell: return 3
			case .vertical: return 1
			case .box: return 2
			}
		}
		
		var height: Int {
			switch self {
			case .horizontal: return 1
			case .plus, .ell: return 3
			case .vertical: return 4
			case .box: return 2
			}
		}
		
		func fill(at coord: Coord) -> [Coord] {
			let coords: [Coord]
			switch self {
			case .horizontal: coords = [(0, 0), (0, 1), (0, 2), (0, 3)].map({ Coord(row: $0.0, col: $0.1) })
			case .plus: coords = [(0, 1), (1, 0), (1, 1), (1, 2), (2, 1)].map({ Coord(row: $0.0, col: $0.1) })
			case .ell: coords = [(0, 0), (0, 1), (0, 2), (1, 2), (2, 2)].map({ Coord(row: $0.0, col: $0.1) })
			case .vertical: coords = [(0, 0), (1, 0), (2, 0), (3, 0)].map({ Coord(row: $0.0, col: $0.1) })
			case .box: coords = [(0, 0), (0, 1), (1, 0), (1, 1)].map({ Coord(row: $0.0, col: $0.1) })
			}
			
			return coords.map({ Coord(row: $0.row + coord.row, col: $0.col + coord.col) })
		}
	}
	
	func solve(input: String, iterations: Int64) -> Int64 {
		let directions: [Character] = [Character](input.split(separator: "\n")[0])
		
		let blankRow: () -> [Cell] = {
			return [Cell(), Cell(), Cell(), Cell(), Cell(), Cell(), Cell()]
		}
		var board: [[Cell]] = []
		
		var currentDirection: Int = 0
		var currentShape: Int = 0
		var topMostRowIndex: Int = 0
		var accumulatedHeight: Int64 = 0
		
		for i in 0..<iterations {
			if i % 500_000 == 0 {
				print("\(String(format: "%02f", 100.00 * (Double(i) / Double(iterations))))%: \(i) out of \(iterations)")
			}
			if currentDirection == 0 && currentShape == 0 {
				print("reset")
			}
			let shape = Shape.shape(at: currentShape)
			
			// Add new rows to perfectly fit 3 empty rows and the height of the shape.
			// Dynamically determine the rows from the current height of the board and our current topMostRowIndex.
			let newRows = 3 + shape.height - (board.count - topMostRowIndex)
			if newRows > 0 {
				for _ in 0..<newRows {
					board.append(blankRow())
				}
			}
			
			// With the available space, fill in the shape with falling cells
			var shapeCoords = shape.fill(at: Coord(row: topMostRowIndex + 3, col: 2))
			for shapeCoord in shapeCoords {
				board[shapeCoord.row][shapeCoord.col].value = .falling
			}
			
			// Print
//			if i < 10 {
//				print(board.reversed().map({ $0.map({ $0.value.rawValue }).joined() }).joined(separator: "\n"))
//				print()
//			}
			
			// With the falling coords, perform the falling logic
			while true {
				// Push by jet
				for shapeCoord in shapeCoords {
					board[shapeCoord.row][shapeCoord.col].value = .empty
				}
				let direction = directions[currentDirection]
				switch direction {
				case "<":
					if !shapeCoords.contains(where: { $0.col == 0 }) {
						// Not bound to wall. Safe to push left.
						let shiftLeftCoords = shapeCoords.map({ Coord(row: $0.row, col: $0.col - 1) })
						if !shiftLeftCoords.contains(where: { board[$0.row][$0.col].value == .resting }) {
							// Not hitting resting rocks. Safe to push left.
							shapeCoords = shiftLeftCoords
						}
					}
				case ">":
					if !shapeCoords.contains(where: { $0.col == 6 }) {
						// Not bound to wall. Safe to push right.
						let shiftRightCoords = shapeCoords.map({ Coord(row: $0.row, col: $0.col + 1) })
						if !shiftRightCoords.contains(where: { board[$0.row][$0.col].value == .resting }) {
							// Not hitting resting rocks. Safe to push right.
							shapeCoords = shiftRightCoords
						}
					}
				default: exit(1)
				}
				for shapeCoord in shapeCoords {
					board[shapeCoord.row][shapeCoord.col].value = .falling
				}
				
				// Choose next direction on next iteration
//				print("Going from currentDirection=\(currentDirection) to currentDirection+1=\(currentDirection+1), %=\(directions.count) -> \((currentDirection+1)%directions.count) ::: \(directions[currentDirection]) to \(directions[(currentDirection+1)%directions.count])")
				currentDirection += 1
				currentDirection %= directions.count
				
				// Print
//				if i < 10 {
//					print(board.reversed().map({ $0.map({ $0.value.rawValue }).joined() }).joined(separator: "\n"))
//					print()
//				}
				
				// Fall down one
				for shapeCoord in shapeCoords {
					board[shapeCoord.row][shapeCoord.col].value = .empty
				}
				let shapeCoordsDownOne = shapeCoords.map({ Coord(row: $0.row - 1, col: $0.col) })
				if shapeCoordsDownOne.contains(where: { $0.row == -1 || board[$0.row][$0.col].value == .resting }) {
					for shapeCoord in shapeCoords {
						board[shapeCoord.row][shapeCoord.col].value = .resting
					}
					topMostRowIndex = board.lastIndex(where: { $0.contains(where: { $0.value == .resting })})! + 1
					break
				} else {
					shapeCoords = shapeCoordsDownOne
					for shapeCoord in shapeCoords {
						board[shapeCoord.row][shapeCoord.col].value = .falling
					}
				}
				
				// Print
//				if i < 10 {
//					print(board.reversed().map({ $0.map({ $0.value.rawValue }).joined() }).joined(separator: "\n"))
//					print()
//				}
			}
			
			// Print
//			if i < 10 {
//				print(board.reversed().map({ $0.map({ $0.value.rawValue }).joined() }).joined(separator: "\n"))
//				print()
//			}
			
			// Iterate to next shape for next rock
			currentShape += 1
			currentShape %= 5
			
			// Cull board
			if let indexToCut = board.lastIndex(where: { $0.allSatisfy({ $0.value == .resting }) }) {
//				print("Culling bottom \(indexToCut) rows out of total \(board.count) rows")
				board = [[Cell]](board[(indexToCut+1)...])
				accumulatedHeight += Int64(indexToCut+1)
				if let i = board.lastIndex(where: { $0.contains(where: { $0.value == .resting })}) {
					topMostRowIndex = i + 1
				} else {
					topMostRowIndex = 0
				}
			}
		}
		
		return accumulatedHeight + Int64(topMostRowIndex)
	}
	
	public func solvePart1(input: String) -> String {
		let result = solve(input: input, iterations: 2022)
		
		return "\(result)"
	}
	
	public func solvePart2(input: String) -> String {
		let result = solve(input: input, iterations: 1_000_000_000_000)
		
		return "\(result)"
	}
	
}
