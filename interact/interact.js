const hre = require("hardhat");

async function main() {
  try {
    // Get the ContractFactory of your contract
    const ChargingReservation = await hre.ethers.getContractFactory("ChargingReservation");

    // Connect to the deployed contract
    const contractAddress = "0x5fbdb2315678afecb367f032d93f642f64180aa3"; 
    const reservation = await ChargingReservation.attach(contractAddress);
    // Greet from your contract
    console.log("the message from smat contract: ChargingReservation===>",(await reservation.greet()).toString());

  } catch (error) {
    console.error(error);
    process.exit(1);
  }
}

main();
