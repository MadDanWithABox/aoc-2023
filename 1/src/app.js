const express = require('express');
const bodyParser = require('body-parser');
const fs = require('fs');


const app = express();
const port = 4000;

app.use(bodyParser.text());


function findFirstAndFinalNumber(line) {
  // Func to check if char is a number
  const isNum = (char) => '1234567890'.includes(char);

  //Find first number
  const firstNumIndex = line.split('').findIndex(isNum);
  const firstNumber = firstNumIndex !== -1 ? line[firstNumIndex] : NaN;

  // Find last number
  const lastNumIndex = line.split('').reverse().findIndex(isNum);
  const lastNumber = lastNumIndex !== -1 ? line[line.length - 1 - lastNumIndex] : NaN;
  return { firstNumber, lastNumber };
}

function parseNumbersFromString(inputString) {
  const numberWordsMapping = {
    'one': '1',
    'two': '2',
    'three': '3',
    'four': '4',
    'five': '5',
    'six': '6',
    'seven': '7',
    'eight': '8',
    'nine': '9'
  };

  let result = '';
  let currentWord = '';

  for (const char of inputString) {
    currentWord += char.toLowerCase();

    // Check if the current word is a number word
    for (const word in numberWordsMapping) {
      if (currentWord.endsWith(word)) {
        // Replace the matched word with its corresponding digit
        result = result.slice(0, -word.length) + numberWordsMapping[word];
        currentWord = ''; // Reset the current word
        break; // Break out of the inner loop once a match is found
      }
    

      // If the current character doesn't match any number word, append it to the result
      else if (!currentWord.endsWith(word)) {
        result += char;
    }
  }}

  return result;
}


function sumNumbers(numbers) {
  return numbers.reduce((total, num) => total + parseInt(num, 10) || 0, 0);
}

app.post('/readfile', (req, res) => {
  const filePath = req.body;
  console.log('Received filepath:', filePath);

  if (!filePath) {
    return res.status(400).send('Please provide a file path.');
  }

  fs.readFile(filePath, 'utf8', (err, data) => {
    if (err) {
      console.error('Error reading the file:', err);
      return res.status(500).send('Error reading the file.');
    }
    const lines = data.split('\n');
    let numArray = [];

    for (let line of lines) {
      let converted = parseNumbersFromString(line)
      
      const { firstNumber, lastNumber } = findFirstAndFinalNumber(converted);
      if (!isNaN(firstNumber) && !isNaN(lastNumber)) {
        numArray.push(firstNumber + lastNumber);
      }
    }

    let finalResult = sumNumbers(numArray);
    console.log(finalResult);
    res.send("hi");
  });
});

app.listen(port, () => {
  console.log(`Server is running at http://localhost:${port}`);
});
