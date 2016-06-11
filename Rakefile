# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

namespace :db do
  namespace :import do
    # rake db:import:data[ppsobjectsdata1,PastPerfect,ppsobjectsdata,db/data/ppsobjectsdata.csv]
    task :data, [:batch, :converter, :profile, :filename] => :environment do |t, args|
      batch     = args[:batch]
      converter = args[:converter]
      profile   = args[:profile]
      filename  = args[:filename]
      counter   = 1

      # process in chunks of 100 rows
      SmarterCSV.process(filename, { chunk_size: 100 }) do |chunk|
        puts "Processing #{batch} #{counter}"
        ImportJob.perform_later(filename, batch, converter, profile, chunk)
        # # run the job immediately when using rake
        Delayed::Worker.new.run(Delayed::Job.last)
        counter += 1
      end

      puts "Data import complete!"
    end
  end

  task :nuke => :environment do |t|
    [DataObject, Delayed::Job].each { |model| model.destroy_all }
  end
end