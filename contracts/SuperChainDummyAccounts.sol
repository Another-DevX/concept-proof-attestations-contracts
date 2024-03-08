// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {IEAS, AttestationRequest, AttestationRequestData, RevocationRequest, RevocationRequestData} from "@ethereum-attestation-service/eas-contracts/contracts/IEAS.sol";
import {NO_EXPIRATION_TIME, EMPTY_UID} from "@ethereum-attestation-service/eas-contracts/contracts/Common.sol";

/// @title Attester
/// @notice Ethereum Attestation Service - Example
contract SuperChainDummyAccounts {
    struct User {
        uint256 transactions;
        uint256 requiredTransactionsToUpgrade;
    }
    error InvalidEAS();

    // The address of the global EAS contract.
    IEAS private immutable _eas;
    mapping(address => User) private _usersTransactions;

    /// @notice Creates a new Attester instance.
    /// @param eas The address of the global EAS contract.
    constructor(IEAS eas) {
        if (address(eas) == address(0)) {
            revert InvalidEAS();
        }

        _eas = eas;
    }

    /// @notice Attests to a schema that receives a uint256 parameter.
    /// @param schema The schema UID to attest to.
    /// @return The UID of the new attestation.
    function attest(bytes32 schema) external returns (bytes32) {
        uint256 level = 0;
        uint256 userTransactions = _usersTransactions[msg.sender].transactions;
        require(
            userTransactions >=
                _usersTransactions[msg.sender].requiredTransactionsToUpgrade,
            "The user has not enough transactions to upgrade"
        );
        if (userTransactions >= 50) {
            level = 3;
        } else if (userTransactions >= 10) {
            level = 2;
        } else {
            level = 1;
        }

        return
            _eas.attest(
                AttestationRequest({
                    schema: schema,
                    data: AttestationRequestData({
                        recipient: msg.sender,
                        expirationTime: NO_EXPIRATION_TIME, // No expiration time
                        revocable: true,
                        refUID: EMPTY_UID, // No references UI
                        data: abi.encode(level), // Encode a single uint256 as a parameter to the schema
                        value: 0 // No value/ETH
                    })
                })
            );
    }

    /// @notice Revokes an attestation of a schema that receives a uint256 parameter.
    /// @param schema The schema UID to attest to.
    /// @param uid The UID of the attestation to revoke.
    function revoke(bytes32 schema, bytes32 uid) external {
        _eas.revoke(
            RevocationRequest({
                schema: schema,
                data: RevocationRequestData({uid: uid, value: 0})
            })
        );
    }

    function upgradeUserTransactions(
        address user,
        uint256 transactions
    ) external {
        _usersTransactions[user].transactions = transactions;
    }
}
