require 'rails_helper'

RSpec.describe Repayment, type: :model do
  describe "all_repayments_for_user" do
    before :each do
      Repayment.create(payer_email: 'a@g',payee_email: 'b@g', currency: '$', amount: 100, description: "d1")
      Repayment.create(payer_email: 'a@g',payee_email: 'c@g', currency: '$', amount: 50, description: "d2")
      Repayment.create(payer_email: 'b@g',payee_email: 'c@g', currency: '$', amount: 200, description: "d3")
      Repayment.create(payer_email: 'd@g',payee_email: 'a@g', currency: '$', amount: 300, description: "d4")
    end

    context 'user exists' do
      it 'finds the user with the email' do
        temp = Repayment.all_repayment_for_user('a@g')
        descriptions = []
        temp.each do |t|
          descriptions.push(t["description"])
        end
        expect(descriptions).to include('d1')
        expect(descriptions).to include('d2')
        expect(descriptions).to include('d4')
        expect(descriptions).to_not include('d3')
      end
    end
  end

 
end
