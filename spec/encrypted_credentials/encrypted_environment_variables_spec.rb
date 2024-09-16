require "spec_helper"
require "encrypted_credentials/encrypted_environment_variables"

module EncryptedCredentials
  RSpec.describe EncryptedEnvironmentVariables do
    it "decrypts parameters from AWS Parameter Store" do
      environment = { "SECRET_SSM_PARAMETER_NAME" => "my-secret-parameter-name" }

      encrypted_environment_variables = EncryptedEnvironmentVariables.new(ssm_client: stub_ssm_client, environment:)

      encrypted_environment_variables.decrypt

      expect(environment.key?("SECRET")).to eq(true)
    end

    def stub_ssm_client
      Aws::SSM::Client.new(
        stub_responses: {
          get_parameters: lambda { |context|
            {
              parameters: context.params[:names].map do |name|
                Aws::SSM::Types::Parameter.new(
                  name:,
                  value: name.delete_prefix("ssm-parameter-name-")
                )
              end
            }
          }
        }
      )
    end
  end
end
