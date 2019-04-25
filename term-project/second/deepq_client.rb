# Requirements
#
# You need to implement the following functions for DDS :
#     DDS implemented by students should create their own directory to save data information.
#     Users can register accounts.
#     A seller can upload data information to the directory created by DDS.
#     A buyer can search data on DDS, which consists of all sellers’ data information.
#     A buyer can browse the data information of all available data (not the deleted ones).
#     When an EAS is established between a buyer and a seller, the EAS is deployed by DDS on Ethereum.
#     A buyer or a seller can browse all EAS’s that he/she has deployed or revoked.
#     An EAS is invoked by the buyer to access the data, and either a buyer or a seller can revoke an EAS.
#
# Rules
# You should follow the rules below to implement this system:
#
#     You can create one directory, all the left operations should use the same directory.
#     Only registered provider can create data entry.
#     Each data certificate can be used to create only one data entry. It can only be used once.
#     EAS is deployed by the platform after platform receive the agreements from both buyer and seller. The userID of the API is consumerID.
#     Only provider and consumer of the EAS that has been deployed can revoke the deal.
#     Those deals that are already revoked should not be revoked twice.
require 'httpclient'

class DeepqClient
  def initialize
    # constructor
    @@URL = 'https://dxdl.deepq.com:5000/'.freeze
    @client = HTTPClient.new
    puts connect_test.code
  end

  def connect_test
    response = @client.get(@@URL)
  end
end

a = DeepqClient.new