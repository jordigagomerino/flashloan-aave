pragma solidity ^0.6.0;

import "./libraries/SafeERC20.sol";
import "./libraries/SafeMath.sol";
import "./libraries/IERC20.sol";
import "./ILendingPoolV2.sol";
import "./IFlashLoanReceiver.sol";
import "./ILendingPoolAddressesProviderV2.sol";
import "./libraries/DataTypes.sol";
import "./libraries/Ownable.sol";
import "./libraries/Withdrawable.sol";

contract Flashloan is IFlashLoanReceiver, Withdrawable {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;
    address constant ethAddress = 0x0000000000000000000000000000000000001010; //0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    ILendingPoolAddressesProviderV2 public addressesProvider;

    constructor(address _addressProvider) public {
        addressesProvider = ILendingPoolAddressesProviderV2(_addressProvider);
    }

    receive() external payable {}

    /**
        Flash loan 1000000000000000000 wei (1 ether) worth of `_asset`
        address receiverAddress,
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata modes,
        address onBehalfOf,
        bytes calldata params,
        uint16 referralCode
     */
    function flashloan(
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata modes,
        bytes calldata params
    ) public payable {
        if (assets.length != amounts.length) {
            revert("assets and amounts do not match");
        }

        if (assets.length != modes.length) {
            revert("assets and modes do not match");
        }
        address onBehalfOf = msg.sender;
        address pool = addressesProvider.getLendingPool();
        //
       try
            ILendingPoolV2(pool).flashLoan(
                address(this),
                assets,
                amounts,
                modes,
                onBehalfOf,
                params,
                56
            )
        {} catch Error(string memory reason) {
            revert(reason);
        } catch {
            revert("flashLoan");
        }

        // approve lending pool zero
        for (uint256 i = 0; i < assets.length; i++) {
            IERC20(assets[i]).safeApprove(pool, 0);
            //if (modes[i] != 0) _updateToken(assets[i]);
        }
    }

    /**
  This function is called after your contract has received the flash loaned amount
     */
    function executeOperation(
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata premiums,
        address initiator,
        bytes calldata params
    ) external override returns (bool) {
         if (
            msg.sender !=
            addressesProvider.getLendingPool()
        ) {
            revert("invalid caller");
        }
        //Do stuff with the flash money here
        address pool = addressesProvider.getLendingPool();
        for (uint256 i = 0; i < assets.length; i++) {
            uint256 amountOwing = amounts[i].add(premiums[i]);
            IERC20(assets[i]).safeApprove(pool, amountOwing);
        }
        return true;
    }

    function transferFundsBackToPoolInternal(address _reserve, uint256 _amount)
        internal
    {
        address payable core = payable(addressesProvider.getLendingPool());
        transferInternal(core, _reserve, _amount);
    }

    function transferInternal(
        address payable _destination,
        address _reserve,
        uint256 _amount
    ) internal {
        if (_reserve == ethAddress) {
            (bool success, ) = _destination.call{value: _amount}("");
            require(success == true, "Couldn't transfer ETH");
            return;
        }
        IERC20(_reserve).safeTransfer(_destination, _amount);
    }

    function getBalanceInternal(address _target, address _reserve)
        internal
        view
        returns (uint256)
    {
        if (_reserve == ethAddress) {
            return _target.balance;
        }
        return IERC20(_reserve).balanceOf(_target);
    }
}
