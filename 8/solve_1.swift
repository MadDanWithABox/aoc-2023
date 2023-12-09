import Foundation

func readAndSplitFile(filePath: String) -> [String] {
    do {
        let fileContent = try String(contentsOfFile: filePath, encoding: .utf8)
        let lines = fileContent.components(separatedBy: "\n")
        let nonEmptyLines = lines.filter { !$0.isEmpty }
        return nonEmptyLines
    } catch {
        print("Error reading file")
        return []
    }
}

func parseString(input: String) -> [String: (String, String)]? {
    // Split the input string by "="
    let components = input.components(separatedBy: "=")
    
    // Ensure that there are two components (key and value)
    guard components.count == 2 else {
        return nil
    }
    
    // Trim whitespace from the key and value
    let key = components[0].trimmingCharacters(in: .whitespaces)
    let valueString = components[1].trimmingCharacters(in: .whitespaces)
    
    // Ensure that the value string starts with "(" and ends with ")"
    guard valueString.hasPrefix("("), valueString.hasSuffix(")") else {
        return nil
    }
    
    // Extract the values between "(" and ")"
    let valueComponents = valueString.dropFirst().dropLast().components(separatedBy: ",")
    
    // Ensure that there are two values
    guard valueComponents.count == 2 else {
        return nil
    }
    
    // Trim whitespace from each value
    let valueTuple: (String, String) = (
        valueComponents[0].trimmingCharacters(in: .whitespaces),
        valueComponents[1].trimmingCharacters(in: .whitespaces)
    )
    
    // Create and return the dictionary
    let result = [key: valueTuple]
    return result
}


let filePath = "input.txt"
let lines = readAndSplitFile(filePath: filePath)
var instructions = lines[0]
let linesArray = lines[1..<lines.count]
var nodesDict = [String: (String, String)]() 

for line in linesArray {
    if let parsed = parseString(input: line) {
        nodesDict.merge(parsed) { $1 }
    } else {
        print("Invalid input")
    }
}
var traversals = 0
var found = false
var nodeValue = nodesDict["AAA"]
if nodeValue == nil {
    print("Invalid starting node")
} else {
    while !found {
        
        outerLoop: for char in instructions {
            guard let currentNodeValue = nodeValue else {
                print("Invalid node value")
                break
            }

            let nodePair = nodesDict.first { $0.value == currentNodeValue }
            let nodeKey = nodePair?.key
            print(nodeKey!)
            if nodeKey == "ZZZ" {
                print(traversals)
                break outerLoop
                found = true
            } else if char == "L" {
                nodeValue = nodesDict[currentNodeValue.0]
            } else {
                nodeValue = nodesDict[currentNodeValue.1]
            }

            traversals += 1
            print(traversals)
        }
    }
}