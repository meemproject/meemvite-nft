// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import '@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol';
import '@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol';
import '@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol';
import '@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol';
import '@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol';
import '@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol';
import '@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721BurnableUpgradeable.sol';
import '@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol';
import '@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol';
import '@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol';
import '@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol';

import './ERC721TradableUpgradeable.sol';
import './Base64.sol';
import './MeemViteURI.sol';

contract MeemVite is
	ERC721TradableUpgradeable,
	AccessControlUpgradeable,
	OwnableUpgradeable,
	PausableUpgradeable,
	UUPSUpgradeable,
	ERC721BurnableUpgradeable,
	ERC721EnumerableUpgradeable,
	ERC721URIStorageUpgradeable
{
	event InviterSet(uint256 tokenId, address inviter);

	using CountersUpgradeable for CountersUpgradeable.Counter;
	using StringsUpgradeable for uint256;

	bytes32 public constant PAUSER_ROLE = keccak256('PAUSER_ROLE');
	bytes32 public constant MINTER_ROLE = keccak256('MINTER_ROLE');
	bytes32 public constant UPGRADER_ROLE = keccak256('UPGRADER_ROLE');

	CountersUpgradeable.Counter private _tokenIdCounter;

	// Mapping from token ID to inviter address
	mapping(uint256 => address) private _inviters;
	address private uriContractAddress;

	function initialize(address _proxyRegistryAddress) public initializer {
		__ERC721Tradable_init('MeemVite', 'MEEMVITE', _proxyRegistryAddress);
		__ERC721Enumerable_init();
		__ERC721URIStorage_init();
		__Pausable_init();
		__Ownable_init();
		__AccessControl_init();
		__ERC721Burnable_init();
		__UUPSUpgradeable_init();

		_setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
		_setupRole(PAUSER_ROLE, msg.sender);
		_setupRole(MINTER_ROLE, msg.sender);
		_setupRole(UPGRADER_ROLE, msg.sender);
	}

	function isApprovedForAll(address owner, address operator)
		public
		view
		override(ERC721TradableUpgradeable, ERC721Upgradeable)
		returns (bool)
	{
		// Whitelist OpenSea proxy contract for easy trading.
		ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
		if (address(proxyRegistry.proxies(owner)) == operator) {
			return true;
		}

		return super.isApprovedForAll(owner, operator);
	}

	function _baseURI() internal pure override returns (string memory) {
		return
			'https://raw.githubusercontent.com/meemproject/metadata/master/meem/';
	}

	// function pause() public onlyOwner {
	function pause() public onlyRole(PAUSER_ROLE) {
		_pause();
	}

	function unpause() public onlyRole(PAUSER_ROLE) {
		_unpause();
	}

	function safeMint(address to) public onlyRole(MINTER_ROLE) {
		_safeMint(to, _tokenIdCounter.current());
		_tokenIdCounter.increment();
	}

	function _beforeTokenTransfer(
		address from,
		address to,
		uint256 tokenId
	)
		internal
		override(ERC721Upgradeable, ERC721EnumerableUpgradeable)
		whenNotPaused
	{
		super._beforeTokenTransfer(from, to, tokenId);
	}

	function _authorizeUpgrade(address newImplementation)
		internal
		override
		onlyRole(UPGRADER_ROLE)
	{}

	// The following functions are overrides required by Solidity.

	function _burn(uint256 tokenId)
		internal
		override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
	{
		super._burn(tokenId);
	}

	function uint2str(uint256 _i)
		internal
		pure
		returns (string memory _uintAsString)
	{
		if (_i == 0) {
			return '0';
		}
		uint256 j = _i;
		uint256 len;
		while (j != 0) {
			len++;
			j /= 10;
		}
		bytes memory bstr = new bytes(len);
		uint256 k = len;
		while (_i != 0) {
			k = k - 1;
			uint8 temp = (48 + uint8(_i - (_i / 10) * 10));
			bytes1 b1 = bytes1(temp);
			bstr[k] = b1;
			_i /= 10;
		}
		return string(bstr);
	}

	function supportsInterface(bytes4 interfaceId)
		public
		view
		override(
			ERC721Upgradeable,
			AccessControlUpgradeable,
			ERC721EnumerableUpgradeable
		)
		returns (bool)
	{
		return super.supportsInterface(interfaceId);
	}

	function mint(address to) external {
		_safeMint(to, _tokenIdCounter.current());
		_inviters[_tokenIdCounter.current()] = msg.sender;
		emit InviterSet(_tokenIdCounter.current(), msg.sender);
		_tokenIdCounter.increment();
	}

	// Who invited the user
	function tokenInviter(uint256 tokenId) public view returns (address) {
		return _inviters[tokenId];
	}

	function _transfer(
		address from,
		address to,
		uint256 tokenId
	) internal virtual override {
		super._transfer(from, to, tokenId);

		// Since the token was transferred, the inviter of the token becomes the from address
		_inviters[tokenId] = from;

		emit InviterSet(tokenId, from);
	}

	function contractURI() public pure returns (string memory) {
		return
			string(
				abi.encodePacked(
					'data:application/json;base64,',
					Base64.encode(
						bytes(
							'{"name": "MeemVite","description": "Meems are pieces of digital content wrapped in more advanced dynamic property rights. They are ideas, stories, images -- existing independently from any social platform -- whose creators have set the terms by which others can access, remix, and share in their value. Join us at https://discord.gg/5NP8PYN8","image": "https://meem-assets.s3.amazonaws.com/meem.jpg","external_link": "https://meem.wtf","seller_fee_basis_points": 0, "fee_recipient": "0xba343c26ad4387345edbb3256e62f4bb73d68a04"}'
						)
					)
				)
			);
	}

	function tokenURI(uint256 tokenId)
		public
		view
		override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
		returns (string memory)
	{
		MeemViteURI uriContract = MeemViteURI(uriContractAddress);
		return uriContract.tokenURI(tokenId);
	}

	function setURIContractAddress(address addr)
		public
		onlyRole(DEFAULT_ADMIN_ROLE)
	{
		uriContractAddress = addr;
	}
}
