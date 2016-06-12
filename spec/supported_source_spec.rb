require 'spec_helper'

describe SupportedSource do
  it 'has the right version' do
    expect(SupportedSource::VERSION).to eq('0.9.0')
  end

  it 'has the right api endpoint' do
    expect(SupportedSource.supso_api_root).to eq('https://supportedsource.org/api/v1/')
  end
end
