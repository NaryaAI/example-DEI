// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {NaryaTest} from "@narya-ai/NaryaTest.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {console} from "lib/forge-std/src/console.sol";

interface IDEI is IERC20 {
    function burnFrom(address account, uint256 amount) external;
}

// https://github.com/SunWeb3Sec/DeFiHackLabs/blob/main/src/test/DEI_exp.sol

contract OnChainDeiTest is NaryaTest {
    IDEI DEI = IDEI(0xDE1E704dae0B4051e80DAbB26ab6ad6c12262DA0);

    address agent;
    address user;

    function setUp() public {
        vm.createSelectFork("https://rpc.ankr.com/arbitrum", 87_626_024);

        agent = getAgent(0);
        user = makeAddr("User");

        require(DEI.allowance(agent, user) == 0);
        require(DEI.allowance(user, agent) == 0);

        deal(address(DEI), user, 1000e18);
        
        targetContract(address(DEI));
        targetAccount(agent);
        targetAccount(user);
    }

    function invariantArbitraryApprove() public {
        // check that a user's allowance hasnt been modified
        require(DEI.allowance(user, agent) == 0, "allowance non zero");
    }
}
