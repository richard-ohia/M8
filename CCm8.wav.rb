use_bpm 60
#Define a function for repeating patterns
define:piano do
  play :C5, amp: 0.3
  sleep 0.5
  play :G4, amp: 0.3
  sleep 0.5
  play :Gs3, amp: 0.3
  sleep 1.5
  
  play :As3, release: 0.5, amp: 0.3
  sleep 0.5
  play :G4, release: 0.5, amp: 0.3
  sleep 0.5
  play :D5, release: 0.5, amp: 0.3
  sleep 0.5
  
  play :C4, amp: 0.3
  sleep 0.5
  play :As4, amp: 0.3
  sleep 0.5
  play :Ds5, amp: 0.3
  sleep 1.5
  
  play :Fs3, release: 0.6, amp: 0.3
  sleep 0.5
  play :As4, release: 0.6, amp: 0.3
  sleep 0.5
  play :F5, release: 0.6, amp: 0.3
  sleep 0.5
end

# Play the piano chord with a different rhythm each time
define :creative_piano_pattern do |chord|
  4.times do
    play chord, amp: 0.4, release: 2
    sleep [0.5, 0.25, 0.75].choose
  end
end

#Define the cowbell function
define:cow do
  pattern = (bools 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0)
  if pattern.tick(:snap)
    sample :drum_cowbell, amp: 0.1
  end
  sleep 0.125
end

#Define a drum pattern
define:main_drums do
  sample :drum_bass_hard, amp: 0.5
  sleep 0.5
  sample :drum_splash_soft, amp: 0.5
  sleep 0.25
  sample :drum_bass_hard, amp: 0.5
  sleep 0.25
  sample :drum_cymbal_soft, amp: 0.5
  sleep 0.5
  sample :drum_heavy_kick, amp: 0.5
  sleep 0.25
  sample :drum_bass_soft, amp: 0.5
  sleep 0.5
  sample :drum_bass_hard, amp: 0.5
  sleep 0.25
  sample :drum_cymbal_closed, amp: 0.5
  sleep 0.5
end

#Main pattern with piano, choir, cowbell, and drums
define:core do
  counter = 0
  80.times do
    puts counter
    if counter.between?(1, 2)
      sample :ambi_choir, release: 3, amp: 0.5
    elsif counter.between?(33, 35)
      puts "Hit"
      sample :bd_808, amp: 0.9, release: 4
    end
    if counter == 0
      #Play piano only
      piano
    elsif counter == 1
      #Play piano and choir
      piano
    elsif counter == 2
      #Play piano with cowbell
      in_thread(name: :cowbell) do
        loop do
          cow
          break if counter >= 35
        end
      end
      in_thread(name: :piano) do
        loop do
          piano
          break if counter >= 29
        end
      end
      #control :cowbell, amp: 0, amp_slide: 1
    elsif counter > 35
      #Play piano with cowbell and drums
      in_thread(name: :cowbell) do
        loop do
          cow
          break if counter >= 79
        end
      end
      in_thread(name: :drums) do
        loop do
          if counter < 60
            play chord(:G4, :minor), amp: 0.5, release: 2
          end
          sample :drum_bass_hard, amp: 0.5, release: 3, pan: -1
          sleep 0.5
          sample :drum_bass_hard, amp: 0.5, release: 3, pan: 1
          sleep 0.25
          sample :loop_safari, amp: 0.4
          main_drums
          break if counter >= 77
        end
      end
    end
    sleep 1 # Pause between repetitions
    counter += 1
  end
end

#Main
define:main do
  #Countdown
  sample :elec_triangle, amp: 0.6
  sleep 0.5
  sample :elec_triangle, amp: 0.5
  sleep 0.25
  sample :elec_triangle, amp: 0.4
  sleep 0.15
  sample :elec_triangle, amp: 0.3
  sleep 0.05
  
  #Main Pattern
  core
  
  #Transition to drums and higher energy
  sleep 2
  
  #External Samples
  sample "/Users/richardohia/Desktop/daWOP.wav", amp: 0.2, rate:  0.5, release: 0.75
  sample "/Users/richardohia/Desktop/ASMR.wav"
  sleep 18
  sample "/Users/richardohia/Desktop/yoruba-drums.wav", amp: 0.15, rate: 0.7, attack: 2
  sleep 10
  sample "/Users/richardohia/Desktop/igbo-flute.wav", amp: 0.1, rate: 0.7, attack: 4
  sleep 65
  
  #Transition to softer piano
  sample :elec_triangle, amp: 0.4
  sleep 0.5
  sample :elec_triangle, amp: 0.3
  sleep 0.25
  sample :elec_triangle, amp: 0.2
  sleep 0.15
  sample :elec_triangle, amp: 0.1
  sleep 0.05
  
  play chord(:C4, :minor), amp: 0.4, release: 3
  sample :drum_cymbal_closed, amp: 0.5, release: 3
  sample :drum_bass_soft, amp: 0.3
  sample :drum_snare_soft, amp: 0.2
  sample :ambi_choir, release: 3, amp: 0.5
  sleep 0.9
  
  # Creative Piano Pattern
  creative_piano_pattern(chord(:F4, :maj9))
  
  # Different variations of piano chord
  8.times do |i|
    case i
    when 0, 2, 4, 6
      creative_piano_pattern(chord(:F4, :maj9))
    when 1, 5
      creative_piano_pattern(chord(:G4, :maj9))
    when 3
      creative_piano_pattern(chord(:A4, :maj9))
    when 7
      creative_piano_pattern(chord(:Bb4, :maj9))
    end
  end
  
  sleep 1
  
  #Back to the start
  core
  
end

#Calling main function
main