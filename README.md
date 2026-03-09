# Algorithmic Stablecoin Peg Core

This repository contains a high-level implementation of an algorithmic stablecoin protocol. It utilizes a dual-token system (Stablecoin + Share Token) to maintain a soft peg to an external asset (e.g., $1.00 USD) through supply expansion and contraction.

## Mechanism
- **Expansion**: When the price > $1.00, the Treasury mints new stablecoins and distributes them to Share Token stakers.
- **Contraction**: When the price < $1.00, the protocol incentivizes the burning of stablecoins (often via a Bond mechanism) to reduce circulating supply.
- **Epochs**: Rebalancing logic is triggered at fixed time intervals (e.g., every 8 hours).

## Components
- **StableToken**: The pegged asset.
- **ShareToken**: The governance and value-capture asset.
- **Treasury**: The central "brain" that interacts with Oracles to determine supply shifts.

## License
MIT
