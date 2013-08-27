# encoding: UTF-8
require 'spec_helper'

describe Resource do

  before do
    @resource = Resource.new(name: 'Some name', url: 'http://google.ru', schedule_code: 0)
  end

  subject { @resource }

  it { should be_valid }

  describe 'when name is empty' do
    before { @resource.name = '' }
    it { should_not be_valid }
  end

  describe 'when url is empty' do
    before { @resource.url = '' }
    it { should_not be_valid }
  end

  describe 'when url should be valid: ' do
    %w[google.ru http://google.ru http://www.google.ru
        https://google.ru http://www.google.ru тамтэк.рф
        http://тамтэк.рф http://habrahabr.ru/post/82841].each() do |url|
      it "#{url}" do
        @resource.url = url
        should be_valid
      end
    end
  end

  describe 'when url should not be valid: ' do
    %w[as.df asdf http://asdf http://as.df].each() do |url|
      it "#{url}" do
        @resource.url = url
        should_not be_valid
      end
    end
  end


  #describe 'when url is soooo looong' do
  #  before { @resource.url = "http://#{'a'*48}.com" }
  #  it { should_not be_valid }
  #end
  #
  #describe 'when url is soooo looong' do
  #  before { @resource.url = "http://#{'a'*243}.com" }
  #  it { should_not be_valid }
  #end

  describe 'when url is soooo looong' do
    before { @resource.url = "http://#{'a'*250}.com" }
    it { should_not be_valid }
  end

  describe 'when url is soooo looong' do
    before { @resource.url = "http://#{'a'*252}.com" }
    it { should_not be_valid }
  end

end