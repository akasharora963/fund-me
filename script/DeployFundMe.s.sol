// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {FundMe} from "../src/FundMe.sol";
import {Script, console} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {
    function run() external returns (FundMe) {
        HelperConfig _helperConfig = new HelperConfig();
        address priceFeed = _helperConfig._networkConfig();
        console.log("PriceFeed at: ", priceFeed);

        vm.startBroadcast();
        FundMe _fundMe = new FundMe(priceFeed);
        console.log("FundMe deployed at: ", address(_fundMe));
        vm.stopBroadcast();
        return _fundMe;
    }
}
