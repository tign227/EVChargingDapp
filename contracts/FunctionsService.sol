// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "@chainlink/contracts/src/v0.8/shared/access/ConfirmedOwner.sol";

/**
 * @title FunctionsService
 * @dev This contract interacts with Chainlink's Functions service to send requestRecords to external APIs.
 * The `url` parameter specifies the address of the target API, and the `path` parameter indicates the
 * JSONPath path in the API response. The contract handles the asynchronous return of the API through
 * the `fulfill` callback function.
 */
contract FunctionsService is ChainlinkClient, ConfirmedOwner {
    using Chainlink for Chainlink.Request;
    bytes32 private jobId;
    uint256 private fee;

    // Mapping to associate request ID with request data
    mapping(bytes32 => RequestData) public requestRecords;

    // Event to notify when a request is made
    event RequestMade(bytes32 indexed _requestId, string _requestType);
    // Event to notify when a request is completed
    event RequestCompleted(
        bytes32 indexed _requestId,
        string _requestType,
        string _result
    );
    // Event to notify when a request is canceled
    event RequestCanceled(bytes32 indexed _requestId, string _requestType);

    enum RequestStatus {
        Pending,
        Completed,
        Canceled
    }

    struct RequestData {
        address user; // User's address initiating the request
        string requestType; //Type of this request
        string url; // URL of the external API for account information
        string path; // JSONPath to extract account details from the API response
        RequestStatus status; // Status of the request
        string result; //Result of request when callback
    }

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
     * @param _requestType The type of the request：Account & Reservation
     * @param _url The URL of the external API.
     * @param _path The JSONPath to extract the desired data from the API response.
     * @return _requestId The unique identifier for the Chainlink request.
     */
    function request(
        string memory _requestType,
        string memory _url,
        string memory _path
    ) public returns (bytes32 _requestId) {
        require(bytes(_url).length > 0, "URL must not be empty");
        require(bytes(_path).length > 0, "Path must not be empty");
        Chainlink.Request memory req = buildChainlinkRequest(
            jobId,
            address(this),
            this.fulfill.selector
        );
        req.add("get", _url);
        req.add("path", _path);
        bytes32 reqId = sendChainlinkRequest(req, fee);
        requestRecords[reqId] = RequestData({
            user: msg.sender,
            requestType: _requestType,
            url: _url,
            path: _path,
            status: RequestStatus.Pending,
            result: ""
        });
        emit RequestMade(reqId, _requestType);
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
        requestRecords[_requestId].status = RequestStatus.Completed;
        requestRecords[_requestId].result = _result;
        emit RequestCompleted(
            _requestId,
            requestRecords[_requestId].requestType,
            _result
        );
    }

    function cancelRequest(bytes32 _requestId) public {
        requestRecords[_requestId].status = RequestStatus.Canceled;
        _withdrawLink(fee);
        emit RequestCanceled(
            _requestId,
            requestRecords[_requestId].requestType
        );
    }

    /**
     * @dev Allows the owner to withdraw LINK tokens from the contract.
     * @param _fee The amount of LINK tokens to withdraw.
     */
    function _withdrawLink(uint256 _fee) internal onlyOwner {
        LinkTokenInterface link = LinkTokenInterface(chainlinkTokenAddress());
        require(link.transfer(msg.sender, _fee), "Unable to transfer");
    }
}
