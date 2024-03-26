// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {TokenSwap} from "../src/TokenSwap.sol";

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract CounterTest is Test {
    TokenSwap public tokenSwap;

    address ETHUSDAddress = 0x694AA1769357215DE4FAC081bf1f309aDC325306;
    address LINKUSDAddress = 0xc59E3633BAAC79493d908e63626716e204A45EdF;
    address DIAUSD = 0x14866185B1962B63C3Ea9E03Bc1da838bab34C19;

    // Contract
    address DAI = 0x3e622317f8C93f7328350cF0B56d9eD4C620C5d6;

    function setUp() public {
        tokenSwap = new TokenSwap();
    }

    function testChainLinkPriceFeed() public {
        int result = tokenSwap.getChainlinkDataFeedLatestAnswer(LINKUSDAddress);
        console2.log(result);
        assertGt(result, 1);
    }

    function testAddLiquidity() public {
        vm.startPrank(0xd0aD7222c212c1869334a680e928d9baE85Dd1d0);
        uint256 _amount = 10e18;
        IERC20(DAI).approve(address(tokenSwap), _amount);
        tokenSwap.AddLiquidity(_amount);
        uint256 diaBalance = tokenSwap.DIADeposit();

        assertEq(diaBalance, _amount);
    }

    function testSwapForETH() public {
        testAddLiquidity();
        uint256 _amount = 10e18;
        tokenSwap.swapTokenForETH(DIAUSD, _amount);
        uint256 result = tokenSwap.DIADeposit();

        assertLt(result, _amount);
    }

    // function testFuzz_SetNumber(uint256 x) public {
    //     counter.setNumber(x);
    //     assertEq(counter.number(), x);
    // }
}