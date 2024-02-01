require 'swagger_helper'

TAGS_TASKS = 'Tasks'.freeze

RSpec.describe 'Api::V1::TasksController', type: :request do # rubocop:disable Metrics/BlockLength
  let(:user)          { FactoryBot.create(:user) }
  let(:Authorization) { auth_token(user) }
  let(:project)       { FactoryBot.create(:project) }

  path '/api/v1/tasks' do # rubocop:disable Metrics/BlockLength
    get('Returns Tasks index page') do # rubocop:disable Metrics/BlockLength
      tags TAGS_TASKS
      security [jwt: []]
      parameter name: :by_status,
                in: :query,
                type: :string,
                required: false,
                description: 'Filter tasks by status (to_do, in_progress, completed)'

      response(200, 'successful') do
        let!(:tasks) { FactoryBot.create_list(:task, 3) }

        it 'returns tasks' do
          data = JSON(response.body)

          expect(data.count).to eq(3)
          expect(response).to have_http_status(:success)
        end
        run_test!
      end

      context 'when filtered by status' do
        response(200, 'successful') do
          let(:by_status)       { 'in_progress' }
          let!(:to_do_tasks)    { FactoryBot.create_list(:task, 3, :to_do_status) }
          let!(:filtered_tasks) { FactoryBot.create_list(:task, 2, :in_progress_status) }

          it 'returns tasks filtered by status' do
            data = JSON(response.body)

            expect(data.count).to eq(2)
            expect(response).to have_http_status(:success)
          end
          run_test!
        end
      end
    end

    post('Creates a new task') do # rubocop:disable Metrics/BlockLength
      tags TAGS_TASKS
      security [jwt: []]

      consumes 'application/json'
      produces 'application/json'

      parameter name: :new_task, in: :body, schema: {
        type: :object,
        properties: {
          task: {
            type: :object,
            properties: {
              name: { type: :string },
              description: { type: :string },
              status: {
                type: :string,
                enum: %w[to_do in_progress completed]
              },
              project_id: { type: :integer }
            },
            required: %w[name description status project_id]
          }
        },
        required: [:task]
      }

      response(201, 'task created') do
        let(:new_task) { FactoryBot.attributes_for(:task, :to_do_status, name: 'New task', description: 'Lorem Ipsum body for task', project_id: project.id) }

        it 'creates a new task with valid attributes' do
          data = response.parsed_body

          expect(data['name']).to eq('New task')
          expect(response).to have_http_status(:created)
        end
        run_test!
      end

      response(422, 'unprocessable entity') do
        let(:new_task) { FactoryBot.attributes_for(:task, name: nil, description: 'Lorem Ipsum body for task', project_id: nil) }

        it 'doesn`t create a new task with invalid attributes' do
          expect(response).to have_http_status(:unprocessable_entity)
        end
        run_test!
      end
    end
  end

  path '/api/v1/tasks/{id}' do # rubocop:disable Metrics/BlockLength
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('Find task by ID') do
      tags TAGS_TASKS
      security [jwt: []]

      response(200, 'successful') do
        let(:task) { FactoryBot.create(:task) }
        let(:id)   { task.id }

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
          expect(Task.exists?(id)).to be_falsey
          expect(response).to have_http_status(:not_found)
        end
        run_test!
      end
    end

    patch('Update existing task partially') do # rubocop:disable Metrics/BlockLength
      tags TAGS_TASKS
      security [jwt: []]

      consumes 'application/json'
      produces 'application/json'

      parameter name: :task_data, in: :body, schema: {
        type: :object,
        properties: {
          task: {
            type: :object,
            properties: {
              name: { type: :string },
              description: { type: :string },
              status: {
                type: :integer,
                enum: %w[to_do in_progress completed]
              },
              project_id: { type: :integer }
            },
            required: %w[name description status project_id]
          }
        },
        required: [:task]
      }

      response(200, 'successful') do
        let(:task)      { FactoryBot.create(:task) }
        let(:id)        { task.id }
        let(:task_data) { FactoryBot.attributes_for(:task, name: 'Updated task') }

        it 'updates task with PATCH and valid attributes' do
          data = response.parsed_body

          expect(data['name']).to eq('Updated task')
          expect(response).to have_http_status(:success)
        end

        run_test!
      end

      response('422', 'unprocessable entity') do
        let(:task)      { FactoryBot.create(:task) }
        let(:id)        { task.id }
        let(:task_data) { FactoryBot.attributes_for(:task, project_id: nil) }

        it 'doesn`t update task with PATCH and invalid attributes' do
          expect(response).to have_http_status(:unprocessable_entity)
        end
        run_test!
      end
    end

    put('Update an existing task or create new if task doesn`t exist') do # rubocop:disable Metrics/BlockLength
      tags TAGS_TASKS
      security [jwt: []]

      consumes 'application/json'
      produces 'application/json'

      parameter name: :task_data, in: :body, schema: {
        type: :object,
        properties: {
          task: {
            type: :object,
            properties: {
              name: { type: :string },
              description: { type: :string },
              status: {
                type: :integer,
                enum: %w[to_do in_progress completed]
              },
              project_id: { type: :integer }
            },
            required: %w[name description status project_id]
          }
        },
        required: [:task]
      }

      response(200, 'successful') do
        let(:task)      { FactoryBot.create(:task) }
        let(:id)        { task.id }
        let(:task_data) { FactoryBot.attributes_for(:task, name: 'Updated task', description: 'Updated task description', project_id: project.id) }

        it 'updates task with PATCH and valid attributes' do
          data = response.parsed_body

          expect(data['name']).to eq('Updated task')
          expect(response).to have_http_status(:success)
        end
        run_test!
      end

      response '422', 'unprocessable entity' do
        let(:task)      { FactoryBot.create(:task) }
        let(:id)        { task.id }
        let(:task_data) { FactoryBot.attributes_for(:task, name: nil, description: 'Updated task description', project_id: nil) }

        it 'doesn`t update task with PATCH and invalid attributes' do
          expect(response).to have_http_status(:unprocessable_entity)
        end
        run_test!
      end
    end

    delete('Delete a task') do
      tags TAGS_TASKS
      security [jwt: []]

      response(204, 'successful') do
        let(:task) { FactoryBot.create(:task) }
        let(:id) { task.id }

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
