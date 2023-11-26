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

    mapping(address => bytes32[]) public requestsOfUser;

    event AccountRequestCreated(address indexed user, bytes32 requestId);

    event AccountRequestCanceled(address indexed user, bytes32 requestId);

    constructor(address _serviceAddress) {
        service = FunctionsService(_serviceAddress);
    }

    /**
     * @dev Initiates an account information request using the Chainlink service.
     * @param _url The URL of the external API for account information.
     * @param _path The JSONPath to extract the account details from the API response.
     */
    function requestAccount(
        string memory _url,
        string memory _path
    ) external returns (bytes32 requestId) {
        require(bytes(_url).length > 0, "URL must not be empty");
        require(bytes(_path).length > 0, "Path must not be empty");
        // Trigger an account information request using the Chainlink service.
        requestId = service.request("Account", _url, _path);
        emit AccountRequestCreated(msg.sender, requestId);
        requestsOfUser[msg.sender].push(requestId);
    }

    // Function for a user to cancel a pending request
    function cancelRequest(bytes32 _requestId) external {
        service.cancelRequest(_requestId);
        emit AccountRequestCanceled(msg.sender, _requestId);
    }
}
