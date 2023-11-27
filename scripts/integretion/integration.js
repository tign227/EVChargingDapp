const hre = require("hardhat");

async function main() {
  try {
    const FunctionsService = await hre.ethers.getContractFactory(
      "FunctionsService"
    );
    //replace with your smart contract address
    const serviceContractAddress = "0xdC211bD05a035D2dcFB4D9628589d191c513E91F";
    //event trigger
    const functions = await FunctionsService.attach(serviceContractAddress);

    functions.on("RequestCompleted", (_requestId, _requestType, _result) => {
      if (_requestType === "Reservation") {
        console.log("Reservation is made, the result is : ", _result);
      } else if (_requestType == "Account") {
        console.log("Query account, the address is : ", _result);
      } else {
        console.log("Error ");
      }
    });

    const AccountRequest = await hre.ethers.getContractFactory(
      "AccountRequest"
    );
    //replace with your smart contract address
    const accountContractAddress = "0xb5232d97ee8D4fC68dEd25358b06c9e98D1B6649";

    const accountRequest = await AccountRequest.attach(accountContractAddress);
    let user = "0xc49341AfaC68ff16e04eD113A65fb8214E377164";
    let station = "Yundgy Seji";
    let url = `https://endpoint-dun.vercel.app/api/account?user=${user}&station=${station}`;
    let path = "message,account";
    await accountRequest.requestAccount(url, path);

    const ChargingReservation = await hre.ethers.getContractFactory(
      "ChargingReservation"
    );
    //replace with your smart contract address
    const reservationContractAddress =
      "0xA4d6D64E72088248Da7a7229591760D33Fb09632";

    const reservation = await ChargingReservation.attach(
      reservationContractAddress
    );
    user = "0x5477cE555Ffae19D38c58575403f00BF6fD05ed3";
    let lat = 53.456;
    let lng = -11.43;
    url = `https://endpoint-dun.vercel.app/api/reservation?user=${user}&lat=${lat}&lng=${lng}`;
    path = "message,reservationCode";
    await reservation.makeReservation(url, path);
  } catch (error) {
    console.error(error);
    process.exit(1);
  }
}

main();
