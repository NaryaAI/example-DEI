// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {NaryaTest} from "@narya-ai/NaryaTest.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {console} from "lib/forge-std/src/console.sol";
import {DEIStablecoin} from "src/LDEI/LDEI.sol";

// https://github.com/SunWeb3Sec/DeFiHackLabs/blob/main/src/test/DEI_exp.sol

contract DeiTest is NaryaTest {
    DEIStablecoin DEI;

    address agent;
    address user;

    function setUp() public {
        DEI = new DEIStablecoin();

        agent = getAgent(0);
        user = makeAddr("User");

        require(DEI.allowance(agent, user) == 0);
        require(DEI.allowance(user, agent) == 0);

        deal(address(DEI), user, 1000e18);
        
        targetAccount(agent);
        targetAccount(user);
    }

    function invariantArbitraryApprove() public {
        // check that a user's allowance hasnt been modified
        require(DEI.allowance(user, agent) == 0, "allowance non zero");
    }
}
