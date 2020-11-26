contract EpsToken {
    // Name of token
    string public constant name = "Epsilon TOKEN";
    // Token Symbol
    string public constant symbol = "EPS";
    // Total number of decimals
    uint8 public constant decimals = 18;
    // Contract owner
    address public owner;
    // Treasury of the tokens (account where all tokens will be stored)
    address public treasury;
    // Total Supply of the tokens
    uint256 public totalSupply;

    mapping(address => mapping(address => uint256)) private allowed;
    mapping(address => uint256) private balances;

    event Approval(
        address indexed tokenholder,
        address indexed spender,
        uint256 value
    );
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );
    event Transfer(address indexed from, address indexed to, uint256 value);

    constructor() public {
        owner = msg.sender;
        treasury = address(0xc86448c09B84C6b62656c42048952e5612Db542D);
        totalSupply = 1000000 * 10**uint256(decimals);
        balances[treasury] = totalSupply;
        emit Transfer(address(0), treasury, totalSupply);
    }

    function allowance(address _tokenholder, address _spender)
        public
        view
        returns (uint256 remaining)
    {
        return allowed[_tokenholder][_spender];
    }

    // ------------------------------------------------------------------------
    // Token owner can approve for spender to transferFrom(...) tokens
    // from the token owner's account
    // ------------------------------------------------------------------------
    function approve(address _spender, uint256 _value) public returns (bool) {
        require(_spender != address(0));
        require(_spender != msg.sender);
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    // ------------------------------------------------------------------------
    // Get the token balance for account tokenOwner
    // ------------------------------------------------------------------------
    function balanceOf(address _tokenholder)
        public
        view
        returns (uint256 balance)
    {
        return balances[_tokenholder];
    }

    // ------------------------------------------------------------------------
    // Transfer the balance from token owner's account to to account
    // - Owner's account must have sufficient balance to transfer
    // - 0 value transfers are allowed
    // ------------------------------------------------------------------------
    function transfer(address _to, uint256 _value) public returns (bool) {
        require(_to != msg.sender);
        require(_to != address(0));
        require(_to != address(this));
        require(balances[msg.sender] - _value <= balances[msg.sender]);
        require(balances[_to] <= balances[_to] + _value);
        require(_value <= transferableTokens(msg.sender));

        balances[msg.sender] = balances[msg.sender] - _value;
        balances[_to] = balances[_to] + _value;

        emit Transfer(msg.sender, _to, _value);

        return true;
    }

    // ------------------------------------------------------------------------
    // Transfer tokens from the from account to the to account
    //
    // The calling account must already have sufficient tokens approve(...)-d
    // for spending from the from account and
    // - From account must have sufficient balance to transfer
    // - Spender must have sufficient allowance to transfer
    // - 0 value transfers are allowed
    // ------------------------------------------------------------------------
    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool) {
        require(_from != address(0));
        require(_from != address(this));
        require(_to != _from);
        require(_to != address(0));
        require(_to != address(this));
        require(_value <= transferableTokens(_from));
        require(
            allowed[_from][msg.sender] - _value <= allowed[_from][msg.sender]
        );
        require(balances[_from] - _value <= balances[_from]);
        require(balances[_to] <= balances[_to] + _value);

        allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;
        balances[_from] = balances[_from] - _value;
        balances[_to] = balances[_to] + _value;

        emit Transfer(_from, _to, _value);

        return true;
    }

    function transferOwnership(address _newOwner) public {
        require(msg.sender == owner);
        require(_newOwner != address(0));
        require(_newOwner != address(this));
        require(_newOwner != owner);

        address previousOwner = owner;
        owner = _newOwner;

        emit OwnershipTransferred(previousOwner, _newOwner);
    }

    function transferableTokens(address holder) public view returns (uint256) {
        return balanceOf(holder);
    }
}
