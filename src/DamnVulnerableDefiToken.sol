// SPDX-License-Identifier: MIT
pragma solidity =0.8.25;

import {ERC20} from "@solmate/tokens/ERC20.sol";

contract DamnVulnerableDefiToken is ERC20 {
    constructor() ERC20("Damn Vulnerable Defi", "DVT", 18) {
        _mint(msg.sender, type(uint256).max);
    }
}
