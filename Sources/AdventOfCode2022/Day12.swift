import Foundation

public struct Day12: Challenge {
	
	public init() {}
	
	struct Coord: Hashable {
		let row: Int
		let col: Int
	}
	
	class Cell {
		let ascii: Character
		let value: Int
		let isStart: Bool
		let isEnd: Bool
		var stepsToEnd: Int?
		var direction: Character?
		
		init(value: Character) {
			self.ascii = value
			var val = value
			if val == "S" {
				self.isStart = true
				self.isEnd = false
				val = "a"
			} else if val == "E" {
				self.isStart = false
				self.isEnd = true
				val = "z"
			} else {
				self.isStart = false
				self.isEnd = false
			}
			self.value = Int(val.asciiValue!)
			self.stepsToEnd = nil
		}
	}
	
	public func solvePart1(input: String) -> String {
		let cells = input
			.split(separator: "\n")
			.map({ [Cell]($0.map({ Cell(value: $0) })) })
		
		let startRow = cells.enumerated().first(where: { $0.1.contains(where: { $0.isStart }) })!.0
		let startCol = cells[startRow].enumerated().first(where: { $0.1.isStart })!.0
		let startCoord = Coord(row: startRow, col: startCol)
		let endRow = cells.enumerated().first(where: { $0.1.contains(where: { $0.isEnd }) })!.0
		let endCol = cells[endRow].enumerated().first(where: { $0.1.isEnd })!.0
		let endCoord = Coord(row: endRow, col: endCol)
		
		let dirs: [(Int, Int)] = [(0, -1), (0, 1), (1, 0), (-1, 0)]
		var coordsToProcess: [Coord] = [endCoord]
		outer: while !coordsToProcess.isEmpty {
			let coord = coordsToProcess.first!
			let dirCoords: [Coord] = dirs
				.map({ Coord(row: coord.row + $0.0, col: coord.col + $0.1) })
				.filter({ 0 <= $0.row && $0.row < cells.count && 0 <= $0.col && $0.col < cells[0].count })
			if coord == endCoord {
				cells[coord.row][coord.col].stepsToEnd = 0
				_ = coordsToProcess.removeFirst()
				coordsToProcess.append(contentsOf: dirCoords.filter({ cells[$0.row][$0.col].stepsToEnd == nil }))
			} else {
				let cell = cells[coord.row][coord.col]
				let neighborsInOrder: [(Coord, Cell)] = dirCoords
					.map({ ($0, cells[$0.row][$0.col]) })
					.filter({ $0.1.stepsToEnd != nil && (cell.value == $0.1.value || cell.value + 1 == $0.1.value || cell.value > $0.1.value) })
					.sorted(by: { $0.1.stepsToEnd ?? 0 < $1.1.stepsToEnd ?? 0 })
				if let best = neighborsInOrder.first {
					cell.stepsToEnd = best.1.stepsToEnd! + 1
					_ = coordsToProcess.removeFirst()
					coordsToProcess.removeAll(where: { $0 == coord })
					coordsToProcess.append(contentsOf: dirCoords.filter({ cells[$0.row][$0.col].stepsToEnd == nil }))
					
					if cell.isStart {
						break outer
					} else {
						continue outer
					}
				}
				coordsToProcess.append(coordsToProcess.removeFirst()) // No matches, pop and requeue to end
			}
		}
		
//		print(cells.map({ String($0.map({ String(format: "%03d", $0.stepsToEnd ?? -1) }).joined(separator: " ")) }).joined(separator: "\n"))
		
		return "\(cells[startCoord.row][startCoord.col].stepsToEnd ?? 0)"
	}
	
	public func solvePart2(input: String) -> String {
		let cells = input
			.split(separator: "\n")
			.map({ [Cell]($0.map({ Cell(value: $0) })) })
		
		let startRow = cells.enumerated().first(where: { $0.1.contains(where: { $0.isStart }) })!.0
		let startCol = cells[startRow].enumerated().first(where: { $0.1.isStart })!.0
		let startCoord = Coord(row: startRow, col: startCol)
		let endRow = cells.enumerated().first(where: { $0.1.contains(where: { $0.isEnd }) })!.0
		let endCol = cells[endRow].enumerated().first(where: { $0.1.isEnd })!.0
		let endCoord = Coord(row: endRow, col: endCol)
		
		let dirs: [(Int, Int)] = [(0, -1), (0, 1), (1, 0), (-1, 0)]
		var coordsToProcess: [Coord] = [endCoord]
		outer: while !coordsToProcess.isEmpty {
			let coord = coordsToProcess.first!
			let dirCoords: [Coord] = dirs
				.map({ Coord(row: coord.row + $0.0, col: coord.col + $0.1) })
				.filter({ 0 <= $0.row && $0.row < cells.count && 0 <= $0.col && $0.col < cells[0].count })
			if coord == endCoord {
				cells[coord.row][coord.col].stepsToEnd = 0
				_ = coordsToProcess.removeFirst()
				coordsToProcess.append(contentsOf: dirCoords.filter({ cells[$0.row][$0.col].stepsToEnd == nil }))
			} else {
				let cell = cells[coord.row][coord.col]
				let neighborsInOrder: [(Coord, Cell)] = dirCoords
					.map({ ($0, cells[$0.row][$0.col]) })
					.filter({ $0.1.stepsToEnd != nil && (cell.value == $0.1.value || cell.value + 1 == $0.1.value || cell.value > $0.1.value) })
					.sorted(by: { $0.1.stepsToEnd ?? 0 < $1.1.stepsToEnd ?? 0 })
				if let best = neighborsInOrder.first {
					cell.stepsToEnd = best.1.stepsToEnd! + 1
					_ = coordsToProcess.removeFirst()
					coordsToProcess.removeAll(where: { $0 == coord })
					coordsToProcess.append(contentsOf: dirCoords.filter({ cells[$0.row][$0.col].stepsToEnd == nil }))
					
					if cell.ascii == "a" {
						return String(cell.stepsToEnd!)
					} else {
						continue outer
					}
				}
				coordsToProcess.append(coordsToProcess.removeFirst()) // No matches, pop and requeue to end
			}
		}
		
		return "error"
	}
	
}
