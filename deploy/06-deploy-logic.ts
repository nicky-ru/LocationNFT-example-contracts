module.exports = async ({ ethers, getNamedAccounts, deployments }) => {
    const { deploy, log } = deployments
    const { deployer }: { [name: string]: string } = await getNamedAccounts()

    const verifier = await deployments.get("MetapebbleDataVerifier")
    const locationNFT = await deployments.get("LocationNFT")

    log(`Deploying Logic...`)

    const deployResult = await deploy("Logic", {
        from: deployer,
        log: true,
        args: [
            verifier.address,
            locationNFT.address,
            ethers.utils.parseEther("0.1"),
            deployer,
            ethers.utils.parseEther("0.1"),
        ],
        deterministicDeployment: false,
    })
    if (deployResult.newlyDeployed) {
        log(
            `contract Logic deployed at ${deployResult.address} using ${deployResult.receipt.gasUsed} gas`
        )
    }
}

module.exports.dependencies = [`verifier`, `LocationNFT`]
module.exports.tags = [`all`, `Logic`]
