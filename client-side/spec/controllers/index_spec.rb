require 'spec_helper'

describe 'index controller' do

  describe 'Controller' do
    it 'loads the home page' do
      get '/'
      expect(last_response.status).to eq(200)
    end
  end

end
