const hre = require("hardhat");

async function main() {
  try {
    const ChargingReservation = await hre.ethers.getContractFactory("ChargingReservation");
    //replace with your smart contract address
    const reservationContractAddress = "0x72410822682C6Ea9D4F6fD645f4e9352f1021048";
    const reservation = await ChargingReservation.attach(reservationContractAddress);

    const FunctionsService = await hre.ethers.getContractFactory("FunctionsService");
    //replace with your smart contract address
    const serviceContractAddress = "0x39C6657fAbBb2a58f82582c84F54E269eaAB97D5";

    //event trigger
    const functions = await FunctionsService.attach(serviceContractAddress);
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
