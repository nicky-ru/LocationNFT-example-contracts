// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./MetapebbleVerifiedEnumerableNFT.sol";

contract PebbleMultipleLocationNFT is Ownable, ReentrancyGuard, MetapebbleVerifiedEnumerableNFT {
    struct Place {
        int256 lat;
        int256 long;
        uint256 maxDistance;
        uint256 startTimestamp;
        uint256 endTimestamp;
    }

    event PlaceManagerAdded(address indexed manager);
    event PlaceManagerRemoved(address indexed manager);
    event PlaceAdded(
        int256 lat,
        int256 long,
        uint256 maxDistance,
        uint256 startTimestamp,
        uint256 endTimestamp
    );

    uint256 private constant ONE_DAY = 1 days;
    bytes32[] public placesHash;
    mapping(bytes32 => Place) public places;
    mapping(address => bool) public placeManagers;

    uint256 private tokenId;

    modifier onlyPlaceManager() {
        require(
            placeManagers[_msgSender()],
            "PebbleMultipleLocationNFT: caller is not the place manager"
        );
        _;
    }

    constructor(
        int256[] memory _lats,
        int256[] memory _longs,
        uint256[] memory _maxDistances,
        uint256[] memory _startTimestamps,
        uint256[] memory _endTimestamps,
        address _verifier,
        string memory _name,
        string memory _symbol
    ) MetapebbleVerifiedEnumerableNFT(_verifier, _name, _symbol) {
        require(
            _lats.length == _longs.length && _lats.length == _maxDistances.length,
            "invalid place"
        );
        for (uint256 i = 0; i < _lats.length; i++) {
            require(_maxDistances[i] > 0, "invalid max distance");
            require(_lats[i] >= -90000000 && _lats[i] <= 90000000, "invalid lat");
            require(_longs[i] >= -180000000 && _longs[i] <= 180000000, "invalid long");
            require(
                _endTimestamps[i] > _startTimestamps[i] && _endTimestamps[i] > block.timestamp,
                "invalid timestamp"
            );
            bytes32 hash = keccak256(
                abi.encodePacked(
                    _lats[i],
                    _longs[i],
                    _maxDistances[i],
                    _startTimestamps[i],
                    _endTimestamps[i]
                )
            );
            require(places[hash].maxDistance == 0, "repeated place");

            places[hash] = Place({
                lat: _lats[i],
                long: _longs[i],
                maxDistance: _maxDistances[i],
                startTimestamp: _startTimestamps[i],
                endTimestamp: _endTimestamps[i]
            });
            placesHash.push(hash);
            emit PlaceAdded(
                _lats[i],
                _longs[i],
                _maxDistances[i],
                _startTimestamps[i],
                _endTimestamps[i]
            );
        }
    }

    function palceCount() external view returns (uint256) {
        return placesHash.length;
    }

    function addPlace(
        int256 _lat,
        int256 _long,
        uint256 _maxDistance,
        uint256 _startTimestamp,
        uint256 _endTimestamp
    ) external onlyPlaceManager {
        require(_maxDistance > 0, "invalid max distance");
        require(
            _endTimestamp > _startTimestamp && _endTimestamp > block.timestamp,
            "invalid timestamp"
        );
        require(_lat >= -90000000 && _lat <= 90000000, "invalid lat");
        require(_long >= -180000000 && _long <= 180000000, "invalid long");
        bytes32 hash = keccak256(
            abi.encodePacked(_lat, _long, _maxDistance, _startTimestamp, _endTimestamp)
        );
        require(places[hash].maxDistance == 0, "repeated place");

        places[hash] = Place({
            lat: _lat,
            long: _long,
            maxDistance: _maxDistance,
            startTimestamp: _startTimestamp,
            endTimestamp: _endTimestamp
        });
        placesHash.push(hash);
    }

    function claim(
        int256 lat_,
        int256 long_,
        uint256 distance_,
        bytes32 deviceHash_,
        uint256 startTimestamp_,
        uint256 endTimestamp_,
        bytes memory signature
    ) external payable nonReentrant {
        // fixed location verify logic
        require(_claimedDevices[deviceHash_] == address(0), "already claimed");
        Place memory place = places[
            keccak256(abi.encodePacked(lat_, long_, distance_, startTimestamp_, endTimestamp_))
        ];
        require(place.maxDistance > 0, "place not exists");

        _claim(
            tokenId,
            msg.sender,
            lat_,
            long_,
            distance_,
            deviceHash_,
            startTimestamp_,
            endTimestamp_,
            signature,
            msg.value
        );
        tokenId++;
    }

    function addPlaceManager(address manager) external onlyOwner {
        require(!placeManagers[manager], "PebbleMultipleLocationNFT: already manager");
        placeManagers[manager] = true;
        emit PlaceManagerAdded(manager);
    }

    function removePlaceManager(address manager) external onlyOwner {
        require(placeManagers[manager], "PebbleMultipleLocationNFT: not manager");
        placeManagers[manager] = false;
        emit PlaceManagerRemoved(manager);
    }
}
