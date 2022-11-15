// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../interface/IMetapebbleDataVerifier.sol";

abstract contract MetapebbleVerifiedToken is ERC20 {
    event Claimed(address indexed holder, bytes32 indexed deviceHash, uint256 amount);

    IMetapebbleDataVerifier public verifier;

    constructor(
        address _verifier,
        string memory _name,
        string memory _symbol
    ) ERC20(_name, _symbol) {
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
        bytes memory signature
    ) internal virtual {
        bytes32 digest = verifier.generateLocationDistanceDigest(
            holder,
            lat,
            long,
            distance,
            deviceHash,
            deviceTimestamp
        );
        require(verifier.verify(digest, signature), "invalid signature");

        _mint(amount, holder, deviceHash);
    }

    function _claim(
        uint256 amount,
        address holder,
        bytes32 deviceHash,
        uint256 deviceTimestamp,
        bytes memory signature
    ) internal virtual {
        bytes32 digest = verifier.generateDeviceDigest(holder, deviceHash, deviceTimestamp);
        require(verifier.verify(digest, signature), "invalid signature");

        _mint(amount, holder, deviceHash);
    }
}