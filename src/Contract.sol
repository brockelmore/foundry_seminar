// SPDX-License-Identifier: MIT
pragma solidity 0.8.12;

import {ERC20} from "solmate/tokens/ERC20.sol";
import {ReentrancyGuard} from "solmate/utils/ReentrancyGuard.sol";

// adapted from https://github.com/nicolasgarcia214/damn-vulnerable-defi-foundry
contract Flashloaner is ReentrancyGuard {
    ERC20 public immutable damnValuableToken;
    uint256 public poolBalance;

    address owner;

    modifier onlyOwner {
        require(msg.sender == owner, "!owner");
        _;
    }
    
    error TokenAddressCannotBeZero();

    constructor(address tokenAddress) {
        if (tokenAddress == address(0)) revert TokenAddressCannotBeZero();
        damnValuableToken = ERC20(tokenAddress);
        owner = msg.sender;
    }

    error MustDepositOneTokenMinimum();

    function depositTokens(uint256 amount) external nonReentrant {
        if (amount == 0) revert MustDepositOneTokenMinimum();
        // Transfer token from sender. Sender must have first approved them.
        damnValuableToken.transferFrom(msg.sender, address(this), amount);
        poolBalance = poolBalance + amount;
    }

    error MustBorrowOneTokenMinimum();
    error NotEnoughTokensInPool();
    error FlashLoanHasNotBeenPaidBack();

    function flashLoan(uint256 borrowAmount) external nonReentrant {
        if (borrowAmount == 0) revert MustBorrowOneTokenMinimum();

        uint256 balanceBefore = damnValuableToken.balanceOf(address(this));
        if (balanceBefore < borrowAmount) revert NotEnoughTokensInPool();

        // Ensured by the protocol via the `depositTokens` function
        assert(poolBalance == balanceBefore);

        damnValuableToken.transfer(msg.sender, borrowAmount);

        IReceiver(msg.sender).receiveTokens(
            address(damnValuableToken),
            borrowAmount
        );

        uint256 balanceAfter = damnValuableToken.balanceOf(address(this));
        if (balanceAfter < balanceBefore) revert FlashLoanHasNotBeenPaidBack();
        poolBalance = balanceAfter;
    }

    function updateOwner(address newOwner) public onlyOwner {
        owner = newOwner;
    }

    function echoSender() public view returns (address) {
        return msg.sender;
    }
}

interface IReceiver {
    function receiveTokens(address tokenAddress, uint256 amount) external;
}
