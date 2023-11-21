// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "@chainlink/contracts/src/v0.8/shared/access/ConfirmedOwner.sol";

/**
 * @title FunctionsService
 * @dev This contract interacts with Chainlink's Functions service to send requests to external APIs.
 * The `url` parameter specifies the address of the target API, and the `path` parameter indicates the
 * JSONPath path in the API response. The contract handles the asynchronous return of the API through
 * the `fulfill` callback function.
 */
contract FunctionsService is ChainlinkClient, ConfirmedOwner {
    using Chainlink for Chainlink.Request;

    bytes32 private jobId;
    uint256 private fee;
    mapping(bytes32 => string) requestTypes;

    event RequestMade(
        bytes32 indexed requestId,
        string requestType,
        string result
    );

    /**
     * @dev Constructor function to initialize the Oracle contract.
     * It sets the Chainlink token, Oracle address, job ID, and fee.
     */
    constructor() ConfirmedOwner(msg.sender) {
        setChainlinkToken(0x779877A7B0D9E8603169DdbD7836e478b4624789);
        setChainlinkOracle(0x6090149792dAAeE9D1D568c9f9a6F6B46AA29eFD);
        jobId = "7d80a6386ef543a3abb52817f6707e3b";
        fee = (1 * LINK_DIVISIBILITY) / 10; // 0,1 * 10**18 (Varies by network and job)
    }

    /**
     * @dev Initiates a Chainlink request to fetch external data.
     * @param requestType The type of the request：Account & Reservation
     * @param url The URL of the external API.
     * @param path The JSONPath to extract the desired data from the API response.
     * @return requestId The unique identifier for the Chainlink request.
     */
    function request(
        string memory requestType,
        string memory url,
        string memory path
    ) public returns (bytes32 requestId) {
        Chainlink.Request memory req = buildChainlinkRequest(
            jobId,
            address(this),
            this.fulfill.selector
        );
        req.add("get", url);
        req.add("path", path);
        bytes32 reqId = sendChainlinkRequest(req, fee);
        requestTypes[reqId] = requestType;
        return reqId;
    }

    /**
     * @notice Callback function to handle the asynchronous return of the API.
     * This function is triggered when the API response is received.
     * Implement the logic to process the API response here.
     */
    function fulfill(
        bytes32 _requestId,
        string memory _result
    ) public recordChainlinkFulfillment(_requestId) {
        emit RequestMade(_requestId, requestTypes[_requestId], _result);
    }

    /**
     * @dev Allows the owner to withdraw any remaining LINK tokens from the contract.
     */
    function withdrawLink() public onlyOwner {
        LinkTokenInterface link = LinkTokenInterface(chainlinkTokenAddress());
        require(
            link.transfer(msg.sender, link.balanceOf(address(this))),
            "Unable to transfer"
        );
    }
}
