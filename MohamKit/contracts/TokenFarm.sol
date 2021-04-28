pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.6/interface/AggregatorV3Interface.sol";


contract TokenFarm {
    string public name = "Dapp Token Farm";
    IERC20 public dappToken;
    mapping(address => mapping(address => uint256)) public stakingBalance;
    mapping(address => uint256) public uniqueTokensStaked;
    mapping(address => address) public tokenPriceFeedMapping;
    //token addy -> mappin of user addy -> amnts
    address[] allowedTokens;
    address[] public stakers;

    constructor(address _dappTokenAddress) public {
        dappToken = IERC20(_dappTokenAddress);
    }

    function stakeToken(uint256 _amount, address token) public {        
        require(_amount > 0, "Amount cannot be 0");
        if (tokenIsAllowed(token)) {
            updateUniqueTokenStake(msg.sender, token);
            IERC(token).transferFrom(msg.sender, address(this), _amount);
            stakingBalance[token][msg.sender] = stakingBalance[token][msg.sender] + _amount;
            if (uniqueTokenStaked[msg.sender] == 1){
                staker.push(msg.sender);
            }
            //update unique token stake!
            //if (uniqueTokenStaked)
        }
    }

    function setPriceFeedContract(address token, address priceFeed) public onlyOwner
    {
        tokenPriceFeedMapping[token] = priceFeed;
    }

    function updateUniqueTokenStake(address user, address token) internal {
        if(stakingBalance[token][user] <= 0){
            uniqueTokenStaked[user] = uniqueTokenStaked[user] + 1;
        }
    }
    
    function tokenIsAllowed(address token) public returns(bool){
        for ( uint256 allowedTokensIndex = 0; allowedTokensIndex < allowedTokens.
        length; allowedTokensIndex++){
            if (allowedTokens[allowedTokensIndex] == true){
                return true;
            }
        }
        return false;
    }

    function addAwllowedToken(address token) public onlyOwner{
        allowedTokens.push(token);
    }

    function unstakeToken(address token) public {
        uint256 balance = stakingBalance[token][msg.sender];
        require(balance > 0, "Staking balance cannot be 0!");
        IERC20(token).transfer(msg.sender, balance);
        stakingBalance[token][msg.sender] = 0;
    }

    function issueTOken() public {
        for( uint256 stakersIndex = 0;
        stakersIndex < stakers.length;
        stakersIndex++){
            address recipient = staker[stkersIndex];
            dappToken.transfer(recipient, getUserTotalValue(recipient));
        }
    function getUserTotalValue(address user) public view returns(uint256) {
        uint256 tokenValue = 0;
        if (uniqueTokenStaked[user] > 0){
            for(
                uint256 allowedTokensIndex = 0;allowedTokensIndex < allowedTokens.length;
                allowedTokensIndex++
            ){
                totalValue = totalValue + getUserStakingBalanceEthValue(
                    user
                    allowedTokens[allowedTokensIndex]

                );
            }
        }
    }

    function getUserStakingBalanceEthValue(address user, address token) public view
    returns (uint256){
        if(uniqueTokenStaked[user] <= 0){
            return 0;
        }
        return (stakingBalance[token][user] * getTokenEthPrice(token)) / (10**18);
    }

    function getTokenEthPrice(address token) public view returns(uint256){
        address priceFeedAddress = tokenPriceFeedMapping[token];
        AggregatorV3Interface priceFeed = AggregatorV3Interface (priceFeedAddress);
        (
            uint80 roundID,
            int price,
            uint startedAt,
            uint timeStamp,
            uint80 answeredInRound
        ) = priceFeed.latestRoundData();
        return uint256(price);
    }


    


  
}