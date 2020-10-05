require "json"
require "./FileUtilities.rb"

class Account
  attr_accessor :records
  attr_reader :balance

  def initialize(name, balance)
    @name = name
    @balance = balance
    @records = get_records
  end

  def get_records
    if !FileUtilities.load("records").nil?
      FileUtilities.load("records")[:records]
    else
      []
    end
  end

  def deposit(amount, description)
    @balance += amount
    record = {
      type: "income",
      description: description,
      amount: amount
    }

    @records = @records.push(record)
    FileUtilities.save("records", {"records" => records})
    FileUtilities.save("user", {"name" => @name, "balance" => @balance})
  end

  def withdraw(amount, description)
    @balance -= amount
    record = {
      type: "expanse",
      description: description,
      amount: amount
    }

    @records = @records.push(record)
    FileUtilities.save("records", {"records" => records})
    FileUtilities.save("user", {"name" => @name, "balance" => @balance})
  end

  def list_records(search_query = "")
     @records.any? ? @records.select { |record| record[:description].include? search_query } : []
  end
end


