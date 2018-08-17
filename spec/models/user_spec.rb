require 'spec_helper.rb'

describe User do
  describe 'Password generation' do
    let(:encrypted_pass) { 'md5' * 10 }

    it 'can not be created without a password' do
      user = User.new(name: 'Hulk')
      expect(user.save).to be_nil
      expect(user.errors.on(:password)).to eq ['is not present']
    end

    it 'changes password when `new_password` is set and password is empty' do
      user = User.new(name: 'Hulk', new_password: 'pass')
      expect(user.password).to be_nil
      expect(user.save).to_not be_nil
      expect(user.password).to_not be_nil
    end

    it 'changes password when `new_password` is set and password is not empty' do
      user = create(:user)
      expect do
        user.new_password = 'my_new_password'
        user.save
      end.to(change { user.password })
    end

    it 'should use Digest::MD5.hexdigest to generate password' do
      allow(Digest::MD5).to receive(:hexdigest) { encrypted_pass }
      user = User.new(name: 'Hulk', new_password: 'pass')
      expect(user.save).to_not be_nil
      expect(user.password).to eq encrypted_pass
    end
  end
end
