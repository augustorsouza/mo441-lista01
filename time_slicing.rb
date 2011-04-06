# Time slicing

N   = 100
MAX = 500

class Procez
  attr_reader :uid, :status, :send
  
  def initialize(uid)
    @uid = uid
    @count = N
    @send = nil
    @phase = 0
    @status = :not_leader
  end
  
  def trans(msg)  
    if msg == nil
      if @phase == @uid
        @send = @uid
        @status = :leader
      else
        @send = nil
        if @count == 0
          @phase += 1
          @count = N
        else
          @count -= 1
        end
      end
    else
      @status = :not_leader
      @send = msg
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
puts "The leader must be: #{procezes.map(&:uid).sort.first}"

while !(procezes.find_all{ |p| p.status == :leader }.size == 1 && procezes.find_all{ |p| p.status == :not_leader }.size == N - 1)
  # Messages: 
  msgs = procezes.map(&:send) # gets the messages in the beginning of each phase
  
  procezes.each_with_index do |p, idx|
    msg = msgs[idx - 1]
    
    # Trans: 
    p.trans(msg)
  end
end

puts "The leader is: #{procezes.find{ |p| p.status == :leader }.uid}"