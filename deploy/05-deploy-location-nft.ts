module.exports = async ({ ethers, getNamedAccounts, deployments }) => {
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()

    log(`Deploying LocationNFT...`)

    const deployResult = await deploy("LocationNFT", {
        from: deployer,
        log: true,
        args: [],
        deterministicDeployment: false,
    })
    if (deployResult.newlyDeployed) {
        log(
            `contract PebbleMultipleLocationNFT deployed at ${deployResult.address} using ${deployResult.receipt.gasUsed} gas`
        )
    }
}

module.exports.dependencies = [`verifier`]
module.exports.tags = [`all`, `LocationNFT`]
