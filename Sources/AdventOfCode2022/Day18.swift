import Foundation

public struct Day18: Challenge {
	
	public init() {}
	
	struct Coord: Hashable {
		let x: Int
		let y: Int
		let z: Int
	}
	
	public func solvePart1(input: String) -> String {
		let cubes = input
			.split(separator: "\n")
			.map({ line in
				let split = line.components(separatedBy: ",")
				return Coord(x: Int(split[0])!, y: Int(split[1])!, z: Int(split[2])!)
			})
		
		var directions2: [[Int]] = [
			[0, 0, 1],
			[0, 0, -1],
			[0, 1, 0],
			[0, -1, 0],
			[1, 0, 0],
			[-1, 0, 0],
		]
		let directions = Set<Coord>(directions2.map({ Coord(x: $0[0], y: $0[1], z: $0[2]) }))
		
		var sides: Int64 = 0
		var seenCubes: Set<Coord> = []
		
		for cube in cubes {
			sides += 6
			
			let matchedSides = directions.filter({ seenCubes.contains(Coord(x: $0.x + cube.x, y: $0.y + cube.y, z: $0.z + cube.z)) })
			sides -= Int64(matchedSides.count) * 2
			
			seenCubes.formUnion([cube])
		}
		
		return "\(sides)"
	}
	
	public func solvePart2(input: String) -> String {
		return ""
	}
	
}
