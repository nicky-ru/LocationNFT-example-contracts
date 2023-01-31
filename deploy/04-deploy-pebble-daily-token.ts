module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy, get, log } = deployments
    const { deployer } = await getNamedAccounts()

    const verifier = await get("MetapebbleDataVerifier")

    log(`Deploying PebbleDailyToken...`)
    const deployResult = await deploy("PebbleDailyToken", {
        from: deployer,
        log: true,
        args: [verifier.address, "Pebble Daily Tiken", "PDT"],
        deterministicDeployment: false,
    })
    if (deployResult.newlyDeployed) {
        log(
            `contract PebbleDailyToken deployed at ${deployResult.address} using ${deployResult.receipt.gasUsed} gas`
        )
    }
}

module.exports.dependencies = [`verifier`]
module.exports.tags = [`all`, `PebbleDailyToken`]
