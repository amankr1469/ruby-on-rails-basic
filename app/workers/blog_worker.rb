class BlogWorker
  include Sidekiq::active_job
  sidekiq_options retry: false
  def perform(name) 
    puts "Im #{name}"
  end
end
