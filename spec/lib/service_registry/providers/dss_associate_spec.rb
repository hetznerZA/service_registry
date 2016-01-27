require 'spec_helper'

class Tester
  include ServiceRegistry::Providers::DssAssociate
end

describe "ServiceRegistry::Providers::DssAssociate" do
  before :each do
  	@iut = Tester.new
  end

  context "when initialized" do
  	it "should give me a ServiceRegistry::Providers::DssAssociate" do
      expect(@iut.is_a?(ServiceRegistry::Providers::DssAssociate)).to eq(true)
  	end
  end

  context "When associating a DSS" do
  	it "should fail with notification 'no DSS provided' if a DSS is not provided" do
  	  result = @iut.associate_dss(nil)
  	  expect(result['status']).to eq('fail')
  	  expect(result['data']['notifications'].include?('no DSS provided')).to eq(true)
    end

  	it "should fail with notification 'invalid DSS provided' if an invalid DSS is provided" do
  	  result = @iut.associate_dss(" ")
  	  expect(result['status']).to eq('fail')
  	  expect(result['data']['notifications'].include?('invalid DSS provided')).to eq(true)
    end

  	it "should remember a valid DSS provided" do
  		uri = "http://www.google.com"
			result = @iut.associate_dss(uri)
			remembered = @iut.dss
			expect(result['status']).to eq('success')
			expect(remembered['status']).to eq('success')
			expect(remembered['data']['dss']).to eq(uri)
  	end

  	it "should remember a valid DSS provided and forget any prevoious ones" do
  		uri_first = "http://www.google.com"
  		uri_final = "http://www.yahoo.com"
  		expect(uri_first == uri_final).to eq(false)

			result = @iut.associate_dss(uri_first)
			expect(result['status']).to eq('success')
			expect(@iut.dss['data']['dss']).to eq(uri_first)

			result = @iut.associate_dss(uri_final)
			remembered = @iut.dss
			expect(remembered['status']).to eq('success')
			expect(remembered['data']['dss']).to eq(uri_final)
  	end

    it "should give me the DSS if I ask for it" do
			result = @iut.associate_dss("http://www.google.com")
			expect(result['status']).to eq('success')

			remembered = @iut.dss

			dss_present =  (not remembered['data']['dss'].nil?) and remembered['data']['dss'].strip.length > 0
			expect(dss_present).to eq(true)
    end

    it "should fail with notification 'no DSS configured' if it has not been given one" do
    	result = @iut.dss

    	expect(result['status']).to eq('fail')
  	  expect(result['data']['notifications'].include?('no DSS configured')).to eq(true)
    end
  end
end
