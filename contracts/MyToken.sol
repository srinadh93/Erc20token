// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title MyToken - Simple ERC-20 compatible token for learning
contract MyToken {
    // -----------------------------
    // Token metadata
    // -----------------------------

    // Name of the token (e.g., "MyToken")
    string public name = "MyToken";

    // Symbol of the token (e.g., "MTK")
    string public symbol = "MTK";

    // Number of decimal places
    // Standard is 18 (same as Ether)
    uint8 public decimals = 18;

    // Total supply of tokens in smallest units (e.g., 1,000,000 * 10^18)
    uint256 public totalSupply;

    // -----------------------------
    // Mappings for balances & allowances
    // -----------------------------

    // Mapping to track balances: address => token balance
    mapping(address => uint256) public balanceOf;

    // Nested mapping for allowances:
    // owner => (spender => amount allowed to spend)
    mapping(address => mapping(address => uint256)) public allowance;

    // -----------------------------
    // Events (required by ERC-20)
    // -----------------------------

    // Emitted when tokens are transferred
    event Transfer(address indexed from, address indexed to, uint256 value);

    // Emitted when an approval is made
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // -----------------------------
    // Constructor
    // -----------------------------

    /// @notice Constructor sets the initial total supply and assigns it to the deployer
    /// @param _initialSupply Total supply in smallest units (include 10^decimals)
    constructor(uint256 _initialSupply) {
        // Set total supply from the parameter
        totalSupply = _initialSupply;

        // Assign entire supply to contract deployer (msg.sender)
        balanceOf[msg.sender] = _initialSupply;

        // Emit a Transfer event from address(0) to show minting
        emit Transfer(address(0), msg.sender, _initialSupply);
    }

    // -----------------------------
    // Core ERC-20 functions
    // -----------------------------

    /// @notice Transfer tokens from caller to another address
    /// @param _to Recipient address
    /// @param _value Amount of tokens to transfer
    /// @return success True if transfer is successful
    function transfer(address _to, uint256 _value) public returns (bool success) {
        // Recipient cannot be zero address (prevents accidental burn)
        require(_to != address(0), "Cannot transfer to zero address");

        // Check sender has enough balance
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");

        // Decrease sender's balance
        balanceOf[msg.sender] -= _value;

        // Increase recipient's balance
        balanceOf[_to] += _value;

        // Emit Transfer event after state changes
        emit Transfer(msg.sender, _to, _value);

        return true;
    }

    /// @notice Approve another address to spend tokens on your behalf
    /// @param _spender Address allowed to spend your tokens
    /// @param _value Amount they are allowed to spend
    /// @return success True if approval is successful
    function approve(address _spender, uint256 _value) public returns (bool success) {
        // Spender cannot be zero address
        require(_spender != address(0), "Cannot approve zero address");

        // Set allowance
        allowance[msg.sender][_spender] = _value;

        // Emit Approval event
        emit Approval(msg.sender, _spender, _value);

        return true;
    }

    /// @notice Transfer tokens from one address to another using allowance
    /// @param _from Address to send tokens from
    /// @param _to Recipient address
    /// @param _value Amount of tokens to transfer
    /// @return success True if transfer is successful
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        // Recipient cannot be zero address
        require(_to != address(0), "Cannot transfer to zero address");

        // Check that _from has enough balance
        require(balanceOf[_from] >= _value, "Insufficient balance");

        // Check that caller (msg.sender) has enough approved allowance
        require(allowance[_from][msg.sender] >= _value, "Insufficient allowance");

        // Decrease balance of _from
        balanceOf[_from] -= _value;

        // Increase balance of recipient
        balanceOf[_to] += _value;

        // Decrease allowance
        allowance[_from][msg.sender] -= _value;

        // Emit Transfer event
        emit Transfer(_from, _to, _value);

        return true;
    }

    // -----------------------------
    // Helper / convenience functions
    // -----------------------------

    /// @notice Returns the total supply of tokens
    /// @return supply Total supply of tokens
    function getTotalSupply() public view returns (uint256 supply) {
        return totalSupply;
    }

    /// @notice Returns basic token information in one call
    /// @return tokenName Name of the token
    /// @return tokenSymbol Symbol of the token
    /// @return tokenDecimals Decimals used
    /// @return tokenTotalSupply Total supply
    function getTokenInfo()
        public
        view
        returns (string memory tokenName, string memory tokenSymbol, uint8 tokenDecimals, uint256 tokenTotalSupply)
    {
        return (name, symbol, decimals, totalSupply);
    }
}