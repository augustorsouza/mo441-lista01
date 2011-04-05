# DKR

N   = 100
MAX = 5000

class Procez
  attr_reader :send, :status, :uid, :max
  
  def initialize(uid)
    @uid = uid
    @max = uid
    @left = nil
    @status = :active # possible status are: :active, :passive
    @send = [1, @max]
  end
  
  def trans(msg)  
    msg_type, i = msg # msg is an array containing msg_type and i

    if msg_type == 1
      if i != @max
        @send = [2, i]
        @left = i
      else
        @status = :leader_found
        puts "Leader found... the max is #{@max}"
      end
      
    elsif msg_type == 2
      if @left > i && @left > @max
        @max = @left
        @send = [1, @max]
      else
        @status = :passive
      end
    end
  end
end

# Construct the N process array randomically
procezes = []
while procezes.size != N do
  new_process_uid = rand(MAX)
  procezes << Procez.new(new_process_uid) if !procezes.map(&:uid).include?(new_process_uid)
end

puts "Chossen UIDs: #{procezes.map(&:uid).inspect}"
puts "The maximum must be: #{procezes.map(&:uid).sort.last}"

while !procezes.map(&:status).include?(:leader_found)
  procezes = procezes.find_all{ |p| p.status == :active } #eliminates processes which have been turned into passive
  
  # Messages: 
  msgs = procezes.map(&:send) # gets the messages in the beginning of each phase
  
  procezes.each_with_index do |p, idx|
    msg = msgs[idx - 1]
    
    # Trans: 
    p.trans(msg)
  end
end
