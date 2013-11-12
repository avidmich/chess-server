require 'spec_helper'

describe User do
  before {User.create(email: 'test@example.com', first_name: 'First', last_name: 'Last')}
  it '#find_by_email' do
    user = User.find_by_email('test@example.com')
    user.should_not be_nil
    expect(user.email).to eq 'test@example.com'
  end
end
