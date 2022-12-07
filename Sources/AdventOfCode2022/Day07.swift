import Foundation

public struct Day07: Challenge {
	
	public init() {}
	
	public class Folder {
		let name: String
		var subdirs: [Folder] = []
		var files: [String: Int] = [:]
		let parent: Folder?
		
		init(name: String, parent: Folder?) {
			self.name = name
			self.parent = parent
		}
		
		func size() -> Int {
			return files.values.reduce(0, +) + subdirs.map({ $0.size() }).reduce(0, +)
		}
	}
	
	func emulateInput(input: String) -> (Folder, [Folder]) {
		let lines = input.split(separator: "\n")
		let root = Folder(name: "/", parent: nil)
		var current: Folder = root
		var allFolders: [Folder] = [root]
		for line in lines {
			let comps = line.split(separator: " ")
			if comps[0] == "$" {
				switch comps[1] {
				case "cd":
					if comps[2] == "/" {
						current = root
					} else if comps[2] == ".." {
						current = current.parent!
					} else {
						let child = current.subdirs.first(where: { $0.name == comps[2] })
						if let child = child {
							current = child
						} else {
							let subdir = Folder(name: String(comps[2]), parent: current)
							allFolders.append(subdir)
							current.subdirs.append(subdir)
							current = subdir
						}
					}
				case "ls":
					// Nothing
					break
				default:
					exit(1)
				}
			} else {
				if comps[0] == "dir" {
					let child = current.subdirs.first(where: { $0.name == comps[1] })
					if let _ = child {
						// Nothing
					} else {
						let subdir = Folder(name: String(comps[1]), parent: current)
						allFolders.append(subdir)
						current.subdirs.append(subdir)
					}
				} else {
					current.files[String(comps[1])] = Int(comps[0])!
				}
			}
		}
		
		return (root, allFolders)
	}
	
	public func solvePart1(input: String) -> String {
		let (_, allFolders) = emulateInput(input: input)
		
		return "\(allFolders.map({ $0.size() }).filter({ $0 <= 100_000 }).reduce(0, +))"
	}
	
	public func solvePart2(input: String) -> String {
		let (root, allFolders) = emulateInput(input: input)
		let totalSpace = 70_000_000
		let requiredUnusedSpace = 30_000_000
		
		let rootSize = root.size()
		let sortedFodlersBySize = allFolders
			.map({ ($0, $0.size()) })
			.sorted(by: { $0.1 < $1.1 })
		let f = sortedFodlersBySize
			.first(where: { totalSpace - rootSize + $0.1 >= requiredUnusedSpace })
		
		return "\(f!.1)"
	}
	
}
