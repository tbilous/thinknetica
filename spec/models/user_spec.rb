require 'rails_helper'

RSpec.describe User, type: :model do
  include_context 'oauth'

  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:votes) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '.find_for_oauth' do
    context 'user already has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: facebook.provider, uid: facebook.uid)
        expect(User.find_for_oauth(facebook)).to eq user
      end
    end

    context 'user has not authorization' do
      context 'user already exists' do
        it 'does not create new user' do
          expect { User.find_for_oauth(facebook) }.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect { User.find_for_oauth(facebook) }.to change(user.authorizations, :count).by(1)
        end

        it 'create authorization with provider and uid' do
          user = User.find_for_oauth(facebook)
          authorization = user.authorizations.first

          expect(authorization.provider).to eq facebook.provider
          expect(authorization.uid).to eq facebook.uid
        end

        it 'returns the user' do
          expect(User.find_for_oauth(facebook)).to eq user
        end
      end
    end

    context 'user does not exist' do
      before do
        facebook.info[:email] = 'new@email.com'
        facebook.uid = '54321'
      end

      it 'creates new user' do
        expect { User.find_for_oauth(facebook) }.to change(User, :count).by(1)
      end

      it 'returns new user' do
        expect(User.find_for_oauth(facebook)).to be_a(User)
      end

      it 'feels user email' do
        user =  User.find_for_oauth(facebook)
        expect(user.email).to eq facebook.info[:email]
      end

      it 'creates authorization for user' do
        user = User.find_for_oauth(facebook)
        expect(user.authorizations).to_not be_empty
      end

      it 'creates authorization with provider and uid' do
        authorization = User.find_for_oauth(facebook).authorizations.first

        expect(authorization.provider).to eq facebook.provider
        expect(authorization.uid).to eq facebook.uid
      end
    end
  end

  # describe '.send_daily_digest' do
  #   include_context 'users'
  #   let!(:users) { [user, tom, john] }
  #
  #   # it { binding.pry }
  #
  #   it 'should sent daily digest to all users' do
  #     users.each { |user|
  #       expect(DailyMailer).to receive(:digest).with(user).and_call_original
  #     }
  #     User.send_daily_digest
  #   end
  # end
end
