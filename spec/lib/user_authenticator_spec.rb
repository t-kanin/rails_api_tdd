require 'rails_helper'

describe UserAuthenticator do 

  describe '#perform' do 
    #context is a block of task not different from describe
    let (:authenticator) {described_class.new('sample_code')} # use let to reduce the duplication
    subject {authenticator.perform} # special variable refers to the object being tested

    context 'when code is invalid' do 
      let(:error){
        double("Sawyer::Resource", error: "bad_verification_code")
      }

      before do 
        # the test code should run independently of the environment thus instead of directly request to the giyhub 
        # we will override the method calling to the octokit and the error is copy from the github error
        # meaning the test still pass when there is no internet connection
        allow_any_instance_of(Octokit::Client).to receive(:exchange_code_for_token).and_return(error)
      end 

      it 'should not register the user' do 
        # by doing it like this makes it easier to understand
        # To 'describe' the perform action 'when' the code is invalid 'it' should not register the user
        expect{subject}.to raise_error(
          UserAuthenticator::AuthenticationError
        )
        expect(authenticator.user).to be_nil
      end 
    end 

    context 'when code is valid' do 
      let(:user_data) do 
        {
          login: 'john',
          url: 'www.example.com',
          avatar_url: 'www.example.com/avatar',
          name: 'john smith'
        }
      end 

      before do 
        allow_any_instance_of(Octokit::Client).to receive(:exchange_code_for_token).and_return('validaccesstoken')
        allow_any_instance_of(Octokit::Client).to receive(:user).and_return(user_data)
      end 

      it 'should register the user' do 
        expect{subject}.to change{User.count}.by(1)
        expect(User.last.name).to eq('john smith')
      end 

      it 'should reuse already registered user' do 
        user = create :user, user_data
        expect{subject}.not_to change{User.count}
        expect(authenticator.user).to eq(user)
      end 

      it "should create and set user's access token" do 
        expect{subject}.to change{AccessToken.count}.by(1)
        expect(authenticator.access_token).to be_present
      end 
    end 

  end 
end 