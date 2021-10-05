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

	function tokenURI(uint256 tokenId)
		public
		pure
		override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
		returns (string memory)
	{
		// return super.tokenURI(tokenId);
		// string memory baseURI = _baseURI();
		// return
		// 	bytes(baseURI).length > 0
		// 		? string(abi.encodePacked(baseURI, tokenId.toString(), '.json'))
		// 		: '';
		// string[3] memory parts;
		// parts[
		// 	0
		// ] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: white; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="black" /><text x="10" y="20" class="base">Meem Test';

		// parts[1] = uint2str(tokenId);

		// parts[2] = '</text></svg>';

		// string memory svg = string(
		// 	abi.encodePacked(parts[0], parts[1], parts[2])
		// );

		// string memory json = Base64.encode(
		// 	bytes(
		// 		string(
		// 			abi.encodePacked(
		// 				'{"name": "MeemVite #',
		// 				uint2str(tokenId),
		// 				'", "description": "MeemVite is your access token to Meem Discord", "image": "data:image/svg+xml;base64,',
		// 				Base64.encode(bytes(svg)),
		// 				'"}'
		// 			)
		// 		)
		// 	)
		// );

		// string memory output = string(
		// 	abi.encodePacked('data:application/json;base64,', json)
		// );

		// string memory output = string(
		// 	abi.encodePacked(
		// 		'data:application/json;base64,',
		// 		Base64.encode(
		// 			bytes(
		// 				abi.encodePacked(
		// 					'{"name":"',
		// 					'MeemVite Test ',
		// 					uint2str(tokenId),
		// 					'", "description":"Meemvite Testing", "attributes":"", "image":"data:image/svg+xml;base64,',
		// 					Base64.encode(bytes(svg)),
		// 					'"}'
		// 				)
		// 			)
		// 		)
		// 	)
		// );

		string memory output = string(
			abi.encodePacked(
				'data:application/json;base64,',
				Base64.encode(
					bytes(
						abi.encodePacked(
							'{"name":"MeemVite #","description":"A MeemVite","external_url":"https://meem.wtf/tokens/0","image":"data:image/svg+xml;base64,',
							Base64.encode(
								'<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: white; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="black" /><text x="10" y="20" class="base">Meem Test 1</text></svg>'
							),
							'","background_color":"FF0000","_animation_url":"","_youtube_url":"","attributes":[{"trait_type":"Kind","value":"Genesis"},{"display_type":"date","trait_type":"birthday","value":1632859345},{"trait_type":"Base","value":"Starfish"},{"trait_type":"Eyes","value":"Big"},{"trait_type":"Mouth","value":"Surprised"},{"trait_type":"Level","value":5},{"trait_type":"Stamina","value":1.4},{"trait_type":"Personality","value":"Sad"},{"display_type":"boost_number","trait_type":"Aqua Power","value":40},{"display_type":"boost_percentage","trait_type":"Stamina Increase","value":10},{"display_type":"number","trait_type":"Generation","value":2}]}'
						)
					)
				)
			)
		);

		return output;
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

	function svgToImageURI(string memory svg)
		public
		pure
		returns (string memory)
	{
		string memory baseURL = 'data:image/svg+xml;base64,';
		string memory svgBase64Encoded = Base64.encode(
			bytes(string(abi.encodePacked(svg)))
		);
		return string(abi.encodePacked(baseURL, svgBase64Encoded));
	}

	function contractURI() public pure returns (string memory) {
		return
			string(
				abi.encodePacked(
					'data:application/json;base64,',
					Base64.encode(
						bytes(
							'{"name": "MeemVite Test","description": "On-chain test","image": "https://openseacreatures.io/image.png","external_link": "https://openseacreatures.io","seller_fee_basis_points": 1000, "fee_recipient": "0xba343c26ad4387345edbb3256e62f4bb73d68a04"}'
						)
					)
				)
			);
	}
}
