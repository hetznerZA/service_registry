require "spec_helper"

require "service_registry/factory/environment_context/env_dict"

describe ServiceRegistry::Factory::EnvironmentContext::EnvDict do

  context "Given a simple environment and no path" do

    let(:env) do
      {"PROVIDER" => "juddi"}
    end

    subject { described_class.new(env) }

    it "provides access to each value by string key" do
      expect(subject["provider"]).to eq env["PROVIDER"]
    end

    it "raises KeyError with name of environment variable for a nonexistent key" do
      expect { subject["nonexistent"] }.to raise_error(KeyError, /\bNONEXISTENT\b/)
    end

    it "raises a RuntimeError if asked to scrub" do
      expect { subject.scrub! }.to raise_error(RuntimeError, /refusing to scrub without path/)
    end

  end

  context "Given a simple environment and a path" do

    let(:env) do
      {"CONFIG_PROVIDER" => "juddi"}
    end

    subject { described_class.new(env, "config") }

    it "provides access to each value by string key" do
      expect(subject["provider"]).to eq env["CONFIG_PROVIDER"]
    end

    it "raises KeyError with name of environment variable for a nonexistent key" do
      expect { subject["nonexistent"] }.to raise_error(KeyError, /\bCONFIG_NONEXISTENT\b/)
    end


    it "scrubs the environment on request" do
      subject.scrub!
      expect(env["CONFIG_PROVIDER"]).to be_nil
    end

  end

  context "Given extraneous keys in the environment and a path" do

    let(:env) do
      {"HOME" => "/home/configservice",
       "SERVICE_REGISTRY_PROVIDER" => "juddi"}
    end

    subject { described_class.new(env, "config") }

    it "raises KeyError for access to values outside the path" do
      expect { subject["home"] }.to raise_error(KeyError, /\bCONFIG_HOME\b/)
    end

    it "does not scrub values outside the path" do
      subject.scrub!
      expect(env["HOME"]).to eq env["HOME"]
    end

  end

  context "Given extraneous keys in the environment and no path" do

    let(:env) do
      {"HOME" => "/home/configservice",
       "USER" => "vault"}
    end

    subject { described_class.new(env) }

    it "provides access to all values" do
      expect(subject["home"]).to eq env["HOME"]
      expect(subject["user"]).to eq env["USER"]
    end

    it "raises a RuntimeError if asked to scrub" do
      expect { subject.scrub! }.to raise_error(RuntimeError, /refusing to scrub without path/)
    end

  end

  context "Given an exact match and substrings of path" do
    let(:env) do
      {"SERVICE_REGISTRY_PROVIDER" => "juddi",
       "SERVICE_REGISTRY_PROVIDER_ADDRESS" => "http://127.0.0.1:8009"}
    end

    subject { described_class.new(env, "config", "provider") }

    it "does not provide access to the exact match" do
      expect(subject.values).to_not include("vault")
    end

    it "provides access to the values of substrings of path" do
      expect(subject["address"]).to eq env["SERVICE_REGISTRY_ADDRESS"]
    end

    it "scrubs substrings of path" do
      subject.scrub!
      expect(env["SERVICE_REGISTRY_ADDRESS"]).to be_nil
    end

    it "does not scrub the exact match" do
      subject.scrub!
      expect(env["SERVICE_REGISTRY_PROVIDER"]).to_not be_nil
    end

  end

  describe "As a hash" do

    let(:env) do
      {"SERVICE_REGISTRY_TOKEN" => "543b8c05-0899-41e4-bb00-40d1283ebf32"}
    end

    subject { described_class.new(env, "config") }

    it "supports string access" do
      expect(subject["token"]).to eq env["SERVICE_REGISTRY_TOKEN"]
    end

    it "supports symbolic access" do
      expect(subject[:token]).to eq env["SERVICE_REGISTRY_TOKEN"]
    end

    class TokenReceiver # :nodoc:
      def initialize(options = {})
        @token = options[:token]
      end

      def received_token?
        !!@token
      end
    end

    it "uses symbols as natural keys for use as keyword arguments" do
      r = TokenReceiver.new(subject)
      expect(r.received_token?).to eq true
    end

    it "is empty after scrubbing" do
      subject.scrub!
      expect { subject["token"] }.to raise_error(SecurityError, /scrub/)
    end

    it "does not mutate values it has returned" do
      token = subject["token"]
      subject.scrub!
      expect(token).to eq "543b8c05-0899-41e4-bb00-40d1283ebf32"
    end

  end

  describe "#subslice!(key)" do

    let(:env) do
      {
        "SERVICE_REGISTRY_IDENTIFIER" => "acme",
        "SERVICE_REGISTRY_TOKEN" => "f1652fda-ee7b-4772-af7c-b71320f4cdb0",
        "SERVICE_REGISTRY_PROVIDER" => "vault",
        "SERVICE_REGISTRY_ADDRESS" => "http://127.0.0.1:8009"
      }
    end

    subject do
      described_class.new(env, "SERVICE_REGISTRY")
    end

    it "returns a dict whose keys are constrained by the new key" do
      slice = subject.subslice!(:provider)
      expect { slice[:token] }.to raise_error(KeyError, /\bSERVICE_REGISTRY_TOKEN\b/)
    end

    it "returns dict whose keys are relative to the new key" do
      slice = subject.subslice!(:provider)
      expect(slice[:address]).to eq env["SERVICE_REGISTRY_ADDRESS"]
    end

    it "returns a dict that is scrubbed when the parent dict is scrubbed" do
      slice = subject.subslice!(:provider)
      subject.scrub!
      expect { slice[:address] }.to raise_error(SecurityError, /scrub/)
    end

    it "makes the sliced keys inaccessible in the parent dict" do
      subject.subslice!(:provider)
      expect { subject[:provider_address] }.to raise_error(KeyError, /\bSERVICE_REGISTRY_ADDRESS\b/)
    end

  end

end
