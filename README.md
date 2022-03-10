# Foundry Seminar

join the dev telegram: https://t.me/foundry_rs
join the support telegram: https://t.me/foundry_support
## Agenda
1. wtf is foundry and y it's dope
2. quick setup
3. writing tests
4. fuzzing in foundry & why it's valuable
5. using traces
6. using the debugger
7. future of foundry
8. Q&A
## Intro
### wtf is foundry
"Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust."

Has 2 core utilities:
1. `forge`
2. `cast`

`forge` is primarily what we will cover today, it is an Ethereum smart contract testing framework, like Truffle, Hardhat, and dapptools.

`cast` is a collection of utilities for interacting with smart contracts, endcoding, decoding, and understanding EVM ecosystem semantics.

### why foundry is dope
Think about any language you have ever written -- did you write your tests in another language? How can you expect to master a language when you spend sometimes greater than half your development time writing in another language?

This is one of the core problems foundry aims to solve: write your tests in the same language as your production software.

Context switching also reduces productivity; being able to stay in solidity can speed up development. Speaking of speed, `foundry` is _fast_. _Really freakin' fast_. The benchmarks below are even a little outdated (we got faster :)).


| Project                                             | Forge | DappTools | Speedup |
| --------------------------------------------------- | ----- | --------- | ------- |
| [guni-lev](https://github.com/hexonaut/guni-lev/)   | 28.6s | 2m36s     | 5.45x   |
| [solmate](https://github.com/Rari-Capital/solmate/) | 6s    | 46s       | 7.66x   |
| [geb](https://github.com/reflexer-labs/geb)         | 11s   | 40s       | 3.63x   |
| [vaults](https://github.com/rari-capital/vaults)    | 1.4s  | 5.5s      | 3.9x    |

And it is only getting faster. A new evm backend is being integrated right now and early benchmarks have it close to a 50% speedup.

#### cool features
1. FAST
2. mainnet forking
3. cheatcodes
4. debugger
5. traces
6. fuzzing
7. multi compiler version support

LETS HOP IN!

Repo will be available after the talk.

#### Install & Setup
`curl -L https://foundry.paradigm.xyz | bash`
`foundryup`
`forge init foundry_seminar`

Feel free to follow along :)

