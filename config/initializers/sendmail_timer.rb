puts 'init timer'
Thread.start do
  puts 'thread run'
  #loop do
    sleep 2
    puts 'begin send'
    #SendMail.confirm.deliver
    puts 'send over.'
  #end
end