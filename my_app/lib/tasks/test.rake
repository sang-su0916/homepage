# frozen_string_literal: true

# Clean Architecture 테스트 디렉토리 추가
namespace :test do
  desc "Run tests for domains"
  task domains: :environment do
    $LOAD_PATH << "test"
    Rails::TestUnit::Runner.run(["test/domains"])
  end

  desc "Run tests for repositories"
  task repositories: :environment do
    $LOAD_PATH << "test"
    Rails::TestUnit::Runner.run(["test/repositories"])
  end

  desc "Run tests for use_cases"
  task use_cases: :environment do
    $LOAD_PATH << "test"
    Rails::TestUnit::Runner.run(["test/use_cases"])
  end

  desc "Run tests for components"
  task components: :environment do
    $LOAD_PATH << "test"
    Rails::TestUnit::Runner.run(["test/components"])
  end

  desc "Run all clean architecture tests"
  task architecture: [:domains, :repositories, :use_cases, :components]
end
