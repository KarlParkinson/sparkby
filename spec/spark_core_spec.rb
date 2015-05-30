require 'spec_helper'

describe Sparkby::SparkCore do
  context "valid_access_token and device_id" do
    let(:core) {Sparkby::SparkCore.new 'valid_access_token', 'valid_device_id'}

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
    
  end
end
