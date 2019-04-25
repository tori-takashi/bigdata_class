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
require 'HTTPClient'

class DeepqClient
  @URL = 'https://dxdl.deepq.com:5000/'.freeze

  def initialize
    # constructor
    @client = HTTPClient.new
    @client.debug_dev = $stderr
  end

  class DataDirectory
    def initialize
      @data_directory_id
      @users = {}
      @data_entries = {}
    end

    def create_directoy
      path = URL + 'directory/new'
      params = {}
    end
  end

  class User
    def initialize
      @user_id
      @password
      @user_type
    end

    def create_user
      path = URL + 'user/register'
      params = {}
    end
  end

  class DataEntry
    def initialize
      @user_ids = {}
      @password
      @offer_price
      @due_date
      @data_certificate
      @data_access_path
    end

    def create_data_entry
      path = URL + 'entry/create'
      params = {}
    end

    def count_data_entry
      path = URL + 'entry/count'
      params = {}
    end

    def get_data_entry_by_index
      path = URL + 'entry/index'
      params = {}
    end

    def get_data_entry_by_data_certificate
      path = URL + 'entry/dctf'
      params = {}
    end

    def create_eas
      path = URL + 'eas/deploy'
      params = {}
    end

    def get_eas
      path = URL + 'eas/sid'
      params = {}
    end

    def revoke_eas
      path = URL + 'eas/revoke'
      params = {}
    end
  end
  
end
