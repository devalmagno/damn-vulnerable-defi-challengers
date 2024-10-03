// SPDX-License-Identifier: MIT
pragma solidity =0.8.25;

import {Test} from "forge-std/Test.sol";

import {DeployUnstoppable} from "script/DeployUnstoppable.s.sol";
import {UnstoppableVault} from "src/unstoppable/UnstoppableVault.sol";
import {UnstoppableMonitor} from "src/unstoppable/UnstoppableMonitor.sol";
import {DamnVulnerableDefiToken} from "src/DamnVulnerableDefiToken.sol";

contract UnstoppableTest is Test {
    DeployUnstoppable deployer;    
    UnstoppableVault vault;
    UnstoppableMonitor monitor;
    DamnVulnerableDefiToken token;

    function setUp() public {
        deployer = new DeployUnstoppable();
        (address vaultAddress, address monitorAddress,,address tokenAddress) = deployer.run();
        vault = UnstoppableVault(vaultAddress);
        monitor = UnstoppableMonitor(monitorAddress);
        token = DamnVulnerableDefiToken(tokenAddress);
    }

    function test() public {
        uint256 amount = vault.maxFlashLoan(address(token));
        assert(amount > 0);
    }
}