import Foundation

public struct Day08: Challenge {
	
	public init() {}
	
	struct Coord: Equatable, Hashable, CustomStringConvertible, CustomDebugStringConvertible {
		
		let row: Int
		let col: Int
		
		var description: String {
			return "[r:\(row), c:\(col)]"
		}
		
		var debugDescription: String {
			return description
		}
	}
	
	public func solvePart1(input: String) -> String {
		let lines = input.split(separator: "\n")
		let heights = lines.map({ $0.map({ $0.wholeNumberValue! }) })
		
		var visibleCoords: Set<Coord> = []
		var innerVisibleCoords: Set<Coord> = []
		let numRows = heights.count
		let numCols = heights[0].count
		for row in 0..<numRows {
			let coord1 = Coord(row: row, col: 0)
			let coord2 = Coord(row: row, col: numCols-1)
			visibleCoords.formUnion([coord1, coord2])
			
			if row > 0 && row < numRows-1 {
				// Left to right
				var last = heights[row][0]
				for col in 1..<(numCols-1) {
					let coord = Coord(row: row, col: col)
					let current = heights[row][col]
					if current > last {
						innerVisibleCoords.formUnion([coord])
						last = current
					}
				}
				
				// Right to left
				last = heights[row][numCols-1]
				for col in (1..<(numCols-1)).reversed() {
					let coord = Coord(row: row, col: col)
					let current = heights[row][col]
					if current > last {
						innerVisibleCoords.formUnion([coord])
						last = current
					}
				}
			}
		}
		
		for col in 0..<numCols {
			let coord1 = Coord(row: 0, col: col)
			let coord2 = Coord(row: numRows-1, col: col)
			visibleCoords.formUnion([coord1, coord2])
			
			if col > 0 && col < numCols-1 {
				// Up to down
				var last = heights[0][col]
				for row in 1..<(numRows-1) {
					let coord = Coord(row: row, col: col)
					let current = heights[row][col]
					if current > last {
						innerVisibleCoords.formUnion([coord])
						last = current
					}
				}
				
				// Down to up
				last = heights[numRows-1][col]
				for row in (1..<(numRows-1)).reversed() {
					let coord = Coord(row: row, col: col)
					let current = heights[row][col]
					if current > last {
						innerVisibleCoords.formUnion([coord])
						last = current
					}
				}
			}
		}
		
		return "\(visibleCoords.union(innerVisibleCoords).count)"
	}
	
	func scenicScore(heights: [[Int]], coord: Coord) -> Int {
		let numRows = heights.count
		let numCols = heights[0].count
		
		// Up
		let last = heights[coord.row][coord.col]
		var upScore = 0
		for newRow in (0..<coord.row).reversed() {
			let current = heights[newRow][coord.col]
			upScore += 1
			if current >= last {
				break
			}
		}
		
		// Down
		var downScore = 0
		for newRow in (coord.row+1)..<numRows {
			let current = heights[newRow][coord.col]
			downScore += 1
			if current >= last {
				break
			}
		}
		
		// Left
		var leftScore = 0
		for newCol in (0..<coord.col).reversed() {
			let current = heights[coord.row][newCol]
			leftScore += 1
			if current >= last {
				break
			}
		}
		
		// Right
		var rightScore = 0
		for newCol in (coord.col+1)..<numCols {
			let current = heights[coord.row][newCol]
			rightScore += 1
			if current >= last {
				break
			}
		}
		
		return upScore * downScore * leftScore * rightScore
	}
	
	public func solvePart2(input: String) -> String {
		let lines = input.split(separator: "\n")
		let heights = lines.map({ $0.map({ $0.wholeNumberValue! }) })
		
		let numRows = heights.count
		let numCols = heights[0].count
		var score = 0
		for row in 0..<numRows {
			for col in 0..<numCols {
				let newScore = scenicScore(heights: heights, coord: Coord(row: row, col: col))
				if newScore > score {
					score = newScore
				}
			}
		}
		
		return "\(score)"
	}
	
}
