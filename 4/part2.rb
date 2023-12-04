def read_file_and_split(file_path)
    begin
        # Read the contents of the file and split into an array of lines
        lines = File.readlines(file_path)
        return lines
    rescue StandardError => e
        # Handle exceptions, such as file not found or permission issues
        puts "Error reading the file: #{e.message}"
        return nil
    end
end
  

def process_line(line)
    # Find the index of the colon
    colon_index = line.index(':')
  
    if colon_index
        # Extract the substring after the colon
        after_colon = line[(colon_index + 1)..].strip
        
        parts = after_colon.split('|').map(&:strip)

        # Split the parts into a list of numbers
        numbers_lists = parts.map { |part| part.split.map(&:to_i) }
        return numbers_lists
    else
        # Return an empty array if no colon is found
        return []
    end
end
file_path = 'input.txt'
#file_path = 'demo.txt'

# Call the function and get the array of lines
lines_array = read_file_and_split(file_path)


# Check if the file was read successfully
if lines_array
    cards = Array.new(lines_array.length, 1)
    points = 0
    # Display each line
    lines_array.each_with_index do |line, index|
        processed = process_line(line)
        winners = processed[0]
        yours = processed[1]
        matches = winners & yours
        if matches.length > 0
            points += 2**(matches.length-1)
        end
        matches.length.times do |i|
            cards[index + i + 1] += cards[index]
        end
    
    end
    puts cards.sum
else
    puts "File reading failed."
end


