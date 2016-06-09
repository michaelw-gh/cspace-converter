# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

require 'csv'

namespace :data do
  namespace :procedure do

    # rake data:procedure:generate[ppsobjectsdata]
    task :generate, [:profile] => :environment do |t, args|
      p = args[:profile]

      profiles = Rails.application.config.converter_class.constantize.registered_profiles
      profile  = profiles[p]
      raise "Invalid profile #{p} for #{profiles}" unless profile

      DataObject.all.entries.each do |object|
        profile.each do |procedure, attributes|
          data = {}
          # check for existence or update
          data[:type]       = procedure
          data[:identifier] = object.read_attribute( attributes["identifier"] )
          data[:title]      = object.read_attribute( attributes["title"] )
          data[:content]    = object.to_cspace_xml(procedure).to_s
          object.procedure_objects.build data
          object.save!
        end
      end

      puts "Procedure generation complete!"
    end

    # relationships

  end
end

namespace :db do
  namespace :import do
    # rake db:import:data[db/data/ppsobjectsdata.csv]
    task :data, [:filename, :procedures] => :environment do |t, args|
      DataObject.destroy_all
      filename   = args[:filename]
      procedures = args[:procedures]

      csv_row_counter = 0
      data_counter    = 0

      CSV.foreach(File.join(Rails.root, filename), {
          headers: true,
          header_converters: ->(header) { header.to_sym },
        }) do |row|
          data = row.to_hash
          begin
            object = DataObject.new.from_json JSON.generate(data)
            object.save!
            data_counter += 1
          rescue Exception => ex
            errors << "#{ex.message} for #{data}"
          end
          csv_row_counter += 1
      end

      puts "CSV ROWS READ:\t#{csv_row_counter}"
      puts "OBJECTS CREATED:\t#{data_counter}"
    end
  end
end