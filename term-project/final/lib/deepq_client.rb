require 'httpclient'
require 'json'

class DeepqClient

  def initialize
    @@DEEPQ_URL = 'https://dxdl.deepq.com:5000/'.freeze
    @client = HTTPClient.new
    raise unless connect_test
  end

  def create_directory

    url = @@DEEPQ_URL + 'directory/new/'
    params = {}
    result = request('post', url, params)

    directoryID = result["directoryID"]
  end

  def create_user(directoryID, userType, userID, password)

    url = @@DEEPQ_URL + 'user/register'
    params = { directoryID: directoryID, userType: userType, userID: userID, password: password}
    result = request('post', url, params)

    return true  if result["message"] == "Register user successfully."
    raise        if result["message"] != "Register user successfully."
  end

  def create_data_entry(directoryID, userID, password, offerPrice, \
    dueDate, dataCertificate, dataOwner, dataDescription, dataAccessPath)
    
    url = @@DEEPQ_URL + 'entry/create'
    params = {directoryID: directoryID, userID: userID, password: password, offerPrice: offerPrice,\
        dueDate: dueDate, dataCertificate: dataCertificate, dataOwner: dataOwner,\
        dataDescription: dataDescription, dataAccessPath: dataAccessPath }
    result = request('post', url, params)

    return true if result["txHash"].present?
    raise       if result["txHash"].blank?
  end

  def create_eas(directoryID, userID, dataCertificate, expirationDate, providerAgreement, consumerAgreement)

    url = @@DEEPQ_URL + 'eas/deploy'
    params = {directoryID: directoryID, userID: userID, dataCertificate: dataCertificate,\
       expirationDate: expirationDate, providerAgreement: providerAgreement, consumerAgreement: consumerAgreement}
    result = request('post', url, params)
  end

  def revoke_eas(directoryID, userType, userID, password, easID)
    url = @@DEEPQ_URL + 'eas/revoke'
    params = {directoryID: directoryID, userType: userType, userID: userID, password: password, easID: easID}
    result = request('post', url, params)
  end

  def count_data_entry(directoryID)
    url = @@DEEPQ_URL + 'entry/count'
    params = {directoryID: directoryID}
    result = request('get', url, params)
  end

  def list_data_entry(directoryID)
    count_url  = @@DEEPQ_URL + 'entry/count'
    index_url  = @@DEEPQ_URL + 'entry/index'

    request_params_search = { directoryID: directoryID, index: 0 }
    result = {}

    count_params = {directoryID: directoryID}
    count_result = request('get', count_url, count_params)

    if count_result.present?
      count = count_result['entryCount'].to_i

      count.times do |i|
        request_params_search[:index] = i
        ith_result = request('get', index_url, request_params_search)
        result[i] = ith_result
      end
      result
    end

  end

  def get_data_entry_by_index(directoryID, index)
    url = @@DEEPQ_URL + 'entry/index'
    params = {directoryID: directoryID, index: index}
    result = request('get', url, params)
  end

  def get_data_entry_by_data_certificate(directoryID, dataCertificate)
    url = @@DEEPQ_URL + 'entry/dctf'
    params = {directoryID: directoryID, dataCertificate: dataCertificate}
    result = request('get', url, params)
  end

  def get_eas(easID)
    url = @@DEEPQ_URL + 'eas/sid'
    params = {easID: easID}
    result = request('get', url, params)
  end

  def connect_test
    response = @client.get(@@DEEPQ_URL)
    HTTP::Status.successful?(response.code)
  end

  def check_response_status(response)
    status_OK = HTTP::Status.successful?(response.code)
    unless status_OK
      error_data = JSON.parse(response.body)
      error_data['error']
    end
  end

  def request(method, url, params)
    response = @client.get(url, query: params) if method == 'get'
    response = @client.post(url, body: params) if method == 'post'
    
    result_data = JSON.parse(response.body) # if check_response_status(response)
    puts "***result data is below***"
    puts result_data
    result_data['result'] if result_data
  end

end
