require 'spec_helper'

describe "ServiceRegistry::Providers::BootstrappedProvider" do

	before :each do
  	@configuration_service = ServiceRegistry::Test::StubConfigurationService.new
  	@iut = ServiceRegistry::Providers::BootstrappedProvider.new
  end

	context "when bootstrapping" do
		it "should not have a configuration" do
			expect(@iut.configuration).to eq(nil)
		end

		it "should set availability to false during bootstrap" do
			@iut.bootstrap(nil, nil)
			expect(@iut.available?).to eq({"status"=>"success", "data"=>{"available"=>false, "notifications"=>["success"]}})
		end

		it "should fail with 'invalid configuration service' if no configuration is provided" do
			expect(@iut.bootstrap(nil, nil)).to eq({"status"=>"fail", "data"=>{"result"=>nil, "notifications"=>["invalid configuration service"]}})
		end

		it "should fail with 'no configuration service' if the configuration provided does not have CFGSRV_PROVIDER_ADDRESS" do
			expect(@iut.bootstrap({}, nil)).to eq({"status"=>"fail", "data"=>{"result"=>nil, "notifications"=>["no configuration service"]}})
		end

		it "should fail with 'no identifier' if the configuration provided does not have CFGSRV_IDENTIFIER" do
			expect(@iut.bootstrap({ 'CFGSRV_PROVIDER_ADDRESS' => 'http://localhost'}, nil)).to eq({"status"=>"fail", "data"=>{"result"=>nil, "notifications"=>["no identifier"]}})
		end

		it "should fail with 'invalid identifier' if the CFGSRV_IDENTIFIER provided is empty" do
			expect(@iut.bootstrap({ 'CFGSRV_PROVIDER_ADDRESS' => 'http://localhost', 'CFGSRV_IDENTIFIER' => "   "}, nil)).to eq({"status"=>"fail", "data"=>{"result"=>nil, "notifications"=>["invalid identifier"]}})
		end

		it "should fail with 'configuration error' if the configuration could not be retrieved from the configuration service" do
			@configuration_service.break
      expect(@iut.bootstrap({ 'CFGSRV_PROVIDER_ADDRESS' => 'http://localhost', 'CFGSRV_IDENTIFIER' => "BootstrappedProvider"}, @configuration_service)).to eq({"status"=>"fail", "data"=>{"result"=>nil, "notifications"=>["configuration error"]}})
		end

		it "should fail with 'no configuration' if the configuration retrieved is nil" do
      expect(@iut.bootstrap({ 'CFGSRV_PROVIDER_ADDRESS' => 'http://localhost', 'CFGSRV_IDENTIFIER' => "BootstrappedProvider"}, @configuration_service)).to eq({"status"=>"fail", "data"=>{"result"=>nil, "notifications"=>["no configuration"]}})
		end

		it "should fail with 'invalid configuration' if the configuration retrieved is empty" do
      @configuration_service.configure({})
      expect(@iut.bootstrap({ 'CFGSRV_PROVIDER_ADDRESS' => 'http://localhost', 'CFGSRV_IDENTIFIER' => "BootstrappedProvider"}, @configuration_service)).to eq({"status"=>"fail", "data"=>{"result"=>nil, "notifications"=>["invalid configuration"]}})
		end

  	it "should set availability to true after successful bootstrap" do
      @configuration_service.configure({ 'key' => 'value'})
      @iut.bootstrap({ 'CFGSRV_PROVIDER_ADDRESS' => 'http://localhost', 'CFGSRV_IDENTIFIER' => "BootstrappedProvider" }, @configuration_service)
			expect(@iut.available?).to eq({"status"=>"success", "data"=>{"available"=>true, "notifications"=>["success"]}})
		end

		it "should success with 'configuration valid' and 'valid identifier' if the bootstrap was successful and the configuration valid" do
      @configuration_service.configure({ 'key' => 'value'})
      expect(@iut.bootstrap({ 'CFGSRV_PROVIDER_ADDRESS' => 'http://localhost', 'CFGSRV_IDENTIFIER' => "BootstrappedProvider" }, @configuration_service)).to eq({"status"=>"success", "data"=>{"result"=>nil, "notifications"=>["configuration valid", "valid identifier"]}})
		end
	end

	context "when asked if available" do
		it "should return jsend with 'available' set to false if not successfully bootstrapped" do
			@iut.bootstrap(nil, nil)
			expect(@iut.available?).to eq({"status"=>"success", "data"=>{"available"=>false, "notifications"=>["success"]}})
		end

		it "should return jsend with 'available' set to true if successfully bootstrapped" do
      @configuration_service.configure({ 'key' => 'value'})
      @iut.bootstrap({ 'CFGSRV_PROVIDER_ADDRESS' => 'http://localhost', 'CFGSRV_IDENTIFIER' => "BootstrappedProvider" }, @configuration_service)
			expect(@iut.available?).to eq({"status"=>"success", "data"=>{"available"=>true, "notifications"=>["success"]}})
		end
	end
end
