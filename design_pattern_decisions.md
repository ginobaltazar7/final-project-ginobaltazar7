# Design Pattern Decisions

The contracts, Marketplace and Store invite code reviewers with healthily-commented sections to study descriptions of what the various components like functions, structs, etc do.

## Marketplace Contract

The MEW Marketplace contract is the generalized root level, that defines information about MEW Adopters, MEW Store owners and Admins. The storage variables utilize mappings instead of arrays to make looping more efficient.

## Store Contract

The MEW Store contract are what MEW adopters and MEW store owners interact with when they "adopt" MEW products. Each MEW store created is really a Store contract instance. Each instance is responsible for maintaining its balance of ether.

## Emergency Stop

Emergency stops are facilitated at the Store contract level because this is the primary level where adopters and store owners interact.

## Safe Math

OpenZeppelin's library was used to prevent integer flow attacks and perform arithmetic computations responsibly in Store contracts.

