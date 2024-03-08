// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;
import {SchemaResolver} from "@ethereum-attestation-service/eas-contracts/contracts/resolver/SchemaResolver.sol";
import {IEAS} from "@ethereum-attestation-service/eas-contracts/contracts/IEAS.sol";
import {Attestation} from "@ethereum-attestation-service/eas-contracts/contracts/Common.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract TokensResolver is SchemaResolver {
    using SafeERC20 for IERC20;

    IERC20 private immutable _targetToken;
    uint256 private immutable _targetAmount;

    constructor(
        IEAS eas,
        IERC20 targetToken,
        uint256 targetAmount
    ) SchemaResolver(eas) {
        _targetToken = targetToken;
        _targetAmount = targetAmount;
    }

    function onAttest(
        Attestation calldata attestation,
        uint256 /*value*/
    ) internal override returns (bool) {
        _targetToken.safeTransfer(attestation.recipient, _targetAmount);
        return true;
    }

    function onRevoke(
        Attestation calldata /*attestation*/,
        uint256 /*value*/
    ) internal pure override returns (bool) {
        return true; // Assuming revocation is always allowed in this example
    }
}
