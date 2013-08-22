# encoding: UTF-8
require 'spec_helper'

describe 'Tag' do

  before { @tag = Tag.new({ name: 'some tag name'}) }

  subject { @tag }

  describe 'when tag is valid' do
    it { @tag.valid?.should be_true }
  end

  describe 'when tag name is empty' do
    before { @tag.name = '' }
    it { @tag.valid?.should be_false }
  end

  describe 'when tag name is nil' do
    before { @tag.name = nil }
    it { @tag.valid?.should be_false }
  end

  describe 'when tag name sooo looong' do
    before { @tag.name = 'a'*31 }
    it { @tag.valid?.should be_false }
  end

  describe 'when tag nfme is cyrillic' do
    before { @tag.name = 'некий тэг' }
    it { @tag.valid?.should be_true }
  end
end