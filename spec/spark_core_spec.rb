require 'spec_helper'


describe SparkCore do

  context "valid_access_token" do
    before(:all) do
      @core = SparkCore.new('valid_access_token')
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
          response = @core.device_info @device_id
          expect(response).to include 'id', 'name', 'connected', 'variables', 'functions', 'cc3000_patch_version'
        end
      end

    end
  end

end

#      describe "#spark_variable" do
#      end

#      describe "#spark_function" do
#      end

#      describe "#access_tokens" do
#      end

#      describe "#gen_access_token" do
#      end

#      describe "#del_access_token" do
#      end

#      describe "#flash_firmware" do
#      end

#end
