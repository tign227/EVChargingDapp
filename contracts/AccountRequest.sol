// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import "./FunctionsService.sol";

/**
 * @title AccountRequest
 * @dev This contract interacts with Chainlink's Functions service to request external account information.
 * It sends a request to an external API through Chainlink's Functions service.
 */
contract AccountRequest {
    FunctionsService service;

    constructor(address serviceAddress) {
        service = FunctionsService(serviceAddress);
    }

    /**
     * @dev Initiates an account information request using the Chainlink service.
     * @param url The URL of the external API for account information.
     * @param path The JSONPath to extract the account details from the API response.
     */
    function requestAccount(string memory url, string memory path) external {
        // Trigger an account information request using the Chainlink service.
        service.request("Account", url, path);
    }
}
