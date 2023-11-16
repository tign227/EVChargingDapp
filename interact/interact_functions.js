const hre = require("hardhat");

async function main() {
  try {
    const FunctionsService = await hre.ethers.getContractFactory("FunctionsService");
    const contractAddress = "0x25b6c8344cA222D9A05cF31c74f03D5683883509"; 
    const functions = await FunctionsService.attach(contractAddress);
    const url = "http://endpoint-dun.vercel.app/api/reservation"
    const path = "message,reservationDetails,chargingStation,stationID"
    await functions.request(url, path);
    const result = await functions.result();
    console.log(result);

  } catch (error) {
    console.error(error);
    process.exit(1);
  }
}

main();
