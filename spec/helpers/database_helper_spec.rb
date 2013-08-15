require 'spec_helper'

describe DatabaseHelper do
  MAIL = 'mail@post.com'

  before(:all) { @user_id = 0 }

  describe 'symbolize' do
    it 'should return array of hashes, as origin, but with symbol keys instead string' do
      array_of_hash = [
          {'id1' => 'value 1', 'url1' => 'http://some.url'},
          {'id2' => 'value 1', 'url2' => 'http://another.url'}
      ]
      result = DatabaseHelper.send(:symbolize, array_of_hash)
      array_of_hash.each_with_index do |hash, index|
        hash.each_pair do |key, value|
          result[index][key.to_sym].should == value
        end
      end
    end

    it 'should return empty array if argument is empty array' do
      DatabaseHelper.send(:symbolize, []).should == []
    end

    it 'should return empty array if argument is nil' do
      DatabaseHelper.send(:symbolize, nil).should == []
    end
  end

  describe 'hashize' do
    it 'should return empty hash on empty array' do
      DatabaseHelper.send(:hashize, []).should == {}
    end

    it 'should return empty hash on nil' do
      DatabaseHelper.send(:hashize, nil).should == {}
    end

    it 'should work rightly' do
      array_of_hashes = [
          {"id1" => 12, "name" => "name3"},
          {"id2" => 34, "name" => "name4"},
      ]
      result = DatabaseHelper.send(:hashize, array_of_hashes)

      hash = array_of_hashes[0]
      result[hash['id1']].should == hash['name3']

      hash = array_of_hashes[1]
      result[hash['id2']].should == hash['name4']
    end
  end

  describe 'signin' do
    it 'returns something like user id in the response' do
      user_id = DatabaseHelper.sign_in(MAIL)
      user_id.to_i.should be_an Integer
    end

  end

  describe 'database operations (without signin); ' do
    before { @user_id = DatabaseHelper.sign_in(MAIL) }

    describe 'resource addition' do
      it 'will be success if adds resource' do
        resource = Resource.new(name: 'test resource',
                                url: 'http://localhost:8080',
                                user_id: @user_id,
                                dom_path: '/')
        @id = DatabaseHelper.add_resource(resource)
        @id.should_not == 0
      end
      after do
        DatabaseHelper.delete_resource(@user_id, @id)
      end
    end

    describe 'resource deletion' do
      before do
        @resource = Resource.new(name: 'test',
                                url: 'http://localhost:8080',
                                user_id: @user_id,
                                dom_path: '/')
        @resource.id = DatabaseHelper.add_resource(@resource)
      end
      it 'will be success if deletes resource' do
        @resource.id.should_not == 0
        DatabaseHelper.delete_resource(@resource.user_id, @resource.id).
            should be_true
      end
    end

    describe 'resource edition' do
      before do
        @resource = Resource.new(name: 'test',
                                url: 'http://localhost:8080',
                                user_id: @user_id,
                                dom_path: '/')
        @resource.id = DatabaseHelper.add_resource(@resource)
      end
      it 'will be success if resource will be edited' do
        @resource.url, @resource.name = 'http://127.0.0.1', 'edit test'
        @resource.id.should_not == 0
        DatabaseHelper.edit_resource(@resource).should be_true
      end
      after do
        DatabaseHelper.delete_resource(@resource.user_id, @resource.id)
      end
    end

    describe 'tags addition' do
      it 'will be success if tags will be added' do
        @id = DatabaseHelper.add_tag(@user_id, 'tag name')
        @id.should_not == 0
      end
      after { DatabaseHelper.delete_tag(@user_id, @id) if (@id > 0) }
    end

    describe 'tags deletion' do
      before do
        @id = DatabaseHelper.add_tag(@user_id, 'tag name')
      end
      it 'will be success if tags will be added' do
        @id.should_not == 0
        DatabaseHelper.delete_tag(@user_id, @id).should be_true
      end
    end

    describe 'tag edition' do
      before do
        @id = DatabaseHelper.add_tag(@user_id, 'tag name')
      end
      it 'will be success if tag will be edited' do
        @id.should_not == 0
        DatabaseHelper.edit_tag(@user_id,'another name').should be_true
      end
      after do
        DatabaseHelper.delete_tag(@user_id, @id)
      end
    end
  end
end