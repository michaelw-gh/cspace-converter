# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

require 'csv'

namespace :db do
  namespace :import do
    # rake db:import:procedures[db/data/ppsobjectsdata.csv]
    task :procedures, [:filename] => :environment do |t, args|
      ProcedureObject.destroy_all
      filename = args[:filename]

      csv_row_counter = 0
      data_counter    = 0

      CSV.foreach(File.join(Rails.root, filename), {
          headers: true,
          header_converters: ->(header) { header.to_sym },
        }) do |row|
          data = row.to_hash
          begin
            object = ProcedureObject.new.from_json JSON.generate(data)
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

# TODO: output relationships csv task
