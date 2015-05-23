require 'spec_helper'

describe SparkCore do
  context "valid_access_token and device_id" do
    let(:core) {SparkCore.new 'valid_access_token', 'valid_device_id'}

    describe "#devices" do

      it "returns a list of devices owned by the user" do
        response = core.devices
        expect(response).to respond_to :each
      end

      it "should return the id, name, last_app, last_heard, and connected fields for each device" do
        response = core.devices
        response.each do |device|
          expect(device).to include 'id', 'name', 'last_app', 'last_heard', 'connected'
        end
      end

    end

    describe "#device_info" do

      it "should return the id, name, connected, variables, functions and cc3000_patch_version for the device id" do
        response = core.device_info
        expect(response).to include 'id', 'name', 'connected', 'variables', 'functions', 'cc3000_patch_version'
      end

    end

    describe "#spark_variable" do
      context "valid_variable_name" do
        let(:variable) {'valid_variable_name'}

        it "should return the cmd, name, result, and coreInfo fields" do
          response = core.spark_variable variable
          expect(response).to include 'cmd', 'name', 'result', 'coreInfo'
        end

        it "the variable returned should have the same name as the variable in the request" do
          response = core.spark_variable variable
          expect(response['name']).to eq variable
        end

      end

      context "invalid_variable_name" do
        let(:variable) {'invalid_variable_name'}

        it "should return 'Variable not found' in the error field" do
          response = core.spark_variable variable
          expect(response['error']).to eq 'Variable not found'
        end

      end
    end

    describe "#spark_function" do
      context "valid_function_name" do
        let(:function) {'valid_function_name'}
        let(:arguments) {'args'}

        it "should return id, name, connected, and return_value fields" do
          response = core.spark_function function, arguments
          expect(response).to include 'id', 'name', 'connected', 'return_value'
        end

      end
    end

    describe "#access_tokens" do
      context "valid email and password combo" do
        let (:email) {'valid_email'}
        let(:password) {'correct_password'}

        it "should return the token, expires_at, and client fields for each access token" do
          response = core.access_tokens email, password
          response.each do |token|
            expect(token).to include 'token', 'expires_at', 'client'
          end
        end
      end
      
      context "valid email, invalid password" do
        let(:email) {'valid_email'}
        let(:password) {'wrong_password'}
        
        it "should return 'Bad password' in the 'errors' field" do
          response = core.access_tokens email, password
          expect(response["errors"].pop).to eq "Bad password"
        end
      end

      context "invalid email, valid password" do
        let(:email) {'invalid_email'}
        let(:password) {'correct_password'}

        it "should return 'Unknown user' in the 'errors' field" do
          response = core.access_tokens email, password
          expect(response["errors"].pop).to eq "Unknown user"
        end
      end
      
    end

    describe "#gen_access_token" do
      context "valid email and password" do
        let(:email) {'valid_email'}
        let(:password) {'correct_password'}
        
        context "no expiration arg provided" do

          it "returns a new access_token in the 'access_token' field" do
            response = core.gen_access_token email, password
            expect(response).to include 'access_token'
            expect(response["access_token"]).to_not be_nil
          end

        end

        context "expiration arg provided" do
          let(:expires_in) { 33600 }
          let(:expires_at) { "2020-01-01" }

          it  "returns a new access_token that expires_in when specified" do
            response = core.gen_access_token email, password, expires_in
            expect(response["expires_in"]).to eq expires_in
          end

          it "returns a new access_token that expires_at when specified" do
            response = core.gen_access_token email, password, nil, expires_at
            expect(response["expires_at"]).to eq expires_at
          end
        end
      end

      context "valid email, invalid password" do
        let(:email) {'valid_email'}
        let(:password) {'wrong_password'}
     
        it "returns 'User credentials are invalid' in the response" do
          response = core.gen_access_token email, password
          expect(response["error_description"]).to eq "User credentials are invalid"
        end

      end

      context "invalid email, valid password" do
        let(:email) {'invalid_email'}
        let(:password) {'correct_password'}
        
        it "returns 'User credentials are invalid' in the response" do
          response = core.gen_access_token email, password
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
          response = core.del_access_token email, password, token
          expect(response["ok"]).to be true
        end

      end

      context "valid email, invalid password" do
        let(:email) {'valid_email'}
        let(:password) {'wrong_password'}
        
        it "should return 'Bad password' in the 'errors' field" do
          response = core.del_access_token email, password, token
          expect(response["errors"].pop).to eq "Bad password"
        end

      end

      context "invalid email, valid password" do
        let(:email) {'invalid_email'}
        let(:password) {'correct_password'}

        it "should return 'Unknown user' in the 'errors' field" do
          response = core.del_access_token email, password, token
          expect(response["errors"].pop).to eq "Unknown user"
        end
      end
    end
  end
end
