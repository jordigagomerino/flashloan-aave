let Flashloan = artifacts.require("Flashloan");

module.exports = async function (deployer, network) {
    try {

        let lendingPoolAddressesProviderAddress;

        switch(network) {
            case "polygon":
            case "matic":
                lendingPoolAddressesProviderAddress = "0xd05e3E715d945B59290df0ae8eF85c1BdB684744"; break
            default:
                throw Error(`Are you deploying to the correct network? (network selected: ${network})`)
        }

        await deployer.deploy(Flashloan, lendingPoolAddressesProviderAddress)
    } catch (e) {
        console.log(`Error in migration: ${e.message}`)
    }
}