// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./interface/IMetapebbleDataVerifier.sol";

abstract contract MetapebbleVerifiedToken is ERC20 {
    event Claimed(address indexed holder, bytes32 indexed deviceHash, uint256 amount);

    IMetapebbleDataVerifier public verifier;

    constructor(address _verifier) {
        verifier = IMetapebbleDataVerifier(_verifier);
    }

    function _mint(
        uint256 amount,
        address holder,
        bytes32 deviceHash
    ) private {
        _mint(holder, amount);
        emit Claimed(holder, deviceHash, amount);
    }

    function _claim(
        uint256 amount,
        address holder,
        uint256 lat,
        uint256 long,
        uint256 distance,
        bytes32 deviceHash,
        uint256 deviceTimestamp,
        uint256 verifyTimestamp,
        bytes memory signature
    ) internal virtual {
        require(
            verifier.verifyLocationDistance(
                holder,
                lat,
                long,
                distance,
                deviceHash,
                deviceTimestamp,
                verifyTimestamp,
                signature
            ),
            "invalid signature"
        );

        _mint(amount, holder, deviceHash);
    }

    function _claim(
        uint256 amount,
        address holder,
        bytes32 deviceHash,
        uint256 deviceTimestamp,
        uint256 verifyTimestamp,
        bytes memory signature
    ) internal virtual {
        require(
            verifier.verifyDevice(holder, deviceHash, deviceTimestamp, verifyTimestamp, signature),
            "invalid signature"
        );

        _mint(amount, holder, deviceHash);
    }
}