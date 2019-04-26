require 'httpclient'
require 'json'

class DeepqClient
  def initialize
    # constructor
    @@DEEPQ_URL = 'https://dxdl.deepq.com:5000/'.freeze
    @client = HTTPClient.new
    @directory_id

    puts 'connecting to DeepQ service....'

    if deepq_connect_test
      puts "successfully connected to DeepQ service\n"
      puts 'Do you have a directoryID? (y/n)'
      opt = gets.chomp!

      if opt == 'y'
        puts 'please type your directoryID'
        directory_id = gets.chomp!
        @directory_id = directory_id.freeze
      else
        puts 'creating directory. please wait a minutes...'
        create_directory
      end

    else
      puts "connection faild!!!!\nresponse code => #{deepq_connect_test.code}\n"
    end
  end

  def start_console
    puts <<-"EOS"
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
    result = request('post', url, params)

    @directory_id = result['directoryID']
  end

  def create_user
    url = @@DEEPQ_URL + 'user/register'
    request_params = %w[directoryID userType userID password]

    params = build_params(request_params)
    result = request('post', url, params)
    purified_output(result)
  end

  def create_data_entry
    url = @@DEEPQ_URL + 'entry/create'
    request_params = %w[directoryID userID password offerPrice dueDate dataCertificate dataOwner dataDescription dataAccessPath]

    params = build_params(request_params)
    result = request('post', url, params)
    purified_output(result)
  end

  def create_eas
    url = @@DEEPQ_URL + 'eas/deploy'
    request_params = %w[directoryID userID dataCertificate expirationDate providerAgreement consumerAgreement]

    params = build_params(request_params)
    result = request('post', url, params)
    purified_output(result)
  end

  def revoke_eas
    url = @@DEEPQ_URL + 'eas/revoke'
    request_params = %w[directoryID userType userID password EASID]

    params = build_params(request_params)
    result = request('post', url, params)
    purified_output(result)
  end

  def count_data_entry
    url = @@DEEPQ_URL + 'entry/count'
    request_params = %w[directoryID]

    params = build_params(request_params)
    result = request('get', url, params)
    purified_output(result)
  end

  def list_data_entry
    counter_url = @@DEEPQ_URL + 'entry/count'
    request_params_counter = %w[directoryID]

    counter_params = build_params(request_params_counter)
    counter_data = request('get', counter_url, counter_params)
    count = counter_data['entryCount'].to_i

    searcher_url = @@DEEPQ_URL + 'entry/index'
    request_params_search = { directoryID: @directory_id, index: 0 }

    count.times do |i|
      puts "---------------------------------------------------------"
      request_params_search[:index] = i
      result = request('get', searcher_url, request_params_search)
      purified_output(result)
    end
  end

  def get_data_entry_by_index
    url = @@DEEPQ_URL + 'entry/index'
    request_params = %w[directoryID index]

    params = build_params(request_params)
    result = request('get', url, params)
    purified_output(result)
  end

  def get_data_entry_by_data_certificate
    url = @@DEEPQ_URL + 'entry/dctf'
    request_params = %w[directoryID dataCertificate]

    params = build_params(request_params)
    result = request('get', url, params)
    purified_output(result)
  end

  def get_eas
    url = @@DEEPQ_URL + 'eas/sid'
    request_params = %w[EASID]

    params = build_params(request_params)
    result = request('get', url, params)
    purified_output(result)
  end

  def main_menu
    loop do
      puts <<-"EOS"
-------------Main Menu--------------
plese type a number from menu below
the directory ID is #{@directory_id}

0. exit
1. user
2. data entry
3. EAS
      EOS

      case selected_num = gets.to_i
      when 0
        break
      when 1
        user_menu
      when 2
        data_entry_menu
      when 3
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

  def data_entry_menu
    puts <<-EOS
0. back
1. create data entry
2. count data entry
3. find data entry by index
4. find data entry by data certificate
5. list data entry
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
    when 5
      list_data_entry
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
      if _param_key == 'directoryID'
        # [FIXME] adhook dealing
        puts @directory_id
        params[_param_key] = @directory_id
        next
      end

      param_value = gets.chomp!
      params[_param_key] = param_value
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
    response = @client.get(url, query: params) if method == 'get'
    response = @client.post(url, body: params) if method == 'post'

    result_data = JSON.parse(response.body) if check_response_status(response)
    result_data['result'] if result_data
  end

  def purified_output(hash)
    return if hash.nil?

    hash.each do |k, v|
      puts "#{k} : #{v}"
    end
  end
end

client = DeepqClient.new
client.start_console
