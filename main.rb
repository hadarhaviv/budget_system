require "./FileUtilities.rb"
require "./Account.rb"

require "tty-prompt"

$prompt = TTY::Prompt.new
$user_data

CHOICES = [
    {name: "New income", value: 1},
    {name: "New expanse", value: 2},
    {name: "Search a record", value: 3},
    {name: "List all records", value: 4},
    {name: "Exit", value: 5}
]

if !FileUtilities.load("user").nil?
  $user_data = FileUtilities::load("user")
else
  name = prompt.ask("What is your name?", default: ENV["USER"]).chomp
  budget = prompt.ask("What is your budget?", default: 0).chomp
  $user_data = {
      name: name,
      balance: budget
  }
  FileUtilities::save("user", user_data)
end

def main
  puts "Hello #{$user_data[:name]} Your budget is #{$user_data[:balance]}"
  user_account = Account.new($user_data[:name], $user_data[:balance].to_i)
  user_input = 0

  while true
    user_input = $prompt.select("*** Current balance: #{user_account.balance}$ ***", CHOICES)

    case user_input
    when 1
      amount = $prompt.ask('amount?', convert: :int)
      description = $prompt.ask('please enter description:')
      user_account.deposit(amount, description)
      puts "Done"
    when 2
      amount = $prompt.ask('amount?', convert: :int)
      description = $prompt.ask('please enter description:')
      user_account.withdraw(amount, description)
      puts "Done"
    when 3
      puts "Please enter search query"
      search_query = gets.chomp
      searched_records = user_account.list_records(search_query)
      puts "Found #{searched_records.count} records "
      puts "for #{search_query}" unless search_query.empty?
      puts "-------------------------------"

      searched_records.each do |record|
        puts "#{record[:description]} | #{record[:type] === "expanse" ? "-" : "+"}#{record[:amount]}$"
      end
    when 4
      searched_records = user_account.list_records
      searched_records.each do |record|
        puts "#{record[:description]} | #{record[:type] === "expanse" ? "-" : "+"}#{record[:amount]}$"
      end
    when 5
      exit
    end
  end
end

main




