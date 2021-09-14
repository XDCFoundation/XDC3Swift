//
//  XRC721.swift
//  XDC
//
// Created by Developer on 15/06/21.
//

import Foundation
import BigInt

public class XRC721: XRC165 {
    
    /**
     Count all NFTs assigned to an owner NFTs assigned to the zero address are considered invalid, and this
     function throws for queries about the zero address.
     @param tokenAddress
     @param owner An address for whom to query the balance
     @return The number of NFTs owned by owner , possibly zero
     */
    public func balanceOf(contract: XDCAddress,
                          address: XDCAddress,
                          completion: @escaping((Error?, BigUInt?) -> Void)) {
        let function = XRC721Functions.balanceOf(contract: contract, owner: address)
        function.call(withClient: client,
                      responseType: XRC721Responses.balanceResponse.self) { (error, response) in
                        return completion(error, response?.value)
        }
    }
    /**
     Find the owner of an NFT, NFTs assigned to zero address are considered invalid, and queries about them do throw.
     @param tokenAddress
     @param _tokenId The identifier for an NFT
     @return The address of the owner of the NFT
     */
    public func ownerOf(contract: XDCAddress,
                        tokenId: BigUInt,
                        completion: @escaping((Error?, XDCAddress?) -> Void)) {
        let function = XRC721Functions.ownerOf(contract: contract, tokenId: tokenId)
        function.call(withClient: client,
                      responseType: XRC721Responses.ownerResponse.self) { (error, response) in
                        return completion(error, response?.value)
        }
    }
    /**
     Get the approved address for a single NFT
     @dev Throws if `_tokenId` is not a valid NFT
     @param tokenAddress
     @param _tokenId The NFT to find the approved address for
     @return The approved address for this NFT, or the zero address if there is none
     */
    public func getApproved(contract: XDCAddress,
                            tokenId: BigUInt,
                            completion: @escaping((Error?, XDCAddress?) -> Void)) {
        let function = XRC721Functions.getApproved(contract: contract, tokenId: tokenId)
        function.call(withClient: client,
                      responseType: XRC721Responses.getApproved.self) { (error, response) in
            return completion(error, response?.value)
        }
    }
    /*
     @notice Query if an address is an authorized operator for another address
     @param _owner The address that owns the NFTs
     @param _operator The address that acts on behalf of the owner
     @return True if `_operator` is an approved operator for `_owner`, false otherwise
    */
    public func isApprovedForAll(contract: XDCAddress,
                             opearator: XDCAddress,
                             owner: XDCAddress,
                            completion: @escaping((Error?, Bool?) -> Void)) {
        let function = XRC721Functions.isApprovedForAll(contract: contract, opearator: opearator, owner: owner)
        function.call(withClient: client,
                      responseType: XRC721Responses.isApprovedForAll.self) { (error, response) in
            return completion(error, response?.value)
        }
    }
    
}

public class XRC721Metadata: XRC721 {
    public struct Token: Equatable, Decodable {
        public typealias PropertyType = Equatable & Decodable
        public struct Property<T: PropertyType>: Equatable, Decodable {
            public var description: T
        }
        
        enum CodingKeys: String, CodingKey {
            case title
            case type
            case properties
            case fallback_property_image = "image"
            case fallback_property_description = "description"
            case fallback_property_name = "name"
        }
        
        public init(title: String?,
                    type: String?,
                    properties: Properties?) {
            self.title = title
            self.type = type
            self.properties = properties
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.title = try? container.decode(String.self, forKey: .title)
            self.type = try? container.decode(String.self, forKey: .type)
            let properties = try? container.decode(Properties.self, forKey: .properties)
            
            if let properties = properties {
                self.properties = properties
            } else {
                // try decoding properties from root directly
                let name = try? container.decode(String.self, forKey: .fallback_property_name)
                let image = try? container.decode(URL.self, forKey: .fallback_property_image)
                let description = try? container.decode(String.self, forKey: .fallback_property_description)
                if name != nil || image != nil || description != nil {
                    self.properties = Properties(name: Property(description: name),
                                                 description: Property(description: description),
                                                 image: Property(description: image))
                } else {
                    self.properties = nil
                }
            }
        }
        
        public struct Properties: Equatable, Decodable {
            public var name: Property<String?>
            public var description: Property<String?>
            public var image: Property<URL?>
        }
        
        public var title: String?
        public var type: String?
        public var properties: Properties?
    }
    
    public let session: URLSession
    
    public init(client: XDCClient, metadataSession: URLSession) {
        self.session = metadataSession
        super.init(client: client)
    }
    
    // @notice A descriptive name for a collection of NFTs in this contract
    
    public func name(contract: XDCAddress,
                     completion: @escaping((Error?, String?) -> Void)) {
        let function = XRC721MetadataFunctions.name(contract: contract)
        function.call(withClient: client, responseType: XRC721MetadataResponses.nameResponse.self) { error, response in
            return completion(error, response?.value)
        }
    }
    
    // @notice An abbreviated name for NFTs in this contract
    
    public func symbol(contract: XDCAddress,
                       completion: @escaping((Error?, String?) -> Void)) {
        let function = XRC721MetadataFunctions.symbol(contract: contract)
        function.call(withClient: client, responseType: XRC721MetadataResponses.symbolResponse.self) { error, response in
            return completion(error, response?.value)
        }
    }
    /*
     @notice A distinct Uniform Resource Identifier (URI) for a given asset.
     Metadata JSON Schema".
     */
    public func tokenURI(contract: XDCAddress,
                         tokenID: BigUInt,
                         completion: @escaping((Error?, URL?) -> Void)) {
        let function = XRC721MetadataFunctions.tokenURI(contract: contract,
                                                        tokenID: tokenID)
        function.call(withClient: client, responseType: XRC721MetadataResponses.tokenURIResponse.self) { error, response in
            return completion(error, response?.value)
        }
    }
    
   
    public func tokenMetadata(contract: XDCAddress,
                              tokenID: BigUInt,
                              completion: @escaping((Error?, Token?) -> Void)) {
        tokenURI(contract: contract,
                 tokenID: tokenID) { [weak self] error, response in
            guard let response = response else {
                return completion(error, nil)
            }
            
            if let error = error {
                return completion(error, nil)
            }
            
            let baseURL = response
            let task = self?.session.dataTask(with: baseURL,
                                              completionHandler: { (data, response, error) in
                                                guard let data = data else {
                                                    return completion(error, nil)
                                                }
                                                if let error = error {
                                                    return completion(error, nil)
                                                }
                                                
                                                do {
                                                    var metadata = try JSONDecoder().decode(Token.self, from: data)
                                                    
                                                    if let image = metadata.properties?.image.description, image.host == nil, let relative = URL(string: image.absoluteString, relativeTo: baseURL) {
                                                        metadata.properties?.image = Token.Property(description: relative)
                                                    }
                                                    completion(nil, metadata)
                                                } catch let decodeError {
                                                    completion(decodeError, nil)
                                                }
                                              })
            
            task?.resume()
        }
    }
}

public class XRC721Enumerable: XRC721 {
    /*
     @notice Count NFTs tracked by this contract
     @return A count of valid NFTs tracked by this contract, where each one of
     them has an assigned and queryable owner not equal to the zero address
     */
    public func totalSupply(contract: XDCAddress,
                            completion: @escaping((Error?, BigUInt?) -> Void)) {
        let function = XRC721EnumerableFunctions.totalSupply(contract: contract)
        function.call(withClient: client, responseType: XRC721EnumerableResponses.numberResponse.self) { error, response in
            return completion(error, response?.value)
        }
    }
    /*
     @notice Enumerate valid NFTs
     @dev Throws if `_index` >= `totalSupply()`.
     @param _index A counter less than `totalSupply()`
     @return The token identifier for the `_index`th NFT,
     */
    public func tokenByIndex(contract: XDCAddress,
                             index: BigUInt,
                             completion: @escaping((Error?, BigUInt?) -> Void)) {
        let function = XRC721EnumerableFunctions.tokenByIndex(contract: contract, index: index)
        function.call(withClient: client, responseType: XRC721EnumerableResponses.numberResponse.self) { error, response in
            return completion(error, response?.value)
        }
    }
    /*
     @notice Enumerate NFTs assigned to an owner
     @param _owner An address where we are interested in NFTs owned by them
     @param _index A counter less than `balanceOf(_owner)`
     @return The token identifier for the `_index`th NFT assigned to `_owner`,
     */
    public func tokenOfOwnerByIndex(contract: XDCAddress,
                                    owner: XDCAddress,
                                    index: BigUInt,
                                    completion: @escaping((Error?, BigUInt?) -> Void)) {
        let function = XRC721EnumerableFunctions.tokenOfOwnerByIndex(contract: contract, address: owner, index: index)
        function.call(withClient: client, responseType: XRC721EnumerableResponses.numberResponse.self) { error, response in
            return completion(error, response?.value)
        }
    }
}
