// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Token.sol";

contract SimpleTokenTest is Test {
    Token token;

    function setUp() public {
        token = new Token("Ethernaut Token", "ETH");
    }

    function testTokenBasic() public {
        console.log("Total supply:", token.totalSupply());
        console.log("Player balance:", token.balanceOf(address(this)));
    }
}