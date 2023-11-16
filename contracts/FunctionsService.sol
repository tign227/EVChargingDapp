// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "@chainlink/contracts/src/v0.8/shared/access/ConfirmedOwner.sol";

contract FunctionsService is ChainlinkClient, ConfirmedOwner {
    using Chainlink for Chainlink.Request;

    string public result;

    bytes32 private jobId;
    uint256 private fee;

    event RequestMade(bytes32 indexed requestId,string indexed eventName, string result);

    constructor() ConfirmedOwner(msg.sender) {
        setChainlinkToken(0x779877A7B0D9E8603169DdbD7836e478b4624789);
        setChainlinkOracle(0x6090149792dAAeE9D1D568c9f9a6F6B46AA29eFD);
        jobId = "7d80a6386ef543a3abb52817f6707e3b";
        fee = (1 * LINK_DIVISIBILITY) / 10; // 0,1 * 10**18 (Varies by network and job)
    }
    function request(string memory eventName, string memory url, string memory path) public returns (bytes32 requestId) {
        Chainlink.Request memory req = buildChainlinkRequest(
            jobId,
            address(this),
            this.fulfill.selector
        );

        req.add(
            "get",
            url
        );
        req.add("path", path); 
        return sendChainlinkRequest(req, fee);
    }

    /**
     * Receive the response in the form of string
     */
    function fulfill(
        bytes32 _requestId,
        string memory eventName,
        string memory _result
    ) public recordChainlinkFulfillment(_requestId) {
        emit RequestMade(_requestId, eventName, _result);
        result = _result;
    }

    /**
     * Allow withdraw of Link tokens from the contract
     */
    function withdrawLink() public onlyOwner {
        LinkTokenInterface link = LinkTokenInterface(chainlinkTokenAddress());
        require(
            link.transfer(msg.sender, link.balanceOf(address(this))),
            "Unable to transfer"
        );
    }
}
