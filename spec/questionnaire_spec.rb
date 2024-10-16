require 'pstore'
require_relative '../questionnaire'

RSpec.describe "Questionnaire" do
  let(:store) { PStore.new("test_store.pstore") }

  before do
    store.transaction do
      store[:results] = []  # Clear results before each test
    end
  end

  after do
    File.delete("test_store.pstore") if File.exist?("test_store.pstore")  # Cleanup after each test
  end

  describe '#do_prompt' do
    it 'should count valid Yes/No answers correctly' do
      allow_any_instance_of(Object).to receive(:gets).and_return('Yes', 'No', 'Y', 'N', 'yes')
      do_prompt(store)

      store.transaction(true) do
        results = store[:results]
        expect(results.length).to eq(1)  # Expect 1 run to be stored
        expect(results.last[:yes_count]).to eq(3)  # 3 "Yes" answers (Yes, Y, yes)
        expect(results.last[:total_questions]).to eq(5)
      end
    end

    it 'should reject invalid answers and keep prompting until valid input' do
      allow_any_instance_of(Object).to receive(:gets).and_return('invalid', 'maybe', 'Yes', 'No', 'Y', 'N', 'yes')
      do_prompt(store)

      store.transaction(true) do
        results = store[:results]
        expect(results.length).to eq(1)  # Expect 1 run
        expect(results.last[:yes_count]).to eq(3)
      end
    end
  end

  describe '#do_report' do
    before do
      store.transaction do
        store[:results] << { yes_count: 3, total_questions: 5 }  # First run: 60%
        store[:results] << { yes_count: 4, total_questions: 5 }  # Second run: 80%
      end
    end

    it 'should calculate the correct rating for the last run' do
      expect { do_report(store) }.to output(/Your rating for this run: 80.0%/).to_stdout
    end

    it 'should calculate the correct average rating across all runs' do
      expect { do_report(store) }.to output(/Average rating for all runs: 70.0%/).to_stdout
    end
  end
end
