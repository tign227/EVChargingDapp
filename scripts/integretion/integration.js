const hre = require("hardhat");

async function main() {
  try {
    const FunctionsService = await hre.ethers.getContractFactory(
      "FunctionsService"
    );
    //replace with your smart contract address
    const serviceContractAddress = "0xbB151f0Dd0F3f7B9097949fFcA5a34816f65c9Ad";
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
    const accountContractAddress = "0xe5D9545095a3C96292b45861F73db32f03FF9790";

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
      "0xaB809B46a3185f596b092a9D7e636b6C628e7231";

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
