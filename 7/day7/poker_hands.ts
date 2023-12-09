
export interface CardsAndBids {
    cards: string;
    bid: number;
    type: PokerHand;
}

export type PokerHand =
  | 'High Card'
  | 'One Pair'
  | 'Two Pairs'
  | 'Three of a Kind'
  | 'Full House'
  | 'Four of a Kind'
  | 'Five of a Kind'
  | ''

export function scorePokerHand(cards: string): PokerHand {
  const sortedCards = cards.split('').sort().join('');
  const counts: { [key: string]: number } = {};
  for (const card of sortedCards) {
    counts[card] = (counts[card] || 0) + 1;
  }

  const values = Object.values(counts).sort((a, b) => b - a);
  if (values[0] === 5) {
    return 'Five of a Kind';
  }

  if (values[0] === 4) {
    return 'Four of a Kind';
  }

  if (values[0] === 3 && values[1] === 2) {
    return 'Full House';
  }

  if (values[0] === 3) {
    return 'Three of a Kind';
  }

  if (values[0] === 2 && values[1] === 2) {
    return 'Two Pairs';
  }

  if (values[0] === 2) {
    return 'One Pair';
  }

  return 'High Card';
}


export function sortHandsByType(hands: CardsAndBids[]): CardsAndBids[] {
    return hands.sort((a, b) => {
        const typeComparison = pokerHandValue(a.type) - pokerHandValue(b.type);
        if (typeComparison!==0) {
            return typeComparison
        }
        return compareCardStrings(a.cards, b.cards);
    });
  }
  
  // Assign a numerical value to each poker hand type for sorting
  function pokerHandValue(handType: PokerHand): number {
    switch (handType) {
      case 'High Card':
        return 0;
      case 'One Pair':
        return 1;
      case 'Two Pairs':
        return 2;
      case 'Three of a Kind':
        return 3;
      case 'Full House':
        return 4;
      case 'Four of a Kind':
        return 5;
      case 'Five of a Kind':
        return 6;
      default:
        return 0; // Default to High Card if the type is not recognized
    }
  }
  
  //function to do secondary sorting card Strings
  function compareCardStrings(cardStringA: string, cardStringB: string): number {
    const cardStrengthOrder = 'AKQT98765432J';
    for (let i=0; i < cardStringA.length; i++) {
        const cardA = cardStringA[i];
        const cardB = cardStringB[i];
        const strengthA = cardStrengthOrder.indexOf(cardA)
        const strengthB = cardStrengthOrder.indexOf(cardB)
        if (strengthA !== strengthB) {
            return strengthB - strengthA; // Descending order of strength
          }
        }
        return 0; //if all cards are equal, hand is equal

    }