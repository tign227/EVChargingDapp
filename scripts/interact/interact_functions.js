const hre = require("hardhat");

async function main() {
  try {
    const FunctionsService = await hre.ethers.getContractFactory("FunctionsService");
    //replace with your smart contract address 
    const contractAddress = "0x9ecd38366e1F6C477A2Bfc17A6A7618A2D67516A"; 
    const functions = await FunctionsService.attach(contractAddress);

    const url = "http://endpoint-dun.vercel.app/api/reservation"
    const path = "message,message"

    await functions.request("Unknown", url, path);

    functions.on("RequestMade", (_requestId, _requestType, _result) => {
        console.log(_requestType, "====>", _result);
    });

  } catch (error) {
    console.error(error);
    process.exit(1);
  }
}

main();
