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

  def start_console
    puts <<-'EOS'
************************************
***********DEEPQ CONSOLE************
************************************
    EOS
    main_menu
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

  def main_menu
    loop do
      puts <<-"EOS"
-------------Main Menu--------------
plese type a number from menu below

0. exit
1. user
2. directory
3. data entry
4. EAS
      EOS

      case selected_num = gets.to_i
      when 0
        break
      when 1
        user_menu
      when 2
        directory_menu
      when 3
        data_entry_menu
      when 4
        eas_menu
      else
        puts 'please type a number'
        next
      end
    end
  end

  def user_menu
    puts <<-EOS
0. back
1. create user
    EOS

    case selected_num = gets.to_i
    when 1
      create_user
    end
   end

  def directory_menu
    puts <<-EOS
0. back
1. create directory
    EOS

    case selected_num = gets.to_i
    when 1
      create_directory
    end
  end

  def data_entry_menu
    puts <<-EOS
0. back
1. create data entry
2. count data entry
3. find data entry by index
4. find data entry by data certificate
    EOS

    case selected_num = gets.to_i
    when 1
      create_data_entry
    when 2
      count_data_entry
    when 3
      get_data_entry_by_index
    when 4
      get_data_entry_by_data_certificate
    end
end

  def eas_menu
    puts <<-EOS
0. back
1. create eas
2. revoke eas
3. get eas information
    EOS

    case selected_num = gets.to_i
    when 1
      create_eas
    when 2
      revoke_eas
    when 3
      get_eas
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

  def request(method, url, params)
    response = @client.post(url, body: params) if method == 'get'
    response = @client.post(url, body: params) if method == 'post'

    if check_response_status(response)
      result_data = JSON.parse(response.body)

      purified_output(result_data['result'])
    end
  end

  def purified_output(hash)
    hash.each do |k, v|
      puts "#{k} : #{v}"
    end
  end
end

client = DeepqClient.new
client.start_console
