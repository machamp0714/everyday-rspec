require 'rails_helper'

RSpec.describe User, type: :model do
    it 'is valid with a first name, last name, email, and password' 

    it 'is invalid without a first name'

    it 'is invalid without a last name'

    it 'is invalid without an email'

    it 'is invalid with a duplicate email'

    it 'returns a user’s full name as a string'
end
