# What ports/sockets to listen on, and what options for them.
listen "8888", :backlog => 100

# What the timeout for killing busy workers is, in seconds
timeout 60

# Whether the app should be pre-loaded
preload_app true

# How many worker processes
worker_processes 4

# What to do right before exec()-ing the new unicorn binary
before_exec do |server|
  ENV['BUNDLE_GEMFILE'] = './Gemfile'
end

# What to do before we fork a worker
before_fork do |server, worker|
  ActiveRecordConnection.teardown

  old_pid = './unicorn.pid.oldbin'
  if File.exists?(old_pid) && server.pid != old_pid
    begin
       Process.kill('QUIT', File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end

  sleep 1
end

# What to do after we fork a worker
after_fork do |server, worker|
  ActiveRecordConnection.start
end

# Where to drop a pidfile
pid './unicorn.pid'
