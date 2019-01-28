# Avoiding Common Attacks

A short list of safety mechanisms implemented in the MEW Store and Marketplace contracts. 

## Integer Overflow

OpenZeppelin's SafeMath contract is imported into the Store contract for all uint256 computations in order to guard against integer flow attacks and treatment of raw user input data.

## Gas Limits

The contracts utilize mappings instead of arrays to not only make loops more efficient but also more mindful of risk posed by such scenarios as gas over-utilization.

## Poison Data

Both MEW contracts, Marketplace and Store, are shielded from potential poison-data causing long strings by modifiers that check the length of incoming string input.

## TX.origin 

Msg.sender is used to pass addresses of, and therefore decide who, the original caller is to Store contract constructors, in lieu of usage of the Tx.origin which can be unreliable.

## Pull Over Push

Ethers sent to MEW store owners use pull over push to mitigate the risks associated with ether transfers. 
