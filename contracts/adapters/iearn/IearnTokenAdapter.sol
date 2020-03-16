pragma solidity 0.6.4;
pragma experimental ABIEncoderV2;

import { TokenAdapter } from "../TokenAdapter.sol";
import { TokenInfo, Component } from "../../Structs.sol";
import { ERC20 } from "../../ERC20.sol";


/**
 * @dev YToken contract interface.
 * Only the functions required for IearnAdapter contract are added.
 * The YToken contracts is available here
 * github.com/iearn-finance/itoken/tree/master/contracts.
 */
interface YToken {
    function token() external view returns (address);
    function getPricePerFullShare() external view returns (uint256);
}


/**
 * @title Adapter for YTokens.
 * @dev Implementation of TokenAdapter interface.
 */
contract IearnTokenAdapter is TokenAdapter {

    /**
     * @return TokenInfo struct with ERC20-style token info.
     * @dev Implementation of TokenAdapter interface function.
     */
    function getInfo(address token) external view override returns (TokenInfo memory) {
        return TokenInfo({
            token: token,
            name: ERC20(token).name(),
            symbol: ERC20(token).symbol(),
            decimals: ERC20(token).decimals()
        });
    }

    /**
     * @return Array of Component structs with underlying tokens rates for the given asset.
     * @dev Implementation of TokenAdapter interface function.
     */
    function getComponents(address token) external view override returns (Component[] memory) {
        Component[] memory underlyingTokens = new Component[](1);

        underlyingTokens[0] = Component({
            token: YToken(token).token(),
            tokenType: "ERC20",
            rate: YToken(token).getPricePerFullShare()
        });

        return underlyingTokens;
    }
}
