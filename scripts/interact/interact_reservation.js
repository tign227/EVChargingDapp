const hre = require("hardhat");

async function main() {
  try {
    const ChargingReservation = await hre.ethers.getContractFactory("ChargingReservation");
    //replace with your smart contract address on your localhost network
    const contractAddress = "0xF722c2B768901F08a3f745ebE0C4B13585Ec2920";
    const reservation = await ChargingReservation.attach(contractAddress);

    const FunctionsService = await hre.ethers.getContractFactory("FunctionsService");
    //replace with your smart contract address on your localhost network
    const contractAddr = "0x71a8488AEd7cb25333A4FFA8414Df404178AF4f6";
    const functions = await FunctionsService.attach(contractAddr);
    functions.on("RequestMade", (_requestId, _result) => {
      console.log(_result);
    });

    const reserverAddress = "0x5477cE555Ffae19D38c58575403f00BF6fD05ed3";
    const plateLicense = "0xc49341AfaC68ff16e04eD113A65fb8214E377164";
    const chargingStationAddress = "Mock Address"
    const chargingStationName = "Mock Name"
    const startTime = Math.floor(Date.now() / 1000) + 3600; // start reservation 1 hour from now
    const endTime = startTime + 7200; // end reservation 2 hours from start
    await reservation.makeReservation(reserverAddress, plateLicense, chargingStationName, chargingStationAddress, startTime, endTime);


  } catch (error) {
    console.error(error);
    process.exit(1);
  }
}

main();
