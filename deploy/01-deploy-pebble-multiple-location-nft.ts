module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy, get, log } = deployments
    const { deployer } = await getNamedAccounts()

    const verifier = await get("MetapebbleDataVerifier")

    log(`Deploying PebbleMultipleLocationNFT...`)
    const startTimestamp = Math.floor(new Date().valueOf() / 1000)
    const deployResult = await deploy("PebbleMultipleLocationNFT", {
        from: deployer,
        log: true,
        args: [
            [30400000, 30270960], // lat
            [120520000, 120041443], // long
            [1000, 1000], // 1km
            [startTimestamp, startTimestamp],
            [startTimestamp + 1000, startTimestamp + 2592000],
            verifier.address,
            "Multiple Place Pebble NFT",
            "MPT",
        ],
        deterministicDeployment: false,
    })
    if (deployResult.newlyDeployed) {
        log(
            `contract PebbleMultipleLocationNFT deployed at ${deployResult.address} using ${deployResult.receipt.gasUsed} gas`
        )
    }
}

module.exports.dependencies = [`verifier`]
module.exports.tags = [`all`, `PebbleMultipleLocationNFT`]
