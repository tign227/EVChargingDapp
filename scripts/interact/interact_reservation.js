const hre = require("hardhat");

async function main() {
  try {
    const ChargingReservation = await hre.ethers.getContractFactory("ChargingReservation");
    //replace with your smart contract address 
    const contractAddress = "0xF722c2B768901F08a3f745ebE0C4B13585Ec2920";
    const reservation = await ChargingReservation.attach(contractAddress);

    const url = "http://endpoint-dun.vercel.app/api/reservation";
    const path = "message,status";
    const reserverAddress = "0x5477cE555Ffae19D38c58575403f00BF6fD05ed3";
    const plateLicense = "0xc49341AfaC68ff16e04eD113A65fb8214E377164";
    const chargingStationAddress = "Mock Address"
    const chargingStationName = "Mock Name"
    const startTime = Math.floor(Date.now() / 1000) + 3600; // start reservation 1 hour from now
    const endTime = startTime + 7200; // end reservation 2 hours from start
    const requestId = await reservation.makeReservation(url, path, reserverAddress, plateLicense, chargingStationName, chargingStationAddress, startTime, endTime);
    console.log(requestId);

  } catch (error) {
    console.error(error);
    process.exit(1);
  }
}

main();
