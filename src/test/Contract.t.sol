// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.12;

import "ds-test/test.sol";
import "forge-std/Vm.sol";
import "solmate/test/utils/mocks/MockERC20.sol";
import "../Contract.sol";


contract TokenReturner {
    uint256 return_amount;
    function receiveTokens(address tokenAddress, uint256 /* amount */) external {
        // all we do is transfer the return_amount back :)
        ERC20(tokenAddress).transfer(msg.sender, return_amount);
    }
}


contract ContractTest is DSTest, TokenReturner {
    Vm vm = Vm(HEVM_ADDRESS);

    address alice = address(0x1337);
    address bob = address(0x133702);

    MockERC20 token;
    Flashloaner loaner;

    // effectively a "beforeEach" block
    function setUp() public {
        vm.label(alice, "Alice");
        vm.label(bob, "Bob");
        vm.label(address(this), "TestContract");

        token = new MockERC20("TestToken", "TT0", 18);
        vm.label(address(token), "TestToken");

        loaner = new Flashloaner(address(token));

        token.mint(address(this), 1e18);

        token.approve(address(loaner), 100);
        loaner.depositTokens(100);
    }

    function test_ConstructNonZeroTokenRevert() public {
        vm.expectRevert(Flashloaner.TokenAddressCannotBeZero.selector);
        new Flashloaner(address(0x0));
    }

    function test_poolBalance() public {
        token.approve(address(loaner), 1);
        loaner.depositTokens(1);
        assertEq(loaner.poolBalance(), 101);
        assertEq(token.balanceOf(address(loaner)), loaner.poolBalance());
    }

    function test_DepositNonZeroAmtRevert() public {
        vm.expectRevert(Flashloaner.MustDepositOneTokenMinimum.selector);
        loaner.depositTokens(0);
    }

    function test_BorrowZeroRevert() public {
        vm.expectRevert(Flashloaner.MustBorrowOneTokenMinimum.selector);
        loaner.flashLoan(0);
    }

    function test_BorrowMoreRevert() public {
        vm.expectRevert(Flashloaner.NotEnoughTokensInPool.selector);
        loaner.flashLoan(2**250);
    }

    function test_ReturnAmountRevert() public {
        vm.expectRevert(Flashloaner.FlashLoanHasNotBeenPaidBack.selector);
        return_amount = 0;
        loaner.flashLoan(100);
    }

    function test_flashloan() public {
        // we want to borrow and return right away
        return_amount = 100;
        loaner.flashLoan(100);
        assertEq(loaner.poolBalance(), 100);
        assertEq(token.balanceOf(address(loaner)), loaner.poolBalance());
    }

    function test_onlyOwnerRevert() public {
        vm.startPrank(bob);
        vm.expectRevert("!owner");
        loaner.updateOwner(bob);
        loaner.echoSender();
        vm.stopPrank();
    }

    function testFuzz_deposit(uint256 amount) public {
        vm.assume(type(uint256).max - amount >= token.totalSupply());
        vm.assume(amount > 0);

        token.mint(address(this), amount);
        token.approve(address(loaner), amount);

        uint256 prebal = token.balanceOf(address(loaner));
        loaner.depositTokens(amount);
        
        assertEq(loaner.poolBalance(), prebal + amount);
        assertEq(token.balanceOf(address(loaner)), loaner.poolBalance());
    }

    function testFuzz_FlashLoan(uint256 borrow_amount, uint256 _return_amount) public {
        vm.assume(borrow_amount  > 0);
        vm.assume(_return_amount <= token.balanceOf(address(this)));
        vm.assume(borrow_amount  <= _return_amount);
        vm.assume(borrow_amount  <= token.balanceOf(address(loaner)));

        return_amount = _return_amount;
        loaner.flashLoan(borrow_amount);
        assertEq(token.balanceOf(address(loaner)), loaner.poolBalance());
    }

    function test_BrokenFlashloan() public {
        return_amount = 2;
        loaner.flashLoan(1);
        assertEq(token.balanceOf(address(loaner)), loaner.poolBalance());
    }

}