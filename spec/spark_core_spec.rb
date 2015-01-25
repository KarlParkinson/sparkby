require 'spec_helper'

describe SparkCore do

  context "valid_access_token" do
    before(:all) do
       @core = SparkCore.new('valid_access_token', 'valid_device_id')
    end

    context "valid_device_id" do
      before(:all) do
         @device_id = 'valid_device_id'
      end
  
      describe "#devices" do
        it "returns a list of devices owned by the user" do
          response = @core.devices
          expect(response).to respond_to :each
        end

        it "should return the id, name, last_app, last_heard, and connected fields for each device" do
          response = @core.devices
          response.each do |device|
            expect(device).to include 'id', 'name', 'last_app', 'last_heard', 'connected'
          end
        end
      end

      describe "#device_info" do
        it "should return the id, name, connected, variables, functions and cc3000_patch_version for the device id" do
          response = @core.device_info
          expect(response).to include 'id', 'name', 'connected', 'variables', 'functions', 'cc3000_patch_version'
        end
      end

      describe "#spark_variable" do
        context "valid_variable_name" do
          before(:all) do
            @variable = 'valid_variable_name'
          end
          
          it "should return the cmd, name, result, and coreInfo fields" do
            response = @core.spark_variable @variable
            expect(response).to include 'cmd', 'name', 'result', 'coreInfo'
          end

          it "the variable returned should have the same name as the variable in the request" do
            response = @core.spark_variable @variable
            expect(response['name']).to eq @variable
          end
        end

        context "invalid_variable_name" do
          before(:all) do
            @variable = 'invalid_variable_name'
          end

          it "should return 'Variable not found' in the error field" do
            response = @core.spark_variable @variable
            expect(response['error']).to eq 'Variable not found'
          end
        end
      end

      describe "#spark_function" do
        context "valid_function_name" do
          before(:all) do
            @function = 'valid_function_name'
            @arguments = 'args'
          end

          it "should return id, name, connected, and return_value fields" do
            response = @core.spark_function @function, @arguments
            expect(response).to include 'id', 'name', 'connected', 'return_value'
          end
        end
      end

      describe "#access_tokens" do
        context "valid email and password combo" do
          before(:all) do
            @email = "valid_email@email.com"
            @password = "correct_password"
          end

          it "should return the token, expires_at, and client fields for each access token" do
            response = @core.access_tokens @email, @password
            response.each do |token|
              expect(token).to include 'token', 'expires_at', 'client'
            end
          end
        end
      end

      describe "#gen_access_token" do
      end

      describe "#del_access_token" do
      end

      describe "#flash_firmware" do
      end

    end
  end
end
