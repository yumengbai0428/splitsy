require 'rails_helper'

RSpec.describe User,  type: :model do
  describe "find_user" do
    before :each do
      user1 = User.create(id: 1, name: 'a', email: 'a@g', password: 'p1', default_currency: '$')
      user2 = User.create(id: 2,name: 'b', email: 'b@g', password: 'p2', default_currency: 'Yen')
    end
    context 'user exists' do
      it 'finds the user with the email' do
        expect(User.find_user('a@g').size()).to eql(1)
        expect(User.find_user('a@g')[0].name).to eql('a')
        expect(User.find_user('a@g')[0].password).to eql('p1')
        expect(User.find_user('a@g')[0].default_currency).to eql('$')
        expect(User.find_user('b@g').size()).to eql(1)
        expect(User.find_user('b@g')[0].name).to eql('b')
        expect(User.find_user('b@g')[0].password).to eql('p2')
        expect(User.find_user('b@g')[0].default_currency).to eql('Yen')
      end
    end

    context 'user does not exist' do
      it 'handles sad path' do
        expect(User.find_user('c')[0]).to eql(nil)
      end
    end

  end
end
