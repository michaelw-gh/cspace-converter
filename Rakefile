# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

require 'csv'

namespace :data do
  namespace :procedure do

    # rake data:procedure:generate[ppsobjects1]
    task :generate, [:batch] => :environment do |t, args|
      batch = args[:batch]

      DataObject.where(batch: batch).entries.each do |object|
        converter_type  = object.read_attribute(:converter)
        profile_name    = object.read_attribute(:profile)
        converter_class = "CollectionSpace::Converter::#{converter_type}".constantize
        profiles        = converter_class.registered_profiles
        profile         = profiles[profile_name]
        raise "Invalid profile #{profile_name} for #{profiles}" unless profile

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
    # rake db:import:data[ppsobjectsdata1,PastPerfect,ppsobjectsdata,db/data/ppsobjectsdata.csv]
    task :data, [:batch, :converter, :profile, :filename] => :environment do |t, args|
      batch     = args[:batch]
      converter = args[:converter]
      profile   = args[:profile]
      filename  = args[:filename]

      csv_row_counter = 0
      data_counter    = 0

      CSV.foreach(File.join(Rails.root, filename), {
          headers: true,
          header_converters: ->(header) { header.to_sym },
        }) do |row|
          data = row.to_hash
          begin
            object = DataObject.new.from_json JSON.generate(data)
            object.write_attribute(:batch, batch)
            object.write_attribute(:converter, converter)
            object.write_attribute(:profile, profile)
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

  task :nuke => :environment do |t|
    DataObject.destroy_all
  end
end