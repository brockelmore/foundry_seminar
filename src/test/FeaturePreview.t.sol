// SPDX-License-Identifier: MIT
pragma solidity 0.8.12;

import "ds-test/test.sol";
import "../FeaturePreview.sol";

contract InvariantTest is DSTest {
    Test test;

    function setUp() public {
        test = new Test();
    }

    function invariant_neverFalse() public {
        require(test.flag1());
    }
}



import "forge-std/Vm.sol";


contract StateOwner {
    address private owner;

    constructor(address _owner) {
        owner = _owner;
    }

    function onlyOwner() public {
        require(msg.sender == owner, "NotOwner");
    }
}

contract BytecodeLiftingTest is DSTest {
    Vm vm = Vm(HEVM_ADDRESS);

    StateOwner state_owner;
    function setUp() public {
        state_owner = new StateOwner(address(0x12341234));
    }

    function testFuzz_stateOwner(address randomSender) public {
        vm.expectRevert("NotOwner");
        vm.prank(randomSender);
        state_owner.onlyOwner();
    }

    function testGarbage(bytes memory garbage) public {
        if (
            (garbage.length < 32 ||
                (garbage[0] != 0 ||
                    garbage[1] != 0 ||
                    garbage[2] != 0 ||
                    garbage[3] != 0 ||
                    garbage[4] != 0 ||
                    garbage[5] != 0 ||
                    garbage[6] != 0 ||
                    garbage[7] != 0 ||
                    garbage[8] != 0 ||
                    garbage[9] != 0 ||
                    garbage[10] != 0 ||
                    garbage[11] != 0 ||
                    garbage[12] != 0 ||
                    garbage[13] != 0 ||
                    garbage[14] != 0 ||
                    garbage[15] != 0 ||
                    garbage[16] != 0 ||
                    garbage[17] != 0 ||
                    garbage[18] != 0 ||
                    garbage[19] != 0 ||
                    garbage[20] != 0 ||
                    garbage[21] != 0 ||
                    garbage[22] != 0 ||
                    garbage[23] != 0 ||
                    garbage[24] != 0 ||
                    garbage[25] != 0 ||
                    garbage[26] != 0 ||
                    garbage[27] != 0 ||
                    garbage[28] != 0 ||
                    garbage[29] != 0 ||
                    garbage[30] != 0 ||
                    garbage[31] != bytes1(0x91)))
        ) return;
        revert();
    }
}