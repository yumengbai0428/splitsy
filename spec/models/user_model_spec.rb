require 'rails_helper'

RSpec.describe User,  type: :model do
  describe "find_user" do

    User.create(name: 'a', email: 'a@g', password: 'p1', default_currency: '$')
    User.create(name: 'b', email: 'b@g', password: 'p2', default_currency: 'Yen')
    
    context 'user exists' do
      it 'finds the user with the email' do
        expect(User.find_user('a@g').name).to eql('a')
        expect(User.find_user('a@g').password).to eql('p1')
        expect(User.find_user('a@g').default_currency).to eql('$')
        expect(User.find_user('b@g').name).to eql('b')
        expect(User.find_user('b@g').password).to eql('p2')
        expect(User.find_user('b@g').default_currency).to eql('Yen')
      end
    end

    context 'user does not exist' do
      it 'handles sad path' do
        expect(User.find_user('c')).to eql(nil)
      end
    end

  end
end
