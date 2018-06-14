# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

namespace :db do
  namespace :export do
    # rake db:export:xml
    task :xml => :environment do |t|
      # mongoid batches by default
      base = ['db', 'data', 'export']
      CollectionSpaceObject.all.each do |obj|
        path = Rails.root.join(File.join(base + [obj.category, obj.type, obj.subtype].compact))
        FileUtils.mkdir_p File.join(path)
        file_path = path + "#{obj.identifier}.xml"
        puts "Exporting: #{file_path}"
        File.open(file_path, 'w') {|f| f.write(obj.content) }
      end
    end
  end

  namespace :import do
    # rake db:import:data[ppsobjectsdata1,PastPerfect,ppsobjectsdata,db/data/ppsobjectsdata.csv]
    task :data, [:batch, :converter, :profile, :filename, :use_auth_cache_file] => :environment do |t, args|
      batch     = args[:batch]
      converter = args[:converter]
      profile   = args[:profile]
      filename  = args[:filename]
      use_previous_auth_cache = args[:use_auth_cache_file]
      counter   = 1

      raise "Invalid file #{filename}" unless File.file? filename

      puts "Project #{converter}; Batch #{batch}; Profile #{profile}"

      # process in chunks of 100 rows
      SmarterCSV.process(filename, {
          chunk_size: 100,
          convert_values_to_numeric: false,
        }.merge(Rails.application.config.csv_parser_options)) do |chunk|
        puts "Processing #{batch} #{counter}"
        ImportJob.perform_later(filename, batch, converter, profile, chunk, use_previous_auth_cache)
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
  # rake relationships:generate[acq1]
  task :generate, [:batch] => :environment do |t, args|
    batch = args[:batch]

    RelationshipJob.perform_later batch
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
      # don't scope to batch if "all" requested
      batch = batch == "all" ? nil : batch
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
