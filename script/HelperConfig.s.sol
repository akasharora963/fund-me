// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    NetworkConfig public _networkConfig;

    uint256 public constant SEPOLIA_ID = 11155111;
    uint8 public constant DECIMALS = 18;
    int256 public constant INITIAL_ANSWER = 2000e8;

    struct NetworkConfig {
        address priceFeed;
    }

    constructor() {
        if (block.chainid == SEPOLIA_ID) {
            _networkConfig = getSepoliaNetworkConfig();
        } else {
            _networkConfig = getOrCreateLocalNetworkConfig();
        }
    }

    function getSepoliaNetworkConfig()
        public
        pure
        returns (NetworkConfig memory)
    {
        return
            NetworkConfig({
                priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
            });
    }

    function getOrCreateLocalNetworkConfig()
        public
        returns (NetworkConfig memory)
    {
        if (_networkConfig.priceFeed != address(0)) {
            return _networkConfig;
        }

        vm.startBroadcast();

        MockV3Aggregator _mockV3Aggregator = new MockV3Aggregator(
            DECIMALS,
            INITIAL_ANSWER
        );
        console.log(
            "MockV3Aggregator deployed at: ",
            address(_mockV3Aggregator)
        );

        vm.stopBroadcast();

        NetworkConfig memory _localNetworkConfig = NetworkConfig({
            priceFeed: address(_mockV3Aggregator)
        });

        return _localNetworkConfig;
    }
}
