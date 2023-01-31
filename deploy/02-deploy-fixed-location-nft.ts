module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy, get, log } = deployments
    const { deployer } = await getNamedAccounts()

    const verifier = await get("MetapebbleDataVerifier")

    log(`Deploying PebbleFixedLocationNFT...`)
    let deployResult = await deploy("PebbleFixedLocationNFT", {
        from: deployer,
        log: true,
        args: [
            120520000, // lat
            30400000, // long
            1000, // 1km
            verifier.address,
            "ShangHai Pebble NFT",
            "SHP",
        ],
        deterministicDeployment: false,
    })
    if (deployResult.newlyDeployed) {
        log(
            `contract PebbleFixedLocationNFT deployed at ${deployResult.address} using ${deployResult.receipt.gasUsed} gas`
        )
    }
}

module.exports.dependencies = [`verifier`]
module.exports.tags = [`all`, `PebbleFixedLocationNFT`]
