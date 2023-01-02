import Foundation

public struct Day18: Challenge {
	
	public init() {}
	
	struct Coord: Hashable {
		let x: Int
		let y: Int
		let z: Int
	}
	
	let directions = Set<Coord>([
		[0, 0, 1],
		[0, 0, -1],
		[0, 1, 0],
		[0, -1, 0],
		[1, 0, 0],
		[-1, 0, 0],
	].map({ Coord(x: $0[0], y: $0[1], z: $0[2]) }))
	
	func countSides(cubes: Set<Coord>) -> Int64 {
		var sides: Int64 = 0
		var seenCubes: Set<Coord> = []
		
		for cube in cubes {
			sides += 6
			
			let matchedSides = directions.filter({ seenCubes.contains(Coord(x: $0.x + cube.x, y: $0.y + cube.y, z: $0.z + cube.z)) })
			sides -= Int64(matchedSides.count) * 2
			
			seenCubes.formUnion([cube])
		}
		
		return sides
	}
	
	public func solvePart1(input: String) -> String {
		let cubes = input
			.split(separator: "\n")
			.map({ line in
				let split = line.components(separatedBy: ",")
				return Coord(x: Int(split[0])!, y: Int(split[1])!, z: Int(split[2])!)
			})
		
		let sides = countSides(cubes: Set<Coord>(cubes))
		
		return "\(sides)"
	}
	
	public func solvePart2(input: String) -> String {
		let cubes = input
			.split(separator: "\n")
			.map({ line in
				let split = line.components(separatedBy: ",")
				return Coord(x: Int(split[0])!, y: Int(split[1])!, z: Int(split[2])!)
			})
		let seenCubes = Set<Coord>(cubes)
		
		// Get bounds
		let minX = cubes.map({ $0.x }).min()! - 1
		let maxX = cubes.map({ $0.x }).max()! + 1
		let minY = cubes.map({ $0.y }).min()! - 1
		let maxY = cubes.map({ $0.y }).max()! + 1
		let minZ = cubes.map({ $0.z }).min()! - 1
		let maxZ = cubes.map({ $0.z }).max()! + 1
		
		// Compute negative space coords
		let allCubesInBounds: Set<Coord> = Set<Coord>((minX...maxX).flatMap({ x in (minY...maxY).flatMap({ y in (minZ...maxZ).map({ z in Coord(x: x, y: y, z: z) }) }) }))
		let emptySpaceCubes = allCubesInBounds.subtracting(seenCubes)
		
		// Make initial hasty clumps of cubes
		var clumps: [Set<Coord>] = []
		for emptySpaceCube in emptySpaceCubes {
			let neighbors = Set<Coord>(directions.map({ Coord(x: $0.x + emptySpaceCube.x, y: $0.y + emptySpaceCube.y, z: $0.z + emptySpaceCube.z) }))
			let touchingClumps = clumps.filter({ !$0.isDisjoint(with: neighbors) })
			if touchingClumps.isEmpty {
				clumps.append(Set<Coord>([emptySpaceCube]))
			} else {
				for touchingClump in touchingClumps {
					clumps.removeAll(where: { $0 == touchingClump })
					let newTouchingClump = touchingClump.union([emptySpaceCube])
					clumps.append(newTouchingClump)
				}
			}
		}
		
		// Reduce clumps into larger clumps
		var i = 0
	outerLoop: while i < clumps.count {
			for j in ((i+1)..<clumps.count) {
				if !clumps[i].isDisjoint(with: clumps[j]) {
					let newClump = clumps[i].union(clumps[j])
					clumps.remove(at: i)
					clumps.remove(at: j - 1)
					clumps.insert(newClump, at: i)
					continue outerLoop
				}
			}
			
			i += 1
		}
		
		// We now have seenCubes, along with separated clumps of negative space coords.
		// The largest of the clumps is the outside space (most likely). All others are assumed to be air pockets.
		// Take total surface area, minus surface area of air pockets
		var sides = countSides(cubes: seenCubes)
		for clump in clumps.sorted(by: { $0.count < $1.count }).reversed().dropFirst() {
			sides -= countSides(cubes: clump)
		}
		
		return "\(sides)"
	}
	
}
