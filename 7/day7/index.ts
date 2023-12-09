// index.ts
import express, { Request, Response } from 'express';
import cors from 'cors';
import {PokerHand, scorePokerHand, CardsAndBids, sortHandsByType} from './poker_hands'

const app = express();
const port = 8888;

app.use(cors());
app.use(express.json());


function calculateSum(numbers: (number)[]): BigInt {
    return numbers.reduce((sum, num) => {
      if (typeof num === 'number') {
        return sum + BigInt(num);
      } else {
        return sum + num;
      }
    }, BigInt(0));
  }

function solve(inputs: string[]): CardsAndBids[] {
    let hands: CardsAndBids[] = [];
    for (let i in inputs) {
        let res: CardsAndBids = getCardsAndBids(inputs[i])
        hands.push(res)
        let score = scorePokerHand(res.cards)
        res.type = score
    }
    return sortHandsByType(hands)
}

function getCardsAndBids(input_line: string): CardsAndBids {
    const regex = /\b(\d+)\s*$/;
    let cards: string = input_line.slice(0,5)
    let match = input_line.match(regex);
    let bid: number = match ? parseInt(match[1]) : NaN;
    let type: PokerHand = ''
    return {cards,bid, type}

}



app.post('/solve', (req: Request, res: Response) => {
    const userInput: string = req.body.input;
    // Perform solve logic here
    let hands = userInput.split('\n')
    let solved: CardsAndBids[] = solve(hands)
    let winnings: any[]= []
    for (let i in solved) {
        //let win: number = parseInt(i)+1 * solved[i].bid 
        //let win = parseInt(i)+1
        let win = solved[i].bid * (parseInt(i)+1)
        winnings.push(win)
    }
    
    res.send({"result": winnings});
});

app.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);
});

