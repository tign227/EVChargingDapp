// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import "./FunctionsService.sol";

/**
 * @title AccountRequest
 * @dev This contract interacts with Chainlink's Functions service to request external account information.
 * It sends a request to an external API through Chainlink's Functions service.
 */
contract AccountRequest {
    enum RequestStatus {
        Pending,
        Completed,
        Canceled
    }

    struct AccountRequestData {
        address user; // User's address initiating the request
        string url; // URL of the external API for account information
        string path; // JSONPath to extract account details from the API response
        RequestStatus status; // Status of the request
    }

    FunctionsService service;

    // Mapping to associate request ID with request data
    mapping(uint256 => AccountRequestData) public requests;

    constructor(address _serviceAddress) {
        service = FunctionsService(_serviceAddress);
    }

    event AccountRequested(address indexed requester, string url, string path);

    // Event to notify when a request is completed
    event RequestCompleted(uint256 requestId);
    // Event to notify when a request is canceled
    event RequestCanceled(uint256 requestId);

    modifier onlyAuthorizedUser(address user) {
        require(msg.sender == user, "Not authorized");
        _;
    }

    /**
     * @dev Initiates an account information request using the Chainlink service.
     * @param url The URL of the external API for account information.
     * @param path The JSONPath to extract the account details from the API response.
     */
    function requestAccount(
        string memory url,
        string memory path
    ) external returns (bytes32) {
        require(bytes(url).length > 0, "URL must not be empty");
        require(bytes(path).length > 0, "Path must not be empty");
        // Trigger an account information request using the Chainlink service.
        bytes32 requestId = service.request("Account", url, path);
        requests[(uint256)(requestId)] = AccountRequestData(
            msg.sender,
            url,
            path,
            RequestStatus.Pending
        );

        emit AccountRequested(msg.sender, url, path);
        return requestId;
    }

    function requestCompleted(
        uint256 requestId
    ) external onlyAuthorizedUser(requests[requestId].user) returns (bool) {
        requests[requestId].status = RequestStatus.Completed;
        return true;
    }

    // Function for a user to cancel a pending request
    function cancelRequest(
        uint256 requestId
    ) external onlyAuthorizedUser(requests[requestId].user) {
        require(
            requests[requestId].status == RequestStatus.Pending,
            "Request not pending"
        );
        requests[requestId].status = RequestStatus.Canceled;
        emit RequestCanceled(requestId);
    }

    // Function to get the status of a request
    function getRequestStatus(
        uint256 requestId
    )
        external
        view
        onlyAuthorizedUser(requests[requestId].user)
        returns (RequestStatus)
    {
        return requests[requestId].status;
    }
}
