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

      raise "Invalid file #{filename}" unless File.file? filename

      puts "Project #{converter}; Batch #{batch}; Profile #{profile}"

      # process in chunks of 100 rows
      SmarterCSV.process(filename, { chunk_size: 100, keep_original_headers: true }) do |chunk|
        puts "Processing #{batch} #{counter}"
        ImportJob.perform_later(filename, batch, converter, profile, chunk)
        # run the job immediately when using rake
        Delayed::Worker.new.run(Delayed::Job.last)
        counter += 1
      end

      puts "Data import complete!"
    end
  end

  # rake db:nuke
  task :nuke => :environment do |t|
    [DataObject, Delayed::Job].each { |model| model.destroy_all }
  end
end

namespace :relationships do
  # rake relationships:generate[PBM,acquisition,acq1]
  task :generate, [:import_converter, :import_profile, :import_batch] => :environment do |t, args|
    import_converter = args[:import_converter]
    import_profile   = args[:import_profile]
    import_batch     = args[:import_batch]

    RelationshipJob.perform_later import_batch, import_converter, import_profile
    # run the job immediately when using rake
    Delayed::Worker.new.run(Delayed::Job.last)

    puts "Relationships created!"
  end
end

namespace :remote do
  namespace :action do

    task :delete, [:type, :batch] => :environment do |t, args|
      type       = args[:type]
      batch      = args[:batch]
      remote_action_process "delete", type, batch
    end

    task :transfer, [:type, :batch] => :environment do |t, args|
      type       = args[:type]
      batch      = args[:batch]
      remote_action_process "transfer", type, batch
    end

    def remote_action_process(action, type, batch)
      start_time = Time.now
      puts "Starting remote #{action} job at #{start_time}."
      TransferJob.perform_later(action, type, batch)
      # run the job immediately when using rake
      Delayed::Worker.new.run(Delayed::Job.last)

      end_time = Time.now
      puts "Remote #{action} job completed at #{end_time}."
    end

  end

end