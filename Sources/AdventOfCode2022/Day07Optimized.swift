import Foundation

public struct Day07Optimized: Challenge {
	
	public init() {}
	
	public class Folder {
		let name: String
		var subdirs: [String: Folder] = [:]
		var files: [String: Int] = [:]
		let parent: Folder?
		var size: Int = 0
		
		init(name: String, parent: Folder?) {
			self.name = name
			self.parent = parent
		}
		
		func addFile(name: String, size: Int) {
			if let _ = files[name] {
				// Nothing
			} else {
				files[name] = size
				self.size += size
				
				var current = parent
				while let folder = current {
					folder.size += size
					current = folder.parent
				}
			}
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
						let subdirName = String(comps[2])
						let child = current.subdirs[subdirName]
						if let child = child {
							current = child
						} else {
							let subdir = Folder(name: subdirName, parent: current)
							allFolders.append(subdir)
							current.subdirs[subdirName] = subdir
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
					let subdirName = String(comps[1])
					let child = current.subdirs[subdirName]
					if let _ = child {
						// Nothing
					} else {
						let subdir = Folder(name: subdirName, parent: current)
						allFolders.append(subdir)
						current.subdirs[subdirName] = subdir
					}
				} else {
					current.addFile(name: String(comps[1]), size: Int(comps[0])!)
				}
			}
		}
		
		return (root, allFolders)
	}
	
	public func solvePart1(input: String) -> String {
		let (_, allFolders) = emulateInput(input: input)
		
		return "\(allFolders.map({ $0.size }).filter({ $0 <= 100_000 }).reduce(0, +))"
	}
	
	public func solvePart2(input: String) -> String {
		let (root, allFolders) = emulateInput(input: input)
		let totalSpace = 70_000_000
		let requiredUnusedSpace = 30_000_000
		
		let rootSize = root.size
		let sortedFoldersBySize = allFolders
			.map({ ($0, $0.size) })
			.filter({ totalSpace - rootSize + $0.1 >= requiredUnusedSpace })
			.sorted(by: { $0.1 < $1.1 })
		
		return "\(sortedFoldersBySize.first!.1)"
	}
	
}
