const hre = require("hardhat");

async function main() {
  try {

    const FunctionsService = await hre.ethers.getContractFactory(
      "FunctionsService"
    );
    //replace with your smart contract address
    const serviceContractAddress = "0xfc7B0311E6d858B6014cdbdC39dB7f9f1c6C95B3";
    //event trigger
    const functions = await FunctionsService.attach(serviceContractAddress);

    functions.on("RequestMade", (_requestId, _requestType, _result) => {
      if (_requestType === "Reservation") {
        console.log("Reservation is made, the result is : ", _result);
      } else if (_requestType === "Account") {
        console.log("Query account, the address is : ", _result);
      } 
    });


    const AccountRequest = await hre.ethers.getContractFactory(
      "AccountRequest"
    );
    //replace with your smart contract address
    const accountContractAddress =
      "0x9B4E3318d94425d4c1f9E36A34aeE26219B44536";
      
    const accountRequest = await AccountRequest.attach(
      accountContractAddress
    );

    let url = "http://endpoint-dun.vercel.app/api/account";
    let path = "message,account";
    await accountRequest.requestAccount(
      url,
      path
    );

    const ChargingReservation = await hre.ethers.getContractFactory(
      "ChargingReservation"
    );
    //replace with your smart contract address
    const reservationContractAddress =
      "0x84bB344DD2D46eB3258dbE30fD253dAD40e9d4e1";
      
    const reservation = await ChargingReservation.attach(
      reservationContractAddress
    );

    url = "http://endpoint-dun.vercel.app/api/reservation";
    path = "message,reservationCode";
    await reservation.makeReservation(
      url,
      path,
    );


  } catch (error) {
    console.error(error);
    process.exit(1);
  }
}

main();
