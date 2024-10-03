// SPDX-License-Identifier: MIT
pragma solidity =0.8.25;

import {Script} from "forge-std/Script.sol";

import {UnstoppableVault} from "src/unstoppable/UnstoppableVault.sol";
import {UnstoppableMonitor} from "src/unstoppable/UnstoppableMonitor.sol";
import {DamnVulnerableDefiToken} from "src/DamnVulnerableDefiToken.sol";

contract DeployUnstoppable is Script {
    address public constant ANVIL_DEFAULT_WALLET = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;

    function deploy() public returns (address, address, address, address) {
        vm.startBroadcast();
        DamnVulnerableDefiToken dvt = new DamnVulnerableDefiToken();
        UnstoppableVault vault = new UnstoppableVault({_token: dvt, _owner: ANVIL_DEFAULT_WALLET, _feeRecipient: ANVIL_DEFAULT_WALLET});
        UnstoppableMonitor monitor = new UnstoppableMonitor(address(vault));
        vm.stopBroadcast();
        return (address(vault), address(monitor), ANVIL_DEFAULT_WALLET, address(dvt));
    }

    function run() external returns (address vault, address monitor, address owner, address token) {
        (vault, monitor, owner, token) = deploy();
    }
}
