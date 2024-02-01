# Tasks factory
FactoryBot.define do
  factory :task do
    name        { Faker::Company.catch_phrase }
    description { Faker::Lorem.paragraphs(number: rand(2..8)).join("\n") }
    status      { Task.statuses.keys.sample }

    association :project, factory: :project

    trait :to_do_status do
      status { Task.statuses['to_do'] }
    end

    trait :in_progress_status do
      status { Task.statuses['in_progress'] }
    end

    trait :completed_status do
      status { Task.statuses['completed'] }
    end
  end
end
