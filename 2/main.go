package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"strings"
	"strconv"
)

func main() {
	filename := "input.txt"

	lines, err := readAndSplitLines(filename)
	if err != nil {
		log.Fatalf("Error reading file: %v", err)
		return
	}

	idSum := 0

	for linecount, line := range lines {
		parsed, _ := splitGamesIntoSets(line)
		var isPossible []bool
		for _, set := range parsed {
			isPossible = append(isPossible,checkCubeSet(set))
		}
		if all(isPossible) {
			idSum += linecount+1
		}
		fmt.Println(idSum)
	}
	
}


// Function to read a file and split its contents into a list of strings.
func readAndSplitLines(filename string) ([]string, error) {
	// Read the entire file into a byte slice.
	content, err := ioutil.ReadFile(filename)
	if err != nil {
		return nil, err
	}

	// Convert the byte slice to a string.
	fileContent := string(content)

	// Split the string into individual lines based on newline characters.
	lines := strings.Split(fileContent, "\n")
	for i, line := range(lines) {
		lines[i] = removePrefixUpToColon(line)
	}
	// Filter out empty lines.
	var nonEmptyLines []string
	for _, line := range lines {
		trimmedLine := strings.TrimSpace(line)
		if trimmedLine != "" {
			nonEmptyLines = append(nonEmptyLines, trimmedLine)
		}
	}

	return nonEmptyLines, nil
}
// Function to split a string into a list of lines.
func splitGamesIntoSets(input string) ([][]string, error) {
	// Split the input game into individual sets based on semicolons.
	lines := strings.Split(input, ";")

	// Initializing a nested list to store the result.
	nestedList := make([][]string, len(lines))

	// Trim leading and trailing whitespaces from each line and split into individual items.
	for i, line := range lines {
		items := strings.Split(strings.TrimSpace(line), ",")
		for j, item := range items {
			// Trim whitespaces from each item.
			items[j] = strings.TrimSpace(item)
		}
		nestedList[i] = items
	}

	return nestedList, nil
}

// Function to parse a line into a map without using regex.
func parseLine(line string) (map[string]int, error) {
	// Split the line into individual parts based on commas.
	parts := strings.Split(line, ",")

	// Initializing a map to store the result.
	result := make(map[string]int)

	// Iterating through parts and updating the map.
	for _, part := range parts {
		// Split each part into count and colour.
		fields := strings.Fields(part)

		if len(fields) != 2 {
			return nil, fmt.Errorf("invalid format: %s", part)
		}

		count, err := strconv.Atoi(fields[0])
		if err != nil {
			return nil, fmt.Errorf("failed to convert count to integer: %v", err)
		}

		colour := fields[1] // Convert the colour to lowercase for consistency.

		// Update the map with colour and count.
		result[colour] = count
	}

	return result, nil
}


// Function to check conditions for a given count and colour.
func checkCubeColour(input string) bool {
	// Split the input string into count and colour.
	//fmt.Println(input)
	parts := strings.Fields(input)

	if len(parts) != 2 {
		// Invalid format
		return false
	}

	count := parseCount(parts[0])
	colour := parts[1]

	// Check conditions based on colour
	switch colour {
	case "blue":
		return count < 15
	case "red":
		return count < 13
	case "green":
		return count < 14
	default:
		// Unsupported colour
		return false
	}
}

// Function to parse the count from a string and handle errors.
func parseCount(countStr string) int {
	count, err := strconv.Atoi(countStr)
	if err != nil {
		// Handle parsing error, e.g., return a default value or log the error.
		return 0
	}
	return count
}

// Function to check conditions for a list of count and color strings.
func checkCubeSet(stringsList []string) bool {
	var conditions []bool
	for _, str := range stringsList {
		conditions = append(conditions, checkCubeColour(str))
		//fmt.Println(checkCubeColour(str))
	}
	fmt.Println(all(conditions))
	return all(conditions)
}

func all(values []bool) bool {
    for _, v := range values {
        if !v {
            return false
        }
    }
    return true
}

func removePrefixUpToColon(line string) string {
	// Split the line after the first colon.
	parts := strings.SplitAfterN(line, ": ", 2)

	if len(parts) > 1 {
		// Join the remaining parts (excluding the colon) into a new string.
		return strings.Join(parts[1:], "")
	}

	// If no colon is found, return the original line.
	return line
}