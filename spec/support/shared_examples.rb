RSpec.shared_examples 'sign_in_guard' do |http_method|
  it do
    r
    expect(response).to redirect_to sign_in_path
  end
end
