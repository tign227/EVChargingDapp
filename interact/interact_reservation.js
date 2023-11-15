const hre = require("hardhat");

async function main() {
  try {
    const ChargingReservation = await hre.ethers.getContractFactory("ChargingReservation");

    //replace with your smart contract address on your localhost network
    const contractAddress = "0x5fbdb2315678afecb367f032d93f642f64180aa3"; 
    const reservation = await ChargingReservation.attach(contractAddress);
    
    const greet = await reservation.greet();
    console.log("the message from smat contract: ChargingReservation===>",(greet).toString());

  } catch (error) {
    console.error(error);
    process.exit(1);
  }
}

main();
