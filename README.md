# Blockchain Term Project

Introduction to Blockchain

Term Project

Saba Fatima - 18556

1) Auction Smart contract

- initiates an Auction
- starts when the contract deploys
- ends after a week
- accepts bids from the participants
- keeps the track of highest payable bid and highest bidder
- withdraws the amount to all the bidders if the owner chooses to cancel
- withdraws the amount to relevant person (owner and highest bidder)

2) ERC20 Smart contract

- ERC20 contract is implemented on IERC20 interface that has all the abstract methods for tokens
- store the address and amount
- transfers amount to another address
- allows another address to transfer owner's amount on his behalf
- keeps allowance for the other address to transfer a certain amount on owner's behalf
- trigger events such as Transfer when transferring the amount
- tiggers events such as Approval to approve another address

3) ICO smart contract

- ICO contract implements ERC20 contract to trade tokens
- has a token price 
- stores record of addresses and their investment
- investment are accepted between a minimun amd maximum range
- investment starts when the contract is deployed
- investment ends after a week
- coin trading starts a week after the inevestment ends
- transfers ERC20 tokens to relevant addresses
- burns owner's ERC20 tokens 


 
