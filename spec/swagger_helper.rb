# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config| # rubocop:disable Metrics/BlockLength
  config.openapi_root = Rails.root.join('swagger').to_s

  config.openapi_specs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'Codica managing project system API V1',
        version: 'v1'
      },
      paths: {},
      servers: [
        {
          url: 'http://{defaultHost}',
          variables: {
            defaultHost: {
              default: 'localhost:3000'
            }
          }
        }
      ],
      components: {
        securitySchemes: {
          jwt: {
            type: :apiKey,
            name: 'Authorization',
            in: :header
          }
        }
      }
    }
  }

  # Defaults to json. Accepts ':json' and ':yaml'.
  config.openapi_format = :yaml

  config.after do |example|
    if respond_to?(:response) && response&.body.present?
      example.metadata[:response][:content] = {
        'application/json' => {
          example: JSON.parse(response.body, symbolize_names: true)
        }
      }
    end
  end
end
