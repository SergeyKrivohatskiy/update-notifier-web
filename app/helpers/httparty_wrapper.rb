require 'cgi'

module HTTPartyWrapper

  #@address = '172.16.9.215'
  @address = ENV['DATABASE_ADDRESS']
  #@address = 'localhost'
  #@port = '8080'

  def self.address(command, args)
    if args.blank?
      full_args=''
    elsif args.is_a? Hash
      full_args = args.inject('?') do |addr, pair|
        addr+"&#{pair.first}=#{CGI::escape pair.last}"
      end
      full_args[1]=''
    else
      full_args="?#{args.to_s}"
    end
    "http://#{@address}/users/#{command}#{full_args}"
  end

  def self.get(command, url_args=nil)
    HTTParty.get(address(command, url_args))
  end

  def self.post(command, url_arg, args)
    HTTParty.post(address(command, url_arg), body: args.to_json,
                  headers: { 'Content-Type' => 'application/json; charset=UTF-8' })
  end

  def self.put(command, url_arg, args)
    HTTParty.put(address(command, url_arg), body: args.to_json,
                  headers: { 'Content-Type' => 'application/json; charset=UTF-8' })
  end

  def self.delete(command, url_arg=nil)
    HTTParty.delete(address(command, url_arg))
  end
end