puts 'init timer'
Thread.start do
  puts 'thread run'
  loop do
    now_time = DateTime.now
    nd = now_time + 1.day
    nd = Time.parse(nd.strftime("%y-%m-%d"))
    sleep nd.to_f-now_time.to_f
    puts 'begin send'
    SendMail.confirm.deliver
    puts 'send over.'
  end
end