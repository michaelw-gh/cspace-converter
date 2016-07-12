module CollectionSpace
  module Converter
    module GSBF
      include Default

      class GSBFLoanOut < LoanOut

        def convert
          run do |xml|
            CSXML.add xml, 'loanOutNumber', attributes["loanOutNumber"]
            CSXML.add xml, 'loanOutNote',   attributes["loanOutNote"]

            if attributes.fetch "lendersAuthorizer", nil
              CSXML::Helpers.add_person xml, 'lendersAuthorizer', attributes["lendersAuthorizer"]
            end

            ['lendersAuthorizationDate', 'loanReturnDate'].each do |date_type|
              if attributes.fetch date_type, nil
                date = attributes[date_type].to_s
                date = (date and date =~ /\d{4}/) ? format_date(date, "%Y") : format_date(date)
                CSXML.add xml, date_type, date
              end
            end
          end
        end

        def format_date(date, format = "%m/%d/%Y")
          Date.strptime(date, format).to_time.iso8601.to_s
        end

      end

    end
  end
end
