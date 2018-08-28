/*module.exports = {
   networks: {
   development: {
   host: "127.0.0.1",
   port: 9545,
   network_id: "	5777",// Match any network id
   gas: 20000000,// <--- Twice as much
   gasPrice: 10000000000,
  }
 }
};
*/

module.exports = {
	deploy: [
   //"BrightCoinInvestorKYC",
   // "BrightCoinInvestorAccreditationCheck",
  //  "BrightCoinRegulatedToken"
    // missing TestLib
  ],
  networks: {
   development: {
   host: "localhost",
   port: "9545",
   network_id: "*",// Match any network id
   
  }
 	}
};
