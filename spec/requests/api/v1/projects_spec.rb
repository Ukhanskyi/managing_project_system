require 'swagger_helper'

TAGS_PROJECTS = 'Projects'.freeze

RSpec.describe 'Api::V1::ProjectsController', type: :request do # rubocop:disable Metrics/BlockLength
  let(:user) { FactoryBot.create(:user) }
  let(:Authorization) { auth_token(user) }

  path '/api/v1/projects' do # rubocop:disable Metrics/BlockLength
    get('Returns Projects index page') do
      tags TAGS_PROJECTS
      security [jwt: []]

      response(200, 'successful') do
        let!(:projects) { FactoryBot.create_list(:project, 3) }

        it 'returns projects' do
          data = JSON(response.body)

          expect(data.count).to eq(3)
          expect(response).to have_http_status(:success)
        end

        run_test!
      end
    end

    post('Creates a new project') do # rubocop:disable Metrics/BlockLength
      tags TAGS_PROJECTS
      security [jwt: []]

      consumes 'application/json'
      produces 'application/json'

      parameter name: :new_project, in: :body, schema: {
        type: :object,
        properties: {
          project: {
            type: :object,
            properties: {
              name: { type: :string },
              description: { type: :string },
              user_id: { type: :integer }
            },
            required: %w[name description user_id]
          }
        },
        required: [:project]
      }

      response(201, 'project created') do
        let(:new_project) { FactoryBot.attributes_for(:project, name: 'New project', description: 'Lorem Ipsum body for project', user_id: user.id) }

        it 'creates a new project with valid attributes' do
          data = response.parsed_body

          expect(data['name']).to eq('New project')
          expect(response).to have_http_status(:created)
        end
        run_test!
      end

      response(422, 'unprocessable entity') do
        let(:new_project) { FactoryBot.attributes_for(:project, name: nil, description: 'Lorem Ipsum body for project', user_id: nil) }

        it 'doesn`t create a new project with invalid attributes' do
          expect(response).to have_http_status(:unprocessable_entity)
        end
        run_test!
      end
    end
  end

  path '/api/v1/projects/{id}' do # rubocop:disable Metrics/BlockLength
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('Find project by ID') do
      tags TAGS_PROJECTS
      security [jwt: []]

      response(200, 'successful') do
        let(:project) { FactoryBot.create(:project) }
        let(:id)      { project.id }

        it 'renders a successful show page response' do
          data = response.parsed_body

          expect(data['id']).to eq(id)
          expect(response).to have_http_status(:success)
        end
        run_test!
      end

      response(404, 'not found') do
        let(:id) { '000' }

        it 'doesn`t render show page response with invalid id' do
          expect(Project.exists?(id)).to be_falsey
          expect(response).to have_http_status(:not_found)
        end
        run_test!
      end
    end

    patch('Update existing project partially') do # rubocop:disable Metrics/BlockLength
      tags TAGS_PROJECTS
      security [jwt: []]

      consumes 'application/json'
      produces 'application/json'

      parameter name: :project_data, in: :body, schema: {
        type: :object,
        properties: {
          project: {
            type: :object,
            properties: {
              name: { type: :string },
              description: { type: :string },
              user_id: { type: :integer }
            },
            required: %w[name description user_id]
          }
        },
        required: [:project]
      }

      response(200, 'successful') do
        let(:project)      { FactoryBot.create(:project) }
        let(:id)           { project.id }
        let(:project_data) { FactoryBot.attributes_for(:project, name: 'Updated project') }

        it 'updates project with PATCH and valid attributes' do
          data = response.parsed_body

          expect(data['name']).to eq('Updated project')
          expect(response).to have_http_status(:success)
        end

        run_test!
      end

      response('422', 'unprocessable entity') do
        let(:project)      { FactoryBot.create(:project) }
        let(:id)           { project.id }
        let(:project_data) { FactoryBot.attributes_for(:project, user_id: nil) }

        it 'doesn`t update project with PATCH and invalid attributes' do
          expect(response).to have_http_status(:unprocessable_entity)
        end
        run_test!
      end
    end

    put('Update an existing project or create new if project doesn`t exist') do # rubocop:disable Metrics/BlockLength
      tags TAGS_PROJECTS
      security [jwt: []]

      consumes 'application/json'
      produces 'application/json'

      parameter name: :project_data, in: :body, schema: {
        type: :object,
        properties: {
          project: {
            type: :object,
            properties: {
              name: { type: :string },
              description: { type: :string },
              user_id: { type: :integer }
            },
            required: %w[name description user_id]
          }
        },
        required: [:project]
      }

      response(200, 'successful') do
        let(:project)      { FactoryBot.create(:project) }
        let(:id)           { project.id }
        let(:project_data) { FactoryBot.attributes_for(:project, name: 'Updated project', description: 'Updated projects description', user_id: user.id) }

        it 'updates project with PATCH and valid attributes' do
          data = response.parsed_body

          expect(data['name']).to eq('Updated project')
          expect(response).to have_http_status(:success)
        end
        run_test!
      end

      response '422', 'unprocessable entity' do
        let(:project)      { FactoryBot.create(:project) }
        let(:id)           { project.id }
        let(:project_data) { FactoryBot.attributes_for(:project, name: nil, description: 'Updated projects description', user_id: nil) }

        it 'doesn`t update project with PATCH and invalid attributes' do
          expect(response).to have_http_status(:unprocessable_entity)
        end
        run_test!
      end
    end

    delete('Delete a project') do
      tags TAGS_PROJECTS
      security [jwt: []]

      response(204, 'successful') do
        let(:project) { FactoryBot.create(:project) }
        let(:id)      { project.id }

        run_test! do |response|
          expect(response.body).to be_empty
        end
      end

      response(404, 'not found') do
        let(:id) { '000' }

        run_test! do |response|
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end
