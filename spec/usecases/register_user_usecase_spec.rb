require 'rails_helper'

RSpec.describe RegisterUserUsecase do
  it do
    user_id = described_class.perform('ユーザー 氏名', 'UZ')

    user = UserRepository::AR.find_by_id(user_id)

    expect(user.name).to eq 'ユーザー 氏名'
    expect(user.avatar.initials).to eq 'UZ'
    expect(user.avatar.bg).to_not be_nil
    expect(user.avatar.fg).to_not be_nil
  end
end
