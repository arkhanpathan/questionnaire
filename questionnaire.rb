require "pstore" #Added pstore to save temporary data in database

STORE_NAME = "tendable.pstore"
store = PStore.new(STORE_NAME)

QUESTIONS = {
  "q1" => "Can you code in Ruby?",
  "q2" => "Can you code in JavaScript?",
  "q3" => "Can you code in Swift?",
  "q4" => "Can you code in Java?",
  "q5" => "Can you code in C#?"
}.freeze

def do_prompt(store)
  # Ask each question and get an answer from the user's input.
  yes_count = 0
  QUESTIONS.each_key do |question_key|
    loop do
      print "#{QUESTIONS[question_key]} (Yes/No): "
      ans = gets.chomp.downcase
      if %w[yes no y n].include?(ans)
        # Save answer count if user replied yes, no, y, n
        yes_count += 1 if %w[yes y].include?(ans)
        break
      else
        # Ask user to fill input again for wrong input
        puts "Invalid input. Please answer with Yes, No, Y, or N."
      end
    end
  end
  # Save values in pstore
  store.transaction do
    store[:results] ||= []
    store[:results] << { yes_count: yes_count, total_questions: QUESTIONS.size }
  end
end

def do_report(store)
  # Show report
  store.transaction(true) do
    results = store[:results] || []
    return if results.empty?

    last_run = results.last
    run_rating = (100.0 * last_run[:yes_count] / last_run[:total_questions]).round(2)
    puts "Your rating for this run: #{run_rating}%"

    total_yes = results.sum { |r| r[:yes_count] }
    total_questions = results.sum { |r| r[:total_questions] }
    avg_rating = (100.0 * total_yes / total_questions).round(2)
    puts "Average rating for all runs: #{avg_rating}%"
  end
end

do_prompt(store)
do_report(store)
