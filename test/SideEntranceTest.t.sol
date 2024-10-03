// SPDX-License-Identifier: MIT
pragma solidity =0.8.25;

import {Test} from "forge-std/Test.sol";

import {SideEntranceLenderPool} from "src/side-entrance/SideEntranceLenderPool.sol";
import {AttackSideEntranceLenderPool} from "src/side-entrance/AttackSideEntranceLenderPool.sol";

contract SideEntranceTest is Test {
    SideEntranceLenderPool public sideEntrance;
    AttackSideEntranceLenderPool public attacker;

    address public exploiter = makeAddr("exploiter");
    uint256 public constant TOTAL_BALANCE = 1000 ether;

    function setUp() external {
        sideEntrance = new SideEntranceLenderPool();
        attacker = new AttackSideEntranceLenderPool(address(sideEntrance), exploiter);
        vm.deal(address(sideEntrance), TOTAL_BALANCE);
    }

    function test_reentrancyAttack() public {
        attacker.attack(TOTAL_BALANCE);
        attacker.transferMoney();

        assertEq(exploiter.balance, TOTAL_BALANCE);
    }
}
