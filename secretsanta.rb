#!/usr/bin/env ruby
require 'mail'
require 'set'

MAIL_SENDER = 'your_email@example.com'

MAIL_SUBJECT = 'Your Secret Santa Assignment'

PEOPLE = {
  Alice: {
    restrictions: [:Bob],
    email: 'alice@example.com',
    address: "Alice Alison\n123 Example St.\nTestville, MO\n12345-1234\nUSA"
  },
  Bob: {
    restrictions: [],
    email: 'bob@example.com',
    address: "Bob Bobson\n124 Example St.\nTestville, MO\n12345-1234\nUSA"
  },
 Carol: {
  restrictions: [],
  email: 'carol@example.com',
  address: "Carol Carolstein\n125 Example St.\nTestville, MO\n12345-1234\nUSA"
  }
}

def main
  #build graph from PEOPLE
  #shuffle the Hash so that each run of the program is more likely to generate a different path
  shuffler = PEOPLE.to_a.shuffle
  shuffled = Hash[shuffler]
  names = shuffled.keys
  graph = shuffled.each_with_object({}) do |i, mem|
    mem[i[0]] = Set.new(names).subtract(i[1][:restrictions]).subtract([i[0]])
  end
  #Efficient way: Start with the longest restriction list
  #first = shuffled.inject([nil,[]]) { |mem, var| mem[1].length >= var[1].length ? mem : var }
  #first = first[0]
  #More random(?) way, start with a random node
  first = shuffler.sample[0]
  result = circuit([], first, graph)
  if result
    #Set up mail system
    Mail.defaults do
      delivery_method :smtp, {
        address: 'smtp.example.com',
        port: '587',
        user_name: MAIL_SENDER,
        password: 'sender_password',
        authentication: :plain,
        enable_starttls_auto: true
      }
    end
    result.each_cons(2) do |send, rcpt|
      Mail.deliver do
        charset = 'UTF-8'
        from MAIL_SENDER
        to PEOPLE[send][:email]
        subject MAIL_SUBJECT
        body <<BODYEND
Hi there #{send.to_s}, here are the details for this year's Secret Santa!

A quick reminder of the guidelines:
* Enter your organization's guidelines here!

Your giftee is #{rcpt.to_s}. Their full mailing address is:

#{PEOPLE[rcpt][:address]}

Thanks for participating, and we hope you have fun!

Sincerely,
Org-Corp

BODYEND
      end
    end
  else
    puts "Path is #{result ? result : 'impossible'}"
  end
end

def circuit(path, choice, graph)
  path.push(choice)
  if path.length == graph.length
    if graph[path[-1]].include? path[0]
      path.push path[0]
    else
      false
    end
  else
    #What are the available choices?
    available = graph[choice] - path
    available.each do |c|
      result = circuit(path.dup, c, graph)
      return result if result
    end
    return false
  end
end

if __FILE__ == $PROGRAM_NAME
  main
end
