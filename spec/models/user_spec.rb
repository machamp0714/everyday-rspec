require 'rails_helper'

RSpec.describe User, type: :model do
    it 'is valid with a first name, last name, email, and password' do
        user = User.new(
            first_name: 'user',
            last_name: 'test',
            email: 'test@gmail.com',
            password: 'password'
        )
        expect(user).to be_valid
    end

    it 'is invalid without a first name'

    it 'is invalid without a last name'

    it 'is invalid without an email'

    it 'is invalid with a duplicate email'

    it 'returns a user’s full name as a string'
end
