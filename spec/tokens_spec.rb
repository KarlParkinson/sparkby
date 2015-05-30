require 'spec_helper'

describe Sparkby do

  describe "#gen_access_token" do
    context "valid email and password" do
      let(:email) {'valid_email'}
      let(:password) {'correct_password'}
      
      context "no expiration arg provided" do

        it "returns a new access_token in the 'access_token' field" do
          response = Sparkby.gen_access_token email, password
          expect(response).to include 'access_token'
          expect(response["access_token"]).to_not be_nil
        end

      end

      context "expiration arg provided" do
        let(:expires_in) { 33600 }
        let(:expires_at) { "2020-01-01" }

        it  "returns a new access_token that expires_in when specified" do
          response = Sparkby.gen_access_token email, password, expires_in
          expect(response["expires_in"]).to eq expires_in
        end

        it "returns a new access_token that expires_at when specified" do
          response = Sparkby.gen_access_token email, password, nil, expires_at
          expect(response["expires_at"]).to eq expires_at
        end
      end
    end

    context "valid email, invalid password" do
      let(:email) {'valid_email'}
      let(:password) {'wrong_password'}
      
      it "returns 'User credentials are invalid' in the response" do
        response = Sparkby.gen_access_token email, password
        expect(response["error_description"]).to eq "User credentials are invalid"
      end

    end

    context "invalid email, valid password" do
      let(:email) {'invalid_email'}
      let(:password) {'correct_password'}
      
      it "returns 'User credentials are invalid' in the response" do
        response = Sparkby.gen_access_token email, password
        expect(response["error_description"]).to eq "User credentials are invalid"
      end

    end
  end

  describe "#del_access_token" do
    let(:token) { "23456hty78" }

    context "valid email and password" do
      let(:email) {'valid_email'}
      let(:password) {'correct_password'}

      it "responds with the 'ok' field as true" do
        response = Sparkby.del_access_token email, password, token
        expect(response["ok"]).to be true
      end

    end

    context "valid email, invalid password" do
      let(:email) {'valid_email'}
      let(:password) {'wrong_password'}
      
      it "should return 'Bad password' in the 'errors' field" do
        response = Sparkby.del_access_token email, password, token
        expect(response["errors"].pop).to eq "Bad password"
      end

    end

    context "invalid email, valid password" do
      let(:email) {'invalid_email'}
      let(:password) {'correct_password'}

      it "should return 'Unknown user' in the 'errors' field" do
        response = Sparkby.del_access_token email, password, token
        expect(response["errors"].pop).to eq "Unknown user"
      end
    end
  end

  describe "#list_tokens" do
    context "valid email and password combo" do
      let (:email) {'valid_email'}
      let(:password) {'correct_password'}

      it "should return the token, expires_at, and client fields for each access token" do
        response = Sparkby.list_tokens email, password
        response.each do |token|
          expect(token).to include 'token', 'expires_at', 'client'
        end
      end
    end
    
    context "valid email, invalid password" do
      let(:email) {'valid_email'}
      let(:password) {'wrong_password'}
      
      it "should return 'Bad password' in the 'errors' field" do
        response = Sparkby.list_tokens email, password
        expect(response["errors"].pop).to eq "Bad password"
      end
    end

    context "invalid email, valid password" do
      let(:email) {'invalid_email'}
      let(:password) {'correct_password'}

      it "should return 'Unknown user' in the 'errors' field" do
        response = Sparkby.list_tokens email, password
        expect(response["errors"].pop).to eq "Unknown user"
      end
    end
    
  end
end
