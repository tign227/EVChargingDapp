const hre = require("hardhat");

async function main() {
  try {
    const FunctionsService = await hre.ethers.getContractFactory("FunctionsService");
    //replace with your smart contract address 
    const contractAddress = "0x25b6c8344cA222D9A05cF31c74f03D5683883509"; 
    const functions = await FunctionsService.attach(contractAddress);

    const url = "http://endpoint-dun.vercel.app/api/reservation"
    const path = "message,reservationDetails,chargingStation,stationID"

    await functions.request(url, path);

    functions.on("RequestMade", (_requestId , _result) => {
      console.log(_requestId, _result);
    });

  } catch (error) {
    console.error(error);
    process.exit(1);
  }
}

main();
