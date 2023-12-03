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
	sumOfResults := 0
	for _, line := range lines {
		parsed, _ := splitGamesIntoSubgames(line)
		result := findHighestNumbers(parsed, []string{"red", "blue", "green"})
		fmt.Println(result)

		multiResult := 1 //init base for multiplication
		for _, num := range result {
			multiResult *= num
		} 
		fmt.Println(multiResult)
		sumOfResults += multiResult
	}
	fmt.Println("Final result is ==> %v", sumOfResults)
	
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
func splitGamesIntoSubgames(input string) ([][]string, error) {
	// Split the input game into individual Subgames based on semicolons.
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


// Function to find the highest number for each colour in the specified order across multiple Subgames.
func findHighestNumbers(subgames [][]string, coloursOrder []string) []int {
	// Create a map to store the highest number for each colour.
	highestNumbers := make(map[string]int)

	// Iterate over the Subgames of strings
	for _, set := range subgames {
		for _, item := range set {
			parts := strings.Fields(item)

			if len(parts) == 2 {
				colour := parts[1]
				count, err := strconv.Atoi(parts[0])
				if err == nil {
					// Update the highest number for the colour if the current count is greater.
					if count > highestNumbers[colour] {
						highestNumbers[colour] = count
					}
				}
			}
		}
	}

	// Create a result slice based on the specified order of colours.
	var result []int
	for _, colour := range coloursOrder {
		result = append(result, highestNumbers[colour])
	}

	return result
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
