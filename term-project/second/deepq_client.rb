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
require 'json'

class DeepqClient
  def initialize
    # constructor
    @@DEEPQ_URL = 'https://dxdl.deepq.com:5000/'.freeze
    @client = HTTPClient.new

    puts 'connecting to DeepQ service....'

    if deepq_connect_test
      puts "successfully connected to DeepQ service\n"
    else
      puts "connection faild!!!!\nresponse code => #{deepq_connect_test.code}\n"
    end
  end

  def deepq_connect_test
    response = @client.get(@@DEEPQ_URL)
    HTTP::Status.successful?(response.code)
  end

  def check_response_status(response)
    if HTTP::Status.successful?(response.code)
      puts '200 OK response received'
    else
      puts "#{response.code} ERROR request failed"
      error_data = JSON.parse(response.body)
      puts error_data['error']
    end
    HTTP::Status.successful?(response.code)
  end

  def start_console
    puts <<-'EOS'
************************************
***********DEEPQ CONSOLE************
************************************
    EOS

    loop do
      puts <<-"EOS"
-------------Main Menu--------------
plese type a number from menu below

0. exit
1. user
2. directory
      EOS

      selected_num = gets.to_i

      case selected_num

      when 0
        break

      when 1
        puts <<-EOS
0. back
1. create user
        EOS

        selected_num = gets.to_i

        case selected_num
        when 0
          next
        when 1
          create_user
        end

      when 2
        puts <<-EOS
0. back
1. create directory
        EOS

        selected_num = gets.to_i

        case selected_num
        when 0
          next
        when 1
          create_directory
        end
      end
    end
  end

  def purified_output(hash)
    hash.each do |k, v|
      puts "#{k} : #{v}"
    end
  end

  def request(method, url, params)
    response = @client.post(url, body: params) if method == 'get'
    response = @client.post(url, body: params) if method == 'post'

    if check_response_status(response)
      result_data = JSON.parse(response.body)

      purified_output(result_data['result'])
    end
  end

  def build_params(request_params)
    params = {}
    request_params.each do |request_param|
      params[request_param] = ''
    end

    params_size = params.size

    params.each_with_index do |(_param_key, _param_value), i|
      puts "#{i + 1}/#{params_size}. please type #{_param_key}"
      param_value = gets
      params[_param_key] = param_value.strip!
    end
  end

  def create_directory
    url = @@DEEPQ_URL + 'directory/new/'
    request_params = []

    params = build_params(request_params)
    request('post', url, params)
  end

  def create_user
    url = @@DEEPQ_URL + 'user/register'
    request_params = %w[directoryID userType userID password]

    params = build_params(request_params)
    request('post', url, params)
  end

  def create_data_entry
    url = @@DEEPQ_URL + 'entry/create'
    request_params = %w[directoryID userID password offerPrice dueDate dataCertificate dataOwner dataDescription dataAccessPath]

    params = build_params(request_params)
    request('post', url, params)
  end

  def create_eas
    url = @@DEEPQ_URL + 'eas/deploy'
    request_params = %w[directoryID userID dataCertificate expirationDate providerAgreement consumerAgreement]

    params = build_params(request_params)
    request('post', url, params)
  end

  def revoke_eas
    url = @@DEEPQ_URL + 'eas/revoke'
    request_params = %w[directoryID userType userID password EASID]

    params = build_params(request_params)
    request('post', url, params)
  end

  def count_data_entry
    url = @@DEEPQ_URL + 'entry/count'
    request_params = %w[directoryID]

    params = build_params(request_params)
    request('get', url, params)
  end

  def get_data_entry_by_index
    url = @@DEEPQ_URL + 'entry/index'
    request_params = %w[directoryID index]

    params = build_params(request_params)
    request('get', url, params)
  end

  def get_data_entry_by_data_certificate
    url = @@DEEPQ_URL + 'entry/dctf'
    request_params = %w[directoryID dataCertificate]

    params = build_params(request_params)
    request('get', url, params)
  end

  def get_eas
    url = @@DEEPQ_URL + 'eas/sid'
    request_params = %w[EASID]

    params = build_params(request_params)
    request('get', url, params)
  end
end

client = DeepqClient.new
client.start_console
