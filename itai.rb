# Itai e Rodeh

N = 10

class Procez
  attr_reader :send, :uid, :status
  
  def initialize(uid)
    @uid = uid
    @n = N    # number of active processes 
    @k = nil  # number of processes which sorted 1
    @r = nil  # number randommically chossen in this round
    @round = 0
    @status = :active
    @send = nil
  end
  
  def trans(msg)
    @send = msg

    if @round == 0
      @k = 0
      
      if @status == :active
        @r = rand(@n)
        
        puts "UID: #{@uid} ** R: #{@r}"
        
        if @r == 1
          @send = @r
          @k += 1 
        else
          @send = nil
        end
      end
    else 
      @k += 1 if msg == 1
      
      if @round == N - 1
        @send = nil

        @n = @k if @k != 0
        
        if @k == 1 && @r == 1
          @status = :leader
        elsif @k >= 1 && @r != 1
          @status = :inactive
        end
      end
    end
    
    @round = (@round + 1) % N
  end
end

# Construct the N process array 
procezes = []
N.times { |n| procezes << Procez.new(n) } 

puts "Chossen UIDs: #{procezes.map(&:uid).inspect}"

j = 0
phase = 0

while procezes.find_all{ |p| p.status == :leader }.size != 1
  if (j % N == 0)
    puts "Phase #{phase}:"
    phase += 1 
  end
  j += 1  

  # Messages: 
  msgs = procezes.map(&:send) # gets the messages in the beginning of each phase

  procezes.each_with_index do |p, idx|
    msg = msgs[idx - 1]
    
    # Trans: 
    p.trans(msg)
  end  
end

puts "The leader is: #{procezes.find{ |p| p.status == :leader }.uid}"
