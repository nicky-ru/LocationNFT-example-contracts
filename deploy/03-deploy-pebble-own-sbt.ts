module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy, get, log } = deployments
    const { deployer } = await getNamedAccounts()

    const verifier = await get("MetapebbleDataVerifier")

    log(`Deploying PebbleOwnSBT...`)
    const deployResult = await deploy("PebbleOwnSBT", {
        from: deployer,
        log: true,
        args: [verifier.address, "Own Pebble SBT", "OPT"],
        deterministicDeployment: false,
    })
    if (deployResult.newlyDeployed) {
        log(
            `contract PebbleOwnSBT deployed at ${deployResult.address} using ${deployResult.receipt.gasUsed} gas`
        )
    }
}

module.exports.dependencies = [`verifier`]
module.exports.tags = [`all`, `PebbleOwnSBT`]
